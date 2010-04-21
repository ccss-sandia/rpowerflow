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

bus01 = Struct::Bus.new(1,  1.060, 0.0,  0.000,  0.000,  true, true,  0.0)
bus02 = Struct::Bus.new(2,  1.045, 0.0,  0.183, -0.127, false, true,  0.0)
bus03 = Struct::Bus.new(3,  1.010, 0.0, -0.942, -0.190, false, true,  0.0)
bus04 = Struct::Bus.new(4,  1.000, 0.0, -0.478,  0.039, false, false, 0.0)
bus05 = Struct::Bus.new(5,  1.000, 0.0, -0.076, -0.016, false, false, 0.0)
bus06 = Struct::Bus.new(6,  1.070, 0.0, -0.112, -0.075, false, true,  0.0)
bus07 = Struct::Bus.new(7,  1.000, 0.0,  0.000,  0.000, false, false, 0.0)
bus08 = Struct::Bus.new(8,  1.090, 0.0,  0.000,  0.000, false, true,  0.0)
bus09 = Struct::Bus.new(9,  1.000, 0.0, -0.295, -0.166, false, false, 0.0)
bus10 = Struct::Bus.new(10, 1.000, 0.0, -0.090, -0.058, false, false, 0.0)
bus11 = Struct::Bus.new(11, 1.000, 0.0, -0.035, -0.018, false, false, 0.0)
bus12 = Struct::Bus.new(12, 1.000, 0.0, -0.061, -0.016, false, false, 0.0)
bus13 = Struct::Bus.new(13, 1.000, 0.0, -0.135, -0.058, false, false, 0.0)
bus14 = Struct::Bus.new(14, 1.000, 0.0, -0.149, -0.050, false, false, 0.0)

system << bus01
system << bus02
system << bus03
system << bus04
system << bus05
system << bus06
system << bus07
system << bus08
system << bus09
system << bus10
system << bus11
system << bus12
system << bus13
system << bus14

line01 = Struct::Branch.new(1,  0.01938, 0.05917, 0.0528)
line02 = Struct::Branch.new(2,  0.05403, 0.22304, 0.0492)
line03 = Struct::Branch.new(3,  0.04699, 0.19797, 0.0438)
line04 = Struct::Branch.new(4,  0.05811, 0.17632, 0.0340)
line05 = Struct::Branch.new(5,  0.05695, 0.17388, 0.0346)
line06 = Struct::Branch.new(6,  0.06701, 0.17103, 0.0128)
line07 = Struct::Branch.new(7,  0.01335, 0.04211, 0.0000)
line08 = Struct::Branch.new(8,  0.00000, 0.20912, 0.0000)
line09 = Struct::Branch.new(9,  0.00000, 0.55618, 0.0000)
line10 = Struct::Branch.new(10, 0.00000, 0.25202, 0.0000)
line11 = Struct::Branch.new(11, 0.09498, 0.19890, 0.0000)
line12 = Struct::Branch.new(12, 0.12291, 0.25581, 0.0000)
line13 = Struct::Branch.new(13, 0.06615, 0.13027, 0.0000)
line14 = Struct::Branch.new(14, 0.00000, 0.17615, 0.0000)
line15 = Struct::Branch.new(15, 0.00000, 0.11001, 0.0000)
line16 = Struct::Branch.new(16, 0.03181, 0.08450, 0.0000)
line17 = Struct::Branch.new(17, 0.12711, 0.27038, 0.0000)
line18 = Struct::Branch.new(18, 0.08205, 0.19207, 0.0000)
line19 = Struct::Branch.new(19, 0.22092, 0.19988, 0.0000)
line20 = Struct::Branch.new(20, 0.17093, 0.34802, 0.0000)

system[bus01, bus02] = line01
system[bus01, bus05] = line02
system[bus02, bus03] = line03
system[bus02, bus04] = line04
system[bus02, bus05] = line05
system[bus03, bus04] = line06
system[bus04, bus05] = line07
system[bus04, bus07] = line08
system[bus04, bus09] = line09
system[bus05, bus06] = line10
system[bus06, bus11] = line11
system[bus06, bus12] = line12
system[bus06, bus13] = line13
system[bus07, bus08] = line14
system[bus07, bus09] = line15
system[bus09, bus10] = line16
system[bus09, bus14] = line17
system[bus10, bus11] = line18
system[bus12, bus13] = line19
system[bus13, bus14] = line20

puts "Solved in #{::RPowerFlow::Solver::FullNewton.solve(system, 100, 0.1)} iterations"
puts

system.buses.each { |b| puts b.inspect }
