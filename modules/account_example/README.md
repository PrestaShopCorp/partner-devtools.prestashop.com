# SaaS App Example module

## Install

### Requirement

* [Composer](https://getcomposer.org/doc/00-intro.md) installed
* [Node](https://nodejs.org/en/) installed (14.x)
* [Yarn 1](https://yarnpkg.com/getting-started/install) installed


## Build module

### First build

```sh
$ composer install
$ yarn --cwd _dev/apps install --frozen-lockfile
$ ./createModule.sh
```

### Rebuild

```sh
$ ./createModule.sh
```