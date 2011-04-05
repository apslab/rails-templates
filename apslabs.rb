# This file is part of rails-templates (https://github.com/apslab/rails-templates) - application template and various custom templates to overrides generals rails generators
# Copyright (C) 2011 - Luis Petek <lmpetek@gmail.com>, Maximiliano Dello Russo <maxidr@gmail.com> and Luis E. Guardiola <lguardiola@gmail.com>
#
# rails-templates is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

#
# Usage:
#   rails new myapp -T -J -m https://github.com/apslab/rails-templates/raw/master/apslabs.rb
#

# custom generators and templates overrides
say_status("fetching", "custom generators and templates overrides", :green)
inside('lib') do
  run('git clone git://github.com/apslab/generators.git')
  remove_dir('generators/.git')

  run('git clone -b templates git://github.com/apslab/rails-templates.git templates')
  remove_dir('templates/.git')
end

# design
say_status("design", "turn off scaffold stylesheets generate", :green)
application do
  %Q(
    # turn off scaffold stylesheets generate
    config.generators do |generator|
      generator.stylesheets false
    end
  )
end
say_status("design", "add gems", :green)
gem 'haml-rails'
gem 'hpricot', :group => [:development, :test]
gem 'ruby_parser', :group => [:development, :test]
say_status("design", "add compass without integration", :green)
gem 'compass', :group => [:development, :test]
#TODO: run compass to create config files

say_status("design", "replace erb template engine system to haml", :green)
remove_file('app/views/layouts/application.html.erb')
get('https://github.com/apslab/rails-templates/raw/assets/views/layouts/application.html.haml', 'app/views/layouts/application.html.haml')
say_status("design", "add shared view folders for common partials", :green)
empty_directory_with_gitkeep('app/views/shared')

# timezone
application("config.time_zone = 'Buenos Aires'")

if yes?('Would you like to manage forms with simple_form?')
  gem 'simple_form'
  run('bundle install')
  generate('simple_form:install')
end

# testing
say_status("testing", "add gems", :green)
gem 'rspec-rails', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]

say_status("testing", "config default behaviours to use testing framework with RSpec and FactoryGirl", :green)
application do
  %Q(
    # Here is where we reap the benefits of the modularity in Rails 3.
    # What this says is that we want to use RSpec as the test framework and we want to generate fixtures
    # with our generated specs, but we don't want to generate view specs and
    # that instead of fixtures, we actually want to use factory girl and
    # we want the factories to be put into spec/factories. Whew! So does this all work?
    config.generators do |generator|
      generator.test_framework :rspec, :fixture => true, :views => true
      generator.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
  )
end

run('bundle install')
generate('rspec:install')
append_file('.rspec') do
  '--format nested #documentation'
end

# jQuery
say_status("jQuery", "fetching jQuery UJS adapter (github HEAD)", :green)
get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

jquery_normal_assets = "https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js"
jquery_minify_assets = "https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"

if yes?("Would you like to install Jquery UI?")
  jquery_normal_assets << " https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.js"
  jquery_minify_assets << " https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"
end

say_status("jQuery", "config javascript expansions :defaults to jQuery", :green)
%w(development test).each do |non_production_enviroment|
  inject_into_file "config/environments/#{non_production_enviroment}.rb", "\n\n  config.action_view.javascript_expansions[:defaults] = %w(#{jquery_normal_assets}) + %w(rails)", :after => /^.*::Application\.configure do/, :verbose => false
end
inject_into_file 'config/environments/production.rb', "\n\n  config.action_view.javascript_expansions[:defaults] = %w(#{jquery_minify_assets}) + %w(rails)", :after => /^.*::Application\.configure do/, :verbose => false

# locales
empty_directory_with_gitkeep('config/locales/addons')
empty_directory_with_gitkeep('config/locales/commons')
empty_directory_with_gitkeep('config/locales/models')
empty_directory_with_gitkeep('config/locales/views')

remove_file('config/locales/en.yml') if File.exist?('config/locales/en.yml')
create_file('config/locales/commons/en.yml') do
  %Q(
en:
  title: Application Title please replace me
  slogan: Application slogan please replace me
  copyright: Copyright © %{year} Application name please replace me.
  )
end
create_file('config/locales/commons/scaffold.en.yml') do
  %Q(
en:
  scaffold:
    notice:
      created: %{item} was successfully created.
      updated: %{item} was successfully updated.
      destroyed: %{item} was successfully destroyed.
      empty: not records yet.
    actions:
      show: show
      edit: edit
      destroy: destroy
      destroy_confirm: Are you sure?
      new: new %{item}
      list: %{item} - listing
      back: back
      save: save
  )
end

run('mv config/locales/simple_form.en.yml config/locales/addons/simple_form.en.yml')

