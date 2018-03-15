FROM ruby:2.5.0

EXPOSE 3000

# node setup installs node sources and runs apt-get update
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
    && apt-get install -yqq git vim nodejs

WORKDIR /app

RUN mkdir -p /app/tmp/pids \
    && chmod 775 /app/tmp/pids

ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_PATH=/vendor/bundle

ENV BUNDLER_VERSION=1.16.1
RUN gem install bundler --no-ri --no-rdoc -v "$BUNDLER_VERSION"
