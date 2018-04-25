FROM "registry.gitlab.com/publicmarket/public-market-storefront/base:latest"

# setup chrome for feature specs
RUN curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -yqq google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /app
