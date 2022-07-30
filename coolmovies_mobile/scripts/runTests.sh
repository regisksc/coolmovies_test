#!/bin/bash

cd ..
echo '############################### Set up #######################################'
sudo apt-get update
sudo apt-get -y install lcov
flutter pub global activate remove_from_coverage
echo '############################### Removing generated files #####################'
flutter pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info
echo '############################### Generating coverage ##########################'
genhtml coverage/lcov.info -o coverage/html