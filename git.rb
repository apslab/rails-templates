say_status('git', 'append more .gitignore rules', :green)
append_to_file '.gitignore' do
  %Q(.dotest/
nbproject/
.DS_Store
*.nogit
*~
*.swp
public/system/
config/database.yml
db/*.sqlite*
)
end

say_status('git', 'create and commit repository', :green)
git :init
git :add => '.'
git :commit => ' -m "Initial commit!"'

