say_status('testing', 'add gems', :green)
gem 'rspec-rails', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]

say_status('testing', 'config default behaviours to use testing framework with RSpec and FactoryGirl', :green)
application do
  %Q(
    # Here is where we reap the benefits of the modularity in Rails 3.
    # What this says is that we want to use RSpec as the test framework and we want to generate fixtures
    # with our generated specs, but we don't want to generate view specs and
    # that instead of fixtures, we actually want to use factory girl and
    # we want the factories to be put into spec/factories. Whew! So does this all work?
    config.generators do |generator|
      generator.test_framework :rspec, :fixture => true, :views => true
      generator.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  )
end

say_status('testing', 'default setup', :green)
run('bundle install')
generate('rspec:install')
append_file('.rspec') do
  '--format nested #documentation'
end

