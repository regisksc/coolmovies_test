import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'app/app_widget.dart';
import 'core/core.dart';

void main() async {
  await initHiveForFlutter();

  final graphql = GraphQLClient(link: link, cache: gqlCache);
  final client = ValueNotifier(graphql);

  runApp(GraphQLProvider(
    client: client,
    child: MyApp(graphql),
  ));
}
