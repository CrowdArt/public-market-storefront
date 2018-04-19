FROM "registry.gitlab.com/publicmarket/storefront/base:latest"

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -yqq \
      cron \
      vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./config/deploy/cron-start /bin/cron-start

COPY . /app
