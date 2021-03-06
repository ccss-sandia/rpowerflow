# Copyright (2006-2010) Sandia Corporation.
# Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
# the U.S. Government retains certain rights in this software.
#
# Author: Bryan T. Richardson, Sandia National Laboratories, btricha@sandia.gov
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2.1 of the License, or (at
# your option) any later version.
#
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

Gem::Specification.new do |s| 
  s.name              = %q{rpowerflow}
  s.version           = '0.5.1'
  s.authors           = ['Bryan T. Richardson']
  s.email             = %q{btricha@sandia.gov}
  s.date              = %q{2010-04-20}
  s.summary           = %q{Steady-state electric power flow program}
  s.description       = %q{Steady-state electric power flow program using Newton-Raphson}
  s.homepage          = %q{http://ccss-sandia.github.com/rpowerflow}
  s.files             = Dir["{lib,test}/**/*", 'CHANGELOG', 'LICENSE', 'README.md'].to_a
  s.require_paths     = ['lib']
  s.has_rdoc          = false

  s.add_dependency('narray')
end
