source 'https://rubygems.org'

ruby '2.1.0'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'sinatra'
gem 'sinatra-activerecord'
gem 'sinatra-reloader'
gem 'sinatra-contrib'
gem 'sqlite3'
gem 'haml'
gem 'redcarpet'

# Test requirements
group :development, :test do
  gem 'rspec', '~> 3.0'
  gem 'rack-test', :require => 'rack/test'
  gem 'coveralls', require: false
  gem 'rubocop', require: false
  gem 'guard'
  gem 'guard-rake'
  gem 'terminal-notifier-guard'
  gem 'guard-rubocop'
end

