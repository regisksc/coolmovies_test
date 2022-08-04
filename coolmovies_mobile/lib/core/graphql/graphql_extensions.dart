// ignore_for_file: unnecessary_this
import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../core.dart';

extension GQLRequestResultExtensions on QueryResult<Object?> {
  Future<Right<Failure, List<T>>> handleSuccessOnList<T>(
    StorageAdapter storage,
    String storageKey,
    Object Function(JSON) serializer,
  ) async {
    final json = this.data!;
    final mapList = json[storageKey]["nodes"] as List;
    // save storage
    await storage.write(storageKey, jsonEncode({storageKey: mapList}));
    // map result
    final modelList =
        mapList.map<T>((map) => serializer(map as JSON) as T).toList();
    return Right(modelList);
  }

  Future<Left<Failure, List<T>>> handleFailureOnList<T>(
    StorageAdapter storage,
    String storageKey,
    Object Function(JSON) serializer,
  ) async {
    debugPrint("Exception occured : \n${this.exception.toString()}");
    final error = this.data?['errors'][0];
    final message = error?['message'].toString();
    final storedValues = await storage.read(storageKey);
    final cachedModels = <T>[];

    if (storedValues.isNotEmpty) {
      final modelsMapList = storedValues[storageKey]["nodes"] as List;
      cachedModels
        ..addAll(modelsMapList.map((e) => serializer(e as JSON) as T).toList());
    }
    return Left(
      GQLRequestFailure(
        message ?? resultDataNullStringFor(query: storageKey),
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
    debugPrint('Query $storageKey ...');

    final gqlDocNode = gql(gqlQuery);
    final QueryResult result = await this.query(
      QueryOptions(document: gqlDocNode),
    );

    final hasErrors = result.data?.containsKey('errors') ?? true;
    final hasException = result.hasException || result.data == null;
    return hasErrors || hasException
        ? result.handleFailureOnList<T>(storage, storageKey, serializer)
        : result.handleSuccessOnList<T>(storage, storageKey, serializer);
  }
}
