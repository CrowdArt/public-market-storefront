# Public market storefront

[![Build status](https://gitlab.com/publicmarket/storefront/badges/master/pipeline.svg)](https://gitlab.com/publicmarket/storefront/commits/master)

## Installing dependecies

```shell
brew install postgresql
brew services start postgresql
brew install elasticsearch
brew install memcached
brew services start memcached
brew install redis
brew services start redis
```

## Seed social authentication methods

```shell
rake db:seed_social_auth`
```
