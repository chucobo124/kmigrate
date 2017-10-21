FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /kmigrate
WORKDIR /kmigrate
ADD Gemfile /kmigrate/Gemfile
ADD Gemfile.lock /kmigrate/Gemfile.lock
ADD Rakefile.lock /kmigrate/Rakefile.lock
RUN pwd
RUN bundle install
ADD . /kmigrate
