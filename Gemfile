source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'awesome_print', '~> 1.8.0'
gem 'bcrypt', '~> 3.1.11'
gem 'bootstrap-sass', '3.4.1'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'carrierwave', '1.1.0'
gem 'chartkick'
gem 'coffee-rails', '~> 4.2'
gem 'faker', '1.7.3'
gem 'fog-aws', '2.0.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '4.3.1'
gem 'mini_magick', '4.9.4'
gem "nokogiri", ">= 1.10.4"
gem 'puma', '~> 4.3'
gem 'rails', '~> 5.1.2'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate', '3.1.6'

group :development, :test do
  gem 'byebug', platform: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'rubocop'
  gem 'selenium-webdriver'
  gem 'sqlite3', '1.3.13'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'minitest-reporters',       '1.1.14'
  gem 'rails-controller-testing', '1.0.2'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Added at 2018-05-07 19:10:13 +0100 by xavier:
gem "httparty", "~> 0.16.2"
