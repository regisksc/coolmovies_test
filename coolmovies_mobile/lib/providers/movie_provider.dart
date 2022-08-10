import '../core/core.dart';
import '../repositories/repositories.dart';
import 'providers.dart';

class MoviesProvider extends DefaultProvider {
  MoviesProvider(MovieRepository repository) : _repository = repository;
  final MovieRepository _repository;

  final _movies = <MovieModel>[];
  List<MovieModel> get movies => _movies;
  String currentMovieId = '';
  Future getMovies() async {
    lastRequestFailure = null;
    final moviesOrError = await _repository.getAllMovies();
    moviesOrError.fold(
      (failure) {
        lastRequestFailure = failure;
        if (lastRequestFailure is GQLRequestFailure) {
          _movies.addAll(
            (lastRequestFailure! as GQLRequestFailure).valuesFromStorage
                as List<MovieModel>,
          );
        }
      },
      (movies) {
        final mov = [...movies, ...movies, ...movies];
        _movies.addAll(mov);
      },
    );
    notifyListeners();
  }

  final _reviews = <String, List<MovieReviewModel>>{};
  Map<String, List<MovieReviewModel>> get reviews => _reviews;
  Set<String> moviesWithAllReviewsLoaded = {};
  bool isLoadingMoreReviews = false;
  int lastFetchedPage = 0;

  void resetFetchingReviewState() {
    isLoadingMoreReviews = false;
  }

  Future getReviewsForMovieId(String id) async {
    if (moviesWithAllReviewsLoaded.contains(id) || isLoadingMoreReviews) return;
    await Future.delayed(const Duration(milliseconds: 10));
    isLoadingMoreReviews = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () async {
      // simulating api latency
      final reviewsOrError = await _repository.getMovieReviewsFor(
        id,
        page: lastFetchedPage++,
      );
      reviewsOrError.fold(
        (failure) => null,
        (reviewsFromApi) {
          if (reviewsFromApi.length < reviewsPerPage)
            moviesWithAllReviewsLoaded.addAll({id});
          if (_reviews.containsKey(id)) {
            _reviews.addAll({id: _reviews[id]!..addAll(reviewsFromApi)});
          }
          if (!_reviews.containsKey(id)) _reviews.addAll({id: reviewsFromApi});
        },
      );
      isLoadingMoreReviews = false;
      notifyListeners();
    });
  }

  void addReview({required UserModel user}) {
    final newReview = MovieReviewModel(
      movieId: currentMovieId,
      id: "",
      title: "",
      body: "",
      rating: 5,
      createdBy: user,
    );
    newReview.isInEditState = true;
    _reviews[currentMovieId]!.insert(0, newReview);
    notifyListeners();
  }

  void startEditingReview(MovieReviewModel review) {
    review.backup();
    if (review.isInEditState == false) {
      review.isInEditState = true;
      notifyListeners();
    }
  }

  void update() => notifyListeners();

  void stopEditingReview(
    UserModel user,
    MovieReviewModel review, {
    bool shouldSave = false,
  }) {
    review.isInEditState = false;
    final canSave = review.body.isNotEmpty && review.title.isNotEmpty;
    if (canSave && shouldSave) {
      final remoteWork = review.reviewBackup != null
          ? _repository.remoteEditReview
          : _repository.remoteAddReview;
      Future.wait([
        remoteWork(
          movieId: review.movieId,
          userId: user.id,
          review: review,
        ),
        _repository.storeMovies(movies),
      ]);
    } else {
      _deleteOrDiscard(canSave, review);
    }

    review.reviewBackup = null;
    notifyListeners();
  }

  void _deleteOrDiscard(
    bool canSave,
    MovieReviewModel review,
  ) {
    if (canSave || review.hasReviewBackup) {
      review.discardChanges();
    } else {
      _reviews[currentMovieId]!.remove(review);
    }
    review.reviewBackup = null;
  }

  void resetEditState() {
    final reviews = _reviews[currentMovieId] ?? [];
    reviews..forEach((review) => review.isInEditState = false);
    reviews
        .removeWhere((review) => review.title.isEmpty || review.body.isEmpty);
  }
}
