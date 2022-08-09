import '../core/core.dart';
import '../repositories/repositories.dart';
import 'providers.dart';

class MoviesProvider extends DefaultProvider {
  MoviesProvider(MovieRepository repository) : _repository = repository;

  final _movies = <MovieModel>[];

  List<MovieModel> get movies => _movies;

  final MovieRepository _repository;

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

  void _deleteOrDiscard(bool canSave, MovieReviewModel review) {
    if (canSave || review.reviewBackup != null) {
      review.discardChanges();
    } else {
      movies
          .firstWhere((movie) => movie.reviews.contains(review))
          .removeReview(review);
    }
    review.reviewBackup = null;
  }

  void resetEditState(MovieModel movie) {
    if (!movie.reviews.any((review) => review.isInEditState)) return;
    movie.reviews..forEach((review) => review.isInEditState = false);
  }

  void addReview({
    required MovieModel movie,
    required UserModel user,
  }) {
    final newReview = MovieReviewModel(
      movieId: movie.id,
      id: "",
      title: "",
      body: "",
      rating: 5,
      createdBy: user,
    );
    newReview.isInEditState = true;
    movie.reviews.insert(0, newReview);
    notifyListeners();
  }

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
      (movies) => _movies.addAll(movies),
    );
    notifyListeners();
  }
}
