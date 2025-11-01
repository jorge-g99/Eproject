# Use official Ruby image
FROM ruby:3.2

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock first
COPY Gemfile Gemfile.lock ./

# Install bundler and all gems, including WEBrick
RUN gem install bundler && bundle install

# Copy the rest of the application
COPY . .

# Expose Sinatra port
EXPOSE 4567

# Start Sinatra in development mode, binding to all interfaces
CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
