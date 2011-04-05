# gems
say_status('design', 'add gems', :green)
gem 'haml-rails'
gem 'hpricot', :group => [:development, :test]
gem 'ruby_parser', :group => [:development, :test]
say_status('design', 'add compass without integration', :green)
gem 'compass', :group => [:development, :test]

# custom application configs
say_status('design', 'turn off scaffold stylesheets generate', :green)
application do
  %Q(
    # turn off scaffold stylesheets generate
    config.generators do |generator|
      generator.stylesheets false
    end
  )
end

# layout & issues layout
say_status('design', 'remove erb template layout', :green)
remove_file('app/views/layouts/application.html.erb')
say_status('design', 'get template, helper, assets and issues for new layout', :green)
get('https://github.com/apslab/rails-templates/raw/assets/helpers/layout_helper.rb', 'app/helpers/layout_helper.rb')
empty_directory_with_gitkeep('app/views/shared')
get('https://github.com/apslab/rails-templates/raw/assets/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml')
get('https://github.com/apslab/rails-templates/raw/assets/views/shared/_header.html.haml', 'app/views/shared/_header.html.haml')
get('https://github.com/apslab/rails-templates/raw/assets/views/shared/_footer.html.haml', 'app/views/shared/_footer.html.haml')
get('https://github.com/apslab/rails-templates/raw/assets/views/shared/_sidebar.html.haml', 'app/views/shared/_sidebar.html.haml')

# jQuery
say_status('jQuery', 'fetching jQuery UJS adapter (github HEAD)', :green)
get 'https://github.com/rails/jquery-ujs/raw/master/src/rails.js', 'public/javascripts/rails.js'

jquery_normal_assets = 'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js'
jquery_minify_assets = 'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'

if yes?('Would you like to install Jquery UI?(default: no)')
  jquery_normal_assets << ' https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.js'
  jquery_minify_assets << ' https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js'
end

say_status('jQuery', 'config javascript expansions :defaults to jQuery', :green)
%w(development test).each do |non_production_enviroment|
  inject_into_file "config/environments/#{non_production_enviroment}.rb", "\n\n  config.action_view.javascript_expansions[:defaults] = %w(#{jquery_normal_assets}) + %w(rails)", :after => /^.*::Application\.configure do/, :verbose => false
end
inject_into_file 'config/environments/production.rb', "\n\n  config.action_view.javascript_expansions[:defaults] = %w(#{jquery_minify_assets}) + %w(rails)", :after => /^.*::Application\.configure do/, :verbose => false

# form builder
apply('https://github.com/apslab/rails-templates/raw/master/form_builder.rb')

#TODO: run compass to create config files

