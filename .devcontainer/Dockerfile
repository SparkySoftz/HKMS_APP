# Use the official Ruby image
FROM ruby:3.3.0

# Set environment variables
ENV RAILS_ENV=development
ENV NODE_ENV=development

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libvips \
  sqlite3 \
  nodejs \
  yarn

# Create app directory
RUN mkdir -p /home/dev/myhotel

# Set working directory
WORKDIR /home/dev/myhotel

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]