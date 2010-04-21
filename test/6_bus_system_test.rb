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

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'rpowerflow'

Struct.new('Bus', :id, :voltage, :angle, :mw, :mvar, :slack, :avr, :susceptance)
Struct.new('Branch', :id, :resistance, :reactance, :charging)

system = ::RPowerFlow::System.new

bus01 = Struct::Bus.new(1, 1.0, 0.0,  0.00,  0.00,  true, true,  0.0)
bus02 = Struct::Bus.new(2, 1.0, 0.0,  1.10, -0.04, false, true,  0.0)
bus03 = Struct::Bus.new(3, 1.0, 0.0, -0.85, -0.17, false, false, 0.0)
bus04 = Struct::Bus.new(4, 1.0, 0.0, -0.40,  0.08, false, false, 0.0)
bus05 = Struct::Bus.new(5, 1.0, 0.0, -0.20, -0.04, false, false, 0.0)
bus06 = Struct::Bus.new(6, 1.0, 0.0, -0.20, -0.04, false, false, 0.0)

system << bus01
system << bus02
system << bus03
system << bus04
system << bus05
system << bus06

line01 = Struct::Branch.new(1, 0.0912, 0.48, 0.0282)
line02 = Struct::Branch.new(2, 0.0342, 0.18, 0.0106)
line03 = Struct::Branch.new(3, 0.1140, 0.60, 0.0352)
line04 = Struct::Branch.new(4, 0.0228, 0.12, 0.0071)
line05 = Struct::Branch.new(5, 0.0228, 0.12, 0.0071)
line06 = Struct::Branch.new(6, 0.0228, 0.12, 0.0071)
line07 = Struct::Branch.new(7, 0.0228, 0.12, 0.0071)
line08 = Struct::Branch.new(8, 0.0342, 0.18, 0.0106)
line09 = Struct::Branch.new(9, 0.1140, 0.60, 0.0352)

system[bus01, bus02] = line01
system[bus01, bus03] = line02
system[bus02, bus04] = line03
system[bus03, bus04] = line04
system[bus03, bus05] = line05
system[bus04, bus05] = line06
system[bus05, bus06] = line07
system[bus01, bus03] = line08
system[bus02, bus04] = line09

puts "Solved in #{::RPowerFlow::Solver::FullNewton.solve(system, 50, 0.01)} iterations"
puts

system.buses.each { |b| puts b.inspect }
