# simple form
if yes?('Would you like to install simple_form builder?(default: no)')
  gem 'simple_form'
  run('bundle install')
  generate('simple_form:install')
end

