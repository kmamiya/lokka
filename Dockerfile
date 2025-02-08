FROM ruby:3.4.1-alpine

ENV RUBYGEMS_VERSION=3.6.2
ENV BUNDLER_VERSION=2.6.2

RUN mkdir -p /app
WORKDIR /app

COPY . /app

RUN gem install bundler -v ${BUNDLER_VERSION}
RUN apk add --no-cache bash nodejs mysql-client mysql-dev sqlite-dev less
RUN apk add --no-cache alpine-sdk \
      --virtual .build_deps libxml2-dev libxslt-dev zlib zlib-dev \
      && cd /app \
      && bundle install -j4 --without postgresql:sqlite \
      && apk del alpine-sdk .build_deps \
      && rm -rf /tmp/* /var/cache/apk/*

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
