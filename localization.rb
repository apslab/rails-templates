say_status('locales', 'improve folder hier for storage locales', :green)
application("config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]")

empty_directory_with_gitkeep('config/locales/addons')
empty_directory_with_gitkeep('config/locales/commons')
empty_directory_with_gitkeep('config/locales/models')
empty_directory_with_gitkeep('config/locales/views')
empty_directory_with_gitkeep('config/locales/rails')

remove_file('config/locales/en.yml') if File.exist?('config/locales/en.yml')

# defaults
say_status('locales', 'create default locale files', :green)
create_file('config/locales/commons/en.yml') do
  %Q(
en:
  title: Application Title (please replace me)
  copyright: Copyright © %{year} Application name (please replace me)
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

# addons
say_status('locales', 'sorting addons locales if exists', :green)
run('mv config/locales/simple_form.en.yml config/locales/addons/simple_form.en.yml') if File.exist?('config/locales/simple_form.en.yml')

unless no?('enable suppor for spanish locale?(default: yes)')
  say_status('locales', 'turn on spanish locale', :green)
  application("config.i18n.default_locale = :'es-AR'")

  # rails
  say_status('locales', 'fetching spanish rails translations', :green)
  get('https://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/es-AR.yml', 'config/locales/rails/es-AR.yml')
  # common app
  say_status('locales', 'create spanish common translations', :green)
  create_file('config/locales/commons/es-AR.yml') do
    %Q(
'es-AR':
  title: Título de la aplicación por favor reemplazar
  subtitle: Subítulo de la aplicación por favor reemplazar
  copyright: Derechos de autor © %{year} Nombre de la aplicacion por favor reemplazar.
    )
  end
  # scaffolding
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

  say_status('locales', 'create spanish addons translations if exists', :green)
  if File.exist?('config/locales/addons/simple_form.en.yml')
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
      #  labels:
      #    password: 'Clave'
      #    user:
      #      new:
      #        email: 'E-mail para ingresar.'
      #      edit:
      #        email: 'E-mail.'
      #  hints:
      #    username: 'Nombre de usuario para ingresar.'
      #    password: 'Por favor, sin caracteres especiales.'
      )
    end
  end
end

