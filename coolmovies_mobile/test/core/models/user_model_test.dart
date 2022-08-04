import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers/mock_objects.dart';

void main() {
  test(
    "test toJson",
    () async {
      // Arrange
      final model = mockUserModel;
      // Act
      final json = model.toJson;
      // Assert
      expect(
        json,
        equals(
          {
            "id": model.id,
            "name": model.name,
            "commentsByUserId": {"nodes": model.comments}
          },
        ),
      );
    },
  );
}
