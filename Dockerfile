FROM ruby:3.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

EXPOSE 4567

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
