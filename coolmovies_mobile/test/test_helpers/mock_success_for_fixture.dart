import 'dart:convert';

import 'package:coolmovies/core/core.dart';

import '../fixtures/fixture_reader.dart';

JSON mockSuccessForFixture(String fixturePath) {
  return (jsonDecode(fixture(fixturePath)))['data'] as JSON;
}

JSON mockGraphQLRequestFailure() {
  return {
    "errors": [
      {"message": "generic error message"}
    ]
  };
}
