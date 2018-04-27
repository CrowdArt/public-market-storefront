![Public Market Banner](.github/public_market_foundation_banner.jpg)

# Public Market Storefront

[![Build status](https://gitlab.com/publicmarket/public-market-storefront/badges/master/pipeline.svg)](https://gitlab.com/publicmarket/public-market-storefront/commits/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/8dd78c5be9a44e9ead13/maintainability)](https://codeclimate.com/github/abundance-labs/public-market-storefront/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8dd78c5be9a44e9ead13/test_coverage)](https://codeclimate.com/github/abundance-labs/public-market-storefront/test_coverage)

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
