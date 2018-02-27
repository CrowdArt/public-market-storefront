FROM ruby:2.4.3

EXPOSE 3000

RUN apt-get update -qq && apt-get install -yqq git vim

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -\
    && apt-get install -yqq nodejs

ENV YARN_VERSION=1.3.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -yqq yarn

WORKDIR /app
RUN mkdir -p /app/tmp/pids && chmod 775 /app/tmp/pids

ENV BUNDLER_VERSION=1.16.1
RUN gem install bundler --no-ri --no-rdoc -v "$BUNDLER_VERSION"

COPY . /app
