FROM ruby:2.6-alpine

ENV RUBYGEMS_VERSION=3.2.3
ENV BUNDLER_VERSION=2.4.22

RUN mkdir -p /app
WORKDIR /app

COPY . /app

RUN gem update --system ${RUBYGEMS_VERSION} && gem install bundler -v ${BUNDLER_VERSION}
RUN apk add --no-cache bash nodejs mysql-client mysql-dev sqlite-dev less
RUN apk add --no-cache alpine-sdk \
      --virtual .build_deps libxml2-dev libxslt-dev zlib zlib-dev \
      && cd /app \
      && bundle install -j4 --without postgresql:sqlite \
      && apk del alpine-sdk .build_deps \
      && rm -rf /tmp/* /var/cache/apk/*

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
