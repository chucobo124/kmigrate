FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /kmigrate
WORKDIR /kmigrate
ADD Gemfile /kmigrate/Gemfile
ADD Gemfile.lock /kmigrate/Gemfile.lock
ADD Rakefile /kmigrate/Rakefile
RUN pwd
RUN apt-get update
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get install -y apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN apt-get update
RUN apt-get install -y --force-yes yarn
RUN bundle install
ADD . /kmigrate
