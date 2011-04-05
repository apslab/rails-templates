if yes?('would you like to use heroku?(default: no)')
  heroku_app_name = File.basename(destination_root)
  heroku_default_cutom_domain = 'apslabs.com.ar'
  heroku_suggest_custom_domain = [heroku_app_name, heroku_default_cutom_domain].join('.')
  heroku_custom_domain = ask("what custom domain would you like to run this application? (default: #{heroku_suggest_custom_domain})")
  heroku_custom_domain = heroku_suggest_custom_domain if heroku_custom_domain.blank?
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

  git :add => ' .'
  git :commit => ' -m "add final bundle.lock for heroku with caching gems and configs!"'

  run('heroku addons:add custom_domains:basic')
  run("heroku domains:add #{heroku_custom_domain}")

  collaborator_emails = ask('please enter a space separated collaborator\'s emails list, if you need them:')
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

