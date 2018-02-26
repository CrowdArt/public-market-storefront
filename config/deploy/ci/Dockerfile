FROM "registry.gitlab.com/publicmarket/storefront:latest"

RUN curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update -qq && apt-get install -yqq google-chrome-stable
