FROM "registry.gitlab.com/publicmarket/storefront/base:latest"

RUN apt-get install -yqq \
      cron \
      vim

ADD ./config/deploy/cron-start /bin/cron-start

COPY . /app
