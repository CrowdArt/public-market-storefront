# Public market storefront

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
