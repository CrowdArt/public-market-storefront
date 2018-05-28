FROM ruby:2.5.0

EXPOSE 3000

# node setup installs node sources and runs apt-get update
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
    && apt-get install -yqq --no-install-recommends \
        git \
        nodejs

ENV YARN_VERSION=1.7.0
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -yqq --no-install-recommends yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

RUN mkdir -p /app/tmp/pids \
    && chmod 775 /app/tmp/pids

ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH=/vendor/bundle

ENV BUNDLER_VERSION=1.16.2
RUN gem install bundler --no-ri --no-rdoc -v "$BUNDLER_VERSION"
