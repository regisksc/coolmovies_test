#!/bin/bash

cd ..
echo '############################### Running code metrics #######################################'
flutter pub global activate dart_code_metrics 
flutter pub global run dart_code_metrics:metrics lib --reporter=html
echo '############################### Code metrics generated under metrics directory #############'