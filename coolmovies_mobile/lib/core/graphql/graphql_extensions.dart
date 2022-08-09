// ignore_for_file: unnecessary_this

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../core.dart';

extension GQLRequestResultExtensions on QueryResult<Object?> {
  Future<Right<Failure, T>> handleSuccessOnOne<T>(
    StorageAdapter storage,
    String storageKey,
    Object Function(JSON) serializer,
  ) async {
    final json = this.data!;
    final individual = json[storageKey];
    // save storage
    await storage.write(storageKey, {storageKey: individual});
    // map result
    final model = serializer(individual as JSON) as T;
    return Right(model);
  }

  Future<Left<Failure, T>> handleFailureOnOne<T>(
    StorageAdapter storage,
    String storageKey,
    Object Function(JSON) serializer,
  ) async {
    debugPrint("Exception occured : \n${this.exception.toString()}");
    final error = this.data?['errors'][0];
    final message = error?['message'].toString();
    final storedValue = await storage.read(storageKey);

    T? model;
    if (storedValue.isNotEmpty) {
      final individual = storedValue[storageKey];
      model = serializer(individual as JSON) as T;
    }
    return Left(
      GQLRequestFailure(
        message ?? resultDataNullStringFor(request: storageKey),
        valuesFromStorage: model,
      ),
    );
  }

  Future<Right<Failure, List<T>>> handleSuccessOnList<T>(
    StorageAdapter storage,
    String storageKey,
    Object Function(JSON) serializer,
  ) async {
    final json = this.data!;
    final list = json[storageKey]["nodes"] as List;
    // save storage
    await storage.write(storageKey, {
      storageKey: {'nodes': list}
    });
    // map result
    final models = list.map<T>((map) => serializer(map as JSON) as T).toList();
    return Right(models);
  }

  Future<Left<Failure, List<T>>> handleFailureOnList<T>(
    StorageAdapter storage,
    String storageKey,
    Object Function(JSON) serializer,
  ) async {
    debugPrint("Exception occured : \n${this.exception.toString()}");
    final error = this.data?['errors']?[0];
    final message = error?['message'].toString();
    final storedValues = await storage.read(storageKey);
    final cachedModels = <T>[];

    if (storedValues.isNotEmpty) {
      final modelsMapList = storedValues[storageKey]['nodes'] as List;
      cachedModels
        ..addAll(modelsMapList.map((e) => serializer(e as JSON) as T).toList());
    }
    return Left(
      GQLRequestFailure(
        message ?? resultDataNullStringFor(request: storageKey),
        valuesFromStorage: cachedModels,
      ),
    );
  }
}

extension GraphQLClientExtensions on GraphQLClient {
  Future<Either<Failure, List<T>>> performFetchListQuery<T>(
    StorageAdapter storage, {
    required String storageKey,
    required String gqlQuery,
    required Object Function(JSON) serializer,
  }) async {
    final result = await _performQuery(storageKey, gqlQuery);

    final hasErrors = result.data?.containsKey('errors') ?? true;
    final hasException = result.hasException || result.data == null;
    return hasErrors || hasException
        ? result.handleFailureOnList<T>(storage, storageKey, serializer)
        : result.handleSuccessOnList<T>(storage, storageKey, serializer);
  }

  Future<Either<Failure, T>> performFetchOneQuery<T>(
    StorageAdapter storage, {
    required String storageKey,
    required String gqlQuery,
    required Object Function(JSON) serializer,
  }) async {
    final result = await _performQuery(storageKey, gqlQuery);

    final hasErrors = result.data?.containsKey('errors') ?? true;
    final hasException = result.hasException || result.data == null;
    return hasErrors || hasException
        ? result.handleFailureOnOne<T>(storage, storageKey, serializer)
        : result.handleSuccessOnOne<T>(storage, storageKey, serializer);
  }

  Future<Failure?> performMutation<T>({
    required String gqlQuery,
  }) async {
    final result = await _performMutation(gqlQuery);
    final hasErrors = result.data?.containsKey('errors') ?? true;
    final hasException = result.hasException || result.data == null;
    if (hasErrors || hasException) {
      debugPrint("Exception occured : \n${result.exception.toString()}");
      if (result.data != null) jsonLogger(result.data!);
      final error = result.data?['errors'][0];
      final message = error?['message'].toString();
      return GQLRequestFailure(
        message ?? resultDataNullStringFor(request: 'mutation'),
      );
    }
    return null;
  }

  Future<QueryResult<Object?>> _performQuery(
      String storageKey, String gqlQuery) async {
    debugPrint('Query $storageKey ...');

    final gqlDocNode = gql(gqlQuery);
    final result = await this.query(QueryOptions(document: gqlDocNode));
    return result;
  }

  Future<QueryResult<Object?>> _performMutation(String gqlMutation) async {
    final gqlDocNode = gql(gqlMutation);
    final result = await this.mutate(MutationOptions(document: gqlDocNode));
    return result;
  }
}
