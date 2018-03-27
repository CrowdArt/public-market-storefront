# Public Market Storefront

[![Build status](https://gitlab.com/publicmarket/storefront/badges/master/pipeline.svg)](https://gitlab.com/publicmarket/storefront/commits/master)
[![Coverage report](https://gitlab.com/gitlab-org/gitlab-ce/badges/master/coverage.svg)](https://gitlab.com/publicmarket/storefront/commits/master)

## Install Dependencies

```shell
brew install postgresql
brew services start postgresql
brew install elasticsearch
brew install memcached
brew services start memcached
brew install redis
brew services start redis
```

## Seed the Database

```shell
rake db:setup
```

## Import Sample Products

Sample products can be imported with a rake task:

```shell
rake spree_sample:book_samples
```

## Index Products

For search to work you'll need to manually update the products index:

```shell
rake searchkick:reindex CLASS=Spree::Product
```

## Startup the Server

```shell
./bin/dev_server
```

You should now now be able to access the storefront at http://localhost:5000
