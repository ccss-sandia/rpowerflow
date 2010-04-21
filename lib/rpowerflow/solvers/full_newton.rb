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

require 'complex'

begin
  require 'linalg'
rescue LoadError
  require 'rubygems'
  require 'narray'
end

module RPowerFlow
  module Solver
    class FullNewton
      # Currently returns the number of iterations required to
      # solve the system provided. Updates the system in place
      # with the calculated values.
      #
      # TODO: exceptions!
      # Throw an exception if the solver fails to converge.
      # Both the Linalg and NArray packages throw an exception
      # when an LU solve is attempted against a singular matrix.
      #
      # TODO: logging!
      def self.solve(system, max_iterations, tolerance)
        size       = system.buses.length
        iterations = 0

        max_iterations.times do
          # First half of power and delta arrays are
          # Mw values, second half are Mvar values.
          #
          # TODO: reset rather than create (possible?)
          if defined?(Linalg)
            power = Linalg::DMatrix.columns [Array.new(size * 2, 0.0)]
            delta = Linalg::DMatrix.columns [Array.new(size * 2, 0.0)]
          else
            power = NVector.float(size * 2)
            delta = NVector.float(size * 2)
          end

          jacobian = system.jacobian do |i, mw, mvar|
            bus  = system.buses[i]

            power[i]        += mw
            power[i + size] += mvar

            # As the calculated power of each bus is updated
            # above, the change in power for each bus is also
            # calculated. We could do this at the end, but it
            # would require another loop. Not sure which is
            # more expensive... doing these calculations over
            # and over again unnecessarily or doing another loop.
            # Looks like a good spot for a benchmark!
            #
            # TODO: benchmark!
            delta[i]        = bus.mw - power[i]
            delta[i + size] = bus.mvar + (bus.voltage ** 2 * bus.susceptance) - power[i + size]
          end

          tolerable = true
          (0...size).each do |i|
            bus = system.buses[i]

            # In terms of power values, Mw is a given for voltage
            # regulated, non-slack buses and Mw and Mvar are givens
            # for load buses.
            #
            # If this is a voltage regulated bus and it's not
            # the slack bus, only check to see if Mw is within
            # error range. Else, it's a load bus, so check to
            # see if both Mw and Mvar are within error range.
            if bus.avr
              unless bus.slack
                tolerable = false if delta[i].abs > tolerance
              end
            else
              tolerable = false if delta[i].abs > tolerance || delta[i + size] > tolerance
            end
          end

          # If given power values are within error range,
          # update the system buses with the calculated
          # power values and end the solve. Otherwise, solve
          # the next iteration of voltage and angle values.
          if tolerable
            (0...size).each do |i|
              bus = system.buses[i]

              bus.mw   = power[i]
              bus.mvar = power[i + size]
            end

            # Break out of the iterations loop
            # since we've solved the system.
            break
          else
            if defined?(Linalg)
              x = Linalg::DMatrix.solve(jacobian, delta)
            else
              x = jacobian.lu.solve(delta)
            end

            # Update system bus voltage and angle
            # values such that they can be used for
            # the next round of power and Jacobian
            # formulations.
            (0...size).each do |i|
              bus = system.buses[i]

              bus.voltage += x[i + size]
              bus.angle   += x[i]
            end

            # Update the iteration count since we
            # had to do another linear solve.
            iterations += 1
          end
        end

        return iterations
      end
    end
  end
end
