FROM ruby:2.2

RUN apt-get update -qq && apt-get install -y build-essential --force-yes

WORKDIR /app

COPY Gemfile* /app/
RUN bundle install
COPY . /app

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
