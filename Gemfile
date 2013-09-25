source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.0'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
#gem "bootstrap-sass", "~> 2.3.2.2"
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
#gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :github => 'anjlab/bootstrap-rails'
gem 'figaro'
gem 'haml-rails'
gem 'high_voltage'
gem 'simple_form', '>= 3.0.0.rc'
gem 'bcrypt-ruby', '3.0.1'

group :assets do
  gem 'therubyracer', :platform=>:ruby
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'hub', :require=>nil
  gem 'quiet_assets'
end

group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'factory_girl_rails', '4.2.0'
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  # Uncomment this line on OS X.
  # gem 'growl', '1.0.3'

  # Uncomment these lines on Linux.
  gem 'libnotify', '0.8.0'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
  # gem 'wdm', '0.1.0'  
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
