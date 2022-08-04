import 'dart:io';

import 'package:graphql_flutter/graphql_flutter.dart';

AuthLink get authLink => AuthLink(
      getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    );

HttpLink get httpLink => HttpLink(
      Platform.isAndroid
          ? 'http://10.0.2.2:5001/graphql'
          : 'http://localhost:5001/graphql',
    );

Link get link => authLink.concat(httpLink);

GraphQLCache get gqlCache => GraphQLCache(
      store: HiveStore(),
    );
