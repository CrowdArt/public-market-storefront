FROM ruby:2.4.3

RUN apt-get update && apt-get -y install git
RUN gem install bundler --no-ri --no-rdoc

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -\
    && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

COPY . /app
WORKDIR /app

ADD ./config/deploy/app/bundle_config /usr/local/bundle/config

RUN mkdir -p /app/tmp/pids && chmod 775 /app/tmp/pids

ENV BUNDLE_PATH=/bundle \
    GEM_HOME=/bundle

EXPOSE 3000

