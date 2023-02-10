source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "omniauth"
gem "omniauth-oauth2"
gem "rdoc"

gem "rails-controller-testing", github: "rails/rails-controller-testing"

gem "responders", "~> 3.0"

gem "sprockets-rails"
#gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
# gem "redis", "~> 4.0"
# gem "kredis"
# gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sassc-rails"
gem "image_processing", "~> 1.2"
gem 'bootstrap', '~> 5.2', '>= 5.2.3'
gem 'devise', '~> 4.8', '>= 4.8.1'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end
group :development do
  gem "web-console"
  # gem "rack-mini-profiler"
  # gem "spring"
end
group :test do
  gem "nokogiri", "< 1.13"
  gem "omniauth-facebook"
  gem "omniauth-openid"
  gem "rexml"
  gem "timecop"
  gem "webrat", "0.7.3", require: false
  gem "mocha", "~> 1.1", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

platforms :ruby do
  gem "sqlite3", "~> 1.4"
end
