# Contributing

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][1]
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][1]
* by reviewing patches

[1]: https://github.com/abundance-labs/public-market-storefront/issues

---

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
