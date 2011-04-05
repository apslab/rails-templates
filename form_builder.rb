# simple form
if use_simple_form?
  gem 'simple_form'
  run('bundle install')
  generate('simple_form:install')
end

