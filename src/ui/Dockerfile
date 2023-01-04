FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y ruby-full ruby-dev build-essential --force-yes \
  && gem install bundler:1.17.2 --no-ri --no-rdoc

WORKDIR /app

COPY Gemfile* /app/
RUN bundle install
COPY . /app

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
