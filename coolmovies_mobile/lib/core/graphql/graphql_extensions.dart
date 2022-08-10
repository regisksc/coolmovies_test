// ignore_for_file: unnecessary_this

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../core.dart';

extension GQLRequestResultExtensions on QueryResult<Object?> {
  Future<Right<Failure, T>> handleSuccessOnOne<T>({
    required Object Function(JSON) serializer,
    StorageAdapter? storage,
    String? mapKey,
  }) async {
    final json = this.data!;
    final individual = json[mapKey];
    final canStore = storage != null && mapKey != null;
    if (canStore) {
      // save storage
      await storage.write(mapKey, {mapKey: individual});
    }
    // map result
    final model = serializer(individual as JSON) as T;
    return Right(model);
  }

  Future<Left<Failure, T>> handleFailureOnOne<T>({
    StorageAdapter? storage,
    String? mapKey,
    Object Function(JSON)? serializer,
  }) async {
    debugPrint("Exception occured : \n${this.exception.toString()}");
    final error = this.data?['errors'][0];
    final message = error?['message'].toString();
    T? model;
    if (storage != null && mapKey != null && serializer != null) {
      final storedValue = await storage.read(mapKey);

      if (storedValue.isNotEmpty) {
        final individual = storedValue[mapKey];
        model = serializer(individual as JSON) as T;
      }
    }
    return Left(
      GQLRequestFailure(
        message ?? resultDataNullStringFor(request: mapKey ?? 'GraphQL'),
        valuesFromStorage: model,
      ),
    );
  }

  Future<Right<Failure, List<T>>> handleSuccessOnList<T>({
    StorageAdapter? storage,
    String? mapKey,
    required Object Function(JSON) serializer,
  }) async {
    final json = this.data!;
    final list = json[mapKey]["nodes"] as List;
    if (storage != null && mapKey != null) {
      // save storage
      await storage.write(mapKey, {
        mapKey: {'nodes': list}
      });
    }

    // map result
    final models = list.map<T>((map) => serializer(map as JSON) as T).toList();
    return Right(models);
  }

  Future<Left<Failure, List<T>>> handleFailureOnList<T>({
    StorageAdapter? storage,
    String? mapKey,
    Object Function(JSON)? serializer,
  }) async {
    debugPrint("Exception occured : \n${this.exception.toString()}");
    final error = this.data?['errors']?[0];
    final message = error?['message'].toString();
    final cachedModels = <T>[];
    if (storage != null && mapKey != null && serializer != null) {
      final storedValues = await storage.read(mapKey);

      if (storedValues.isNotEmpty) {
        final modelsMapList = storedValues[mapKey]['nodes'] as List;
        cachedModels
          ..addAll(
              modelsMapList.map((e) => serializer(e as JSON) as T).toList());
      }
    }

    return Left(
      GQLRequestFailure(
        message ?? resultDataNullStringFor(request: mapKey ?? 'GraphQL'),
        valuesFromStorage: cachedModels,
      ),
    );
  }
}

extension GraphQLClientExtensions on GraphQLClient {
  Future<Either<Failure, List<T>>> performFetchListQuery<T>({
    required String gqlQuery,
    required Object Function(JSON) serializer,
    StorageAdapter? storage,
    String? mapKey,
  }) async {
    final result = await _performQuery(gqlQuery, mapKey: mapKey);

    final hasErrors = result.data?.containsKey('errors') ?? true;
    final hasException = result.hasException || result.data == null;
    final handler = hasErrors || hasException
        ? result.handleFailureOnList<T>
        : result.handleSuccessOnList<T>;
    return handler(
      storage: storage,
      mapKey: mapKey,
      serializer: serializer,
    );
  }

  Future<Either<Failure, T>> performFetchOneQuery<T>({
    required String gqlQuery,
    required Object Function(JSON) serializer,
    StorageAdapter? storage,
    String? mapKey,
  }) async {
    final result = await _performQuery(gqlQuery, mapKey: mapKey);

    final hasErrors = result.data?.containsKey('errors') ?? true;
    final hasException = result.hasException || result.data == null;
    final handler = hasErrors || hasException
        ? result.handleFailureOnOne<T>
        : result.handleSuccessOnOne<T>;
    return handler(
      storage: storage,
      mapKey: mapKey,
      serializer: serializer,
    );
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
    String gqlQuery, {
    String? mapKey,
  }) async {
    debugPrint('Query ${mapKey ?? "GraphQL"} ...');

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
