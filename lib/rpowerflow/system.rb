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
  # TODO: logging!
  class System
    def initialize(args = Hash.new)
      @buses    = Hash.new
      @branches = Hash.new
    end

    def <<(*args)
      args.flatten.each do |bus|
        @buses[bus] = Array.new
      end

      @bus_array = nil
      @size      = nil
    end

    def []=(*args)
      branch            = args.pop
      @branches[branch] = args.flatten

      @branch_array = nil
      @ybus         = nil
    end

    def size
      return @size ||= buses.length
    end

    # TODO: check for required accessors
    def buses(branch = nil)
      if branch
        return @branches[branch]
      else
        return @bus_array ||= @buses.keys.sort { |a,b| a.id <=> b.id }
      end
    end

    # TODO: check for required accessors
    def branches(bus = nil)
      if bus
        return @buses[bus]
      else
        return @branch_array ||= @branches.keys
      end
    end

    def ybus
      return @ybus unless @ybus.nil?

      @ybus = Array.new(size) { Array.new(size, 0.0) }

      # TODO: account for transformers
      branches.each do |branch|
        impedance  = Complex(branch.resistance, branch.reactance)
        charging   = Complex(0, branch.charging)
        mini       = Array.new(2) { Array.new }
        mini[0][0] =  (1 / impedance) + charging
        mini[0][1] = -(1 / impedance)
        mini[1][0] =  mini[0][1]
        mini[1][1] =  mini[0][0]

        endpoints = buses(branch)
        source    = buses.index(endpoints.first)
        target    = buses.index(endpoints.last)

        @ybus[source][source] += mini[0][0]
        @ybus[source][target] += mini[0][1]
        @ybus[target][source] += mini[1][0]
        @ybus[target][target] += mini[1][1]
      end

      return @ybus
    end

    def jacobian(print = false)
      if defined?(Linalg)
        jac = Linalg::DMatrix.new(size * 2, size * 2)
      else
        jac = NMatrix.float(size * 2, size * 2)
      end

      (0...size).each do |i|
        source = buses[i]

        (0...size).each do |j|
          target = buses[j]

          if block_given?
            mw   = source.voltage * ybus[i][j].abs * target.voltage * Math.cos(source.angle - target.angle - ybus[i][j].arg)
            mvar = source.voltage * ybus[i][j].abs * target.voltage * Math.sin(source.angle - target.angle - ybus[i][j].arg)

            # Yield the index of the current bus and
            # the incremental Mw and Mvar values.
            yield i, mw, mvar
          end

          if source.slack
            if i == j
              jac[i,i]               = 1e+10
              jac[i + size,i + size] = 1e+10
#               jac[i,i]               = 1.0
#               jac[i + size,i + size] = 1.0
            else
              jac[i,j]               = 0.0
              jac[i,j + size]        = 0.0
              jac[j,i]               = 0.0
              jac[j + size,i]        = 0.0
              jac[i + size,j]        = 0.0
              jac[i + size,j + size] = 0.0
              jac[j,i + size]        = 0.0
              jac[j + size,i + size] = 0.0
            end
          else
            if i == j
              (0...size).each do |k|
                jac[i,i] += ybus[i][k].abs * buses[k].voltage * Math.sin(source.angle - buses[k].angle - ybus[i][k].arg) unless i == k

                if source.avr
                  jac[i + size,i + size] = 1e+10
#                   jac[i + size,i + size] = 1.0
                else
                  jac[i,i + size]        += ybus[i][k].abs * buses[k].voltage * Math.cos(source.angle - buses[k].angle - ybus[i][k].arg)
                  jac[i + size,i]        += ybus[i][k].abs * buses[k].voltage * Math.cos(source.angle - buses[k].angle - ybus[i][k].arg) unless i == k
                  jac[i + size,i + size] += ybus[i][k].abs * buses[k].voltage * Math.sin(source.angle - buses[k].angle - ybus[i][k].arg)
                end
              end

              jac[i,i] *= -source.voltage

              unless source.avr
                jac[i,i + size]        +=  source.voltage * ybus[i][i].abs * Math.cos(ybus[i][i].arg)
                jac[i + size,i]        *=  source.voltage
                jac[i + size,i + size] += -source.voltage * ybus[i][i].abs * Math.sin(ybus[i][i].arg)
              end
            else
              unless target.slack
                jac[i,j] = source.voltage * ybus[i][j].abs * target.voltage * Math.sin(source.angle - target.angle - ybus[i][j].arg)

                if source.avr
                  jac[i,j + size] = source.voltage * ybus[i][j].abs * Math.cos(source.angle - target.angle - ybus[i][j].arg) unless target.avr
                else
                  unless target.avr
                    jac[i,j + size]        =  source.voltage * ybus[i][j].abs * Math.cos(source.angle - target.angle - ybus[i][j].arg)
                    jac[i + size,j]        = -source.voltage * ybus[i][j].abs * target.voltage * Math.cos(source.angle - target.angle - ybus[i][j].arg)
                    jac[i + size,j + size] =  source.voltage * ybus[i][j].abs * Math.sin(source.angle - target.angle - ybus[i][j].arg)
                  end
                end
              end
            end
          end
        end
      end

      return jac
    end

    def print_ybus
      (0...size).each do |i|
        format = Array.new
        data   = Array.new

        (0...size).each do |j|
          element = ybus[i][j]

          format << "%.1f+%.1fj"
          data   << element.real
          data   << element.imag
        end

        puts format.join("\t") % data
        puts
      end
    end

    def print_jacobian
      jac = jacobian

      (0...size * 2).each do |i|
        format = Array.new
        data   = Array.new

        (0...size * 2).each do |j|
          format << "%.2f"
          data   << jac[i,j]
        end

        puts format.join("\t") % data
        puts
      end
    end
  end
end
