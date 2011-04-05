say_status("fetching", "custom generators and templates overrides", :green)
inside('lib') do
  run('git clone git://github.com/apslab/generators.git')
  remove_dir('generators/.git')

  run('git clone -b templates git://github.com/apslab/rails-templates.git templates')
  remove_dir('templates/.git')
end

