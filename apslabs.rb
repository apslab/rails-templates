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

# design
apply('https://github.com/apslab/rails-templates/raw/master/graphic_design.rb')

# custom generators and templates overrides
apply('https://github.com/apslab/rails-templates/raw/master/custom_generators_and_templates_overrides.rb')

# testing
apply('https://github.com/apslab/rails-templates/raw/master/testing.rb')

# localization
apply('https://github.com/apslab/rails-templates/raw/master/localization.rb')
# -- timezone
application("config.time_zone = 'Buenos Aires'")

# git
apply('https://github.com/apslab/rails-templates/raw/master/git.rb')

# heroku
apply('https://github.com/apslab/rails-templates/raw/master/heroku.rb')

