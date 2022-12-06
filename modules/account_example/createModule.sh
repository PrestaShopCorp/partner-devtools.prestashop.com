#!/bin/sh

yarn --cwd _dev/apps build-skip-eslint
cd ..
zip -r account_example.zip account_example -x '*.git*' \
          account_example/_dev/\* \
          account_example/dist/\* \
          account_example/composer.phar \
          account_example/Makefile \
          account_example/account_example.zip
mv account_example.zip ./account_example
