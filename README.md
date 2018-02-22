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

## Setup sym and decrypt developments settings

Using private key and password from 1Password:

```shell
sym -ipx bookstore.key
sym -k bookstore.key -d -f config/settings/secrets/development.yml.enc -o config/settings/development.yml
```

## Development Setup

To start development dependencies, execute:

```shell
bin/dev-services -d
```

To run migrations:

```shell
rake db:create && rake db:migrate
```

## Themes

To install theme:

```shell
rake db:seed_theme`
```
