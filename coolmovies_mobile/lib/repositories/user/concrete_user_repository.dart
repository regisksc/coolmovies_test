import 'package:either_dart/either.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/core.dart';
import 'user_repository.dart';

class ConcreteUserRepository extends UserRepository {
  ConcreteUserRepository(
    this.client,
    this.storage,
  );
  final GraphQLClient client;
  final StorageAdapter storage;

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() {
    return client.performFetchOneQuery<UserModel>(
      storage: storage,
      mapKey: 'currentUser',
      gqlQuery: GQLQueries.getCurrentUser,
      serializer: UserModel.fromJson,
    );
  }
}
