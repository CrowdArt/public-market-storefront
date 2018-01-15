## Setup sym and decrypt developments settings

Using private key and password from 1Password:

```
sym -ipx bookstore.key
sym -k bookstore.key -d -f config/settings/secrets/development.yml.enc -o config/settings/development.yml
```

## Development Setup

To start development dependencies, execute:

```
bin/dev-services -d
```

To run migrations:

```
rake db:create && rake db:migrate
```

# Themes

To install theme: `rake db:seed_theme`
