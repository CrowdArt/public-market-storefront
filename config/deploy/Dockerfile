FROM "registry.gitlab.com/publicmarket/public-market-storefront/base:latest"

WORKDIR /app

COPY Gemfile* /app/

RUN bundle install --deployment --jobs 4 --without development test

COPY . /app

RUN RAILS_ENV=production DEVISE_SECRET_KEY="abc123" SECRET_KEY_BASE="a" bundle exec rake assets:precompile
RUN RAILS_ENV=production DEFACE_ENABLED="true" DEVISE_SECRET_KEY="abc123" SECRET_KEY_BASE="a" bundle exec rake deface:precompile
