#!/bin/bash

cd ..
echo '############################### Running formatters #######################################'
flutter pub global activate import_sorter 
flutter format --line-length="120" . 
flutter pub run import_sorter:main