unless no?('enable suppor for spanish locale?(default: yes)')
  application do
    %Q(
      config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
      config.i18n.default_locale = :'es-AR'
    )
  end
  empty_directory_with_gitkeep('config/locales/rails')
  get('https://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/es-AR.yml', 'config/locales/rails/es-AR.yml')
  create_file('config/locales/commons/es-AR.yml') do
    %Q(
'es-AR':
  title: Título de la aplicación por favor reemplazar
  subtitle: Subítulo de la aplicación por favor reemplazar
  copyright: Derechos de autor © %{year} Nombre de la aplicacion por favor reemplazar.
    )
  end
  create_file('config/locales/commons/scaffold.es-AR.yml') do
    %Q(
'es-AR':
  scaffold:
    notice:
      created: %{item} creado satisfactoriamente.
      updated: %{item} actualizado satisfactoriamente.
      destroyed: %{item} eliminado satisfactoriamente.
      empty: no hay registros aún.
    actions:
      show: mostrar
      edit: editar
      destroy: eliminar
      destroy_confirm: está seguro?
      new: nuevo %{item}
      list: %{item} - listado
      back: volver
      save: guardar
    )
  end
  create_file('config/locales/addons/simple_form.es-AR.yml') do
    %Q(
'es-AR':
  simple_form:
    yes: 'Si'
    no: 'No'
    required:
      text: 'requerido'
      mark: '*'
      # You can uncomment the line below if you need to overwrite the whole required html.
      # When using html, text and mark won't be used.
      # html: '<abbr title="required">*</abbr>'
    error_notification:
      default_message: "Se encontraron algunos errores, por favor revise lo siguiente:"
    # Labels and hints examples
    #labels:
    #   password: 'Clave'
    #   user:
    #     new:
    #       email: 'E-mail para ingresar.'
    #     edit:
    #       email: 'E-mail.'
    # hints:
    #   username: 'Nombre de usuario para ingresar.'
    #   password: 'Por favor, sin caracteres especiales.'
    )
  end if File.exist?('config/locales/addons/simple_form.en.yml')
end

# git
git :init
git :add => '.'
git :commit => ' -m "Initial commit!"'

# heroku
if yes?('would you like to use heroku?')
  heroku_app_name = File.basename(destination_root)
  heroku_base_domain = 'apslabs.com.ar'
  heroku_custom_domain = ask("what custom domain would you like to run this application? [default: #{heroku_app_name}.#{heroku_base_domain}]")
  heroku_custom_domain = [heroku_app_name, heroku_base_domain].join('.') if heroku_custom_domain.blank?
  run("heroku create #{heroku_app_name}")

  run('heroku addons:update logging:expanded')
  run('heroku addons:add sendgrid:free')

  run('heroku addons:add memcache:5mb')
  gem('dalli')
  run('bundle install')
  inject_into_file('config/environments/production.rb',
                  :after => /^.*::Application\.configure do/,
                  :verbose => false) do
    %Q(
      # turn on memcache with dalli for heroku
      config.generators do |generator|
        config.cache_store = :dalli_store
      end
    )
  end

  run('heroku addons:add custom_domains:basic')
  run("heroku domains:add #{heroku_custom_domain}")

  collaborator_emails = ask?('please enter a space separated collaborator\'s emails list, if you need them:')
  collaborator_emails.split.compact.each do |collaborator_email|
    run("heroku sharing:add #{collaborator_email}")
  end

  if yes?('do you use Amazon S3 service?')
    create_file 'config/amazon_s3.yml' do
      %Q(
defaults: &defaults
  # On Heroku, add your Amazon credentials to config vars:
  #   $ heroku config:add S3_KEY=123 S3_SECRET=xyz S3_BUCKET=mybucket
  #
  # Otherwise replace these expressions with your credentials.
  access_key_id: <%= ENV['S3_KEY'] %>
  secret_access_key: <%= ENV['S3_SECRET'] %>

  # Remember that bucket names must be unique across all of Amazon S3.
  # Check name availability online: http://bucket.heroku.com/
  # If needed, configure per-environment bucket names in the bottom.
  bucket: #{heroku_app_name}

  # http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?RESTAccessPolicy.html#RESTCannedAccessPolicies
  s3_permissions: :public_read
  # set to HTTPS when read permissions are more restrictive
  s3_protocol: http

development:
  <<: *defaults

production:
  <<: *defaults

      )
    end

    s3_key=ask('please enter Amazon S3 key:')
    s3_key='PLEASE REPLACE ME' if s3_key.blank?
    s3_secret=ask('please enter Amazon S3 secret:')
    s3_secret='PLEASE REPLACE ME' if s3_secret.blank?
    run("heroku config:add S3_KEY=#{s3_key} S3_SECRET=#{s3_secret}")

    git :add => ' config/amazon_s3.yml'
    git :commit => ' -m "add Amazon S3 config example!"'
  end
  git :push => ' heroku master'
  run('heroku open')
end

