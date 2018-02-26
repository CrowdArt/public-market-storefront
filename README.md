# Public market storefront

[![Build status](https://gitlab.com/publicmarket/bookstore/badges/master/pipeline.svg)](https://gitlab.com/publicmarket/bookstore/commits/master)
[![Coverage](https://gitlab.com/publicmarket/bookstore/badges/master/coverage.svg)](https://gitlab.com/publicmarket/bookstore/commits/master)

## Installing dependecies

```shell
brew install postgresql
brew services start postgresql
brew install memcached
brew services start memcached
brew install redis
brew services start redis
```

## Themes

To install theme:

```shell
rake db:seed_theme`
```
