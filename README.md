RPowerFlow
==========

This project WILL provide a steady-state electric power flow program written
in Ruby, based off both the Ruby linalg and Ruby narray libraries.

The program will provide both AC and DC solvers, and the AC solver will be
capable of both Full and Decoupled Newton solves.

The [Ruby linalg library](http://github.com/quix/linalg) is a Fortran-based
linear albegra library, and the [Ruby narray library](http://narray.rubyforge.org/)
is a pure-Ruby linear algebra library. Neither are capable of handling sparse
matrices, thus this project will have a limit as to how big of a power system
it can handle.

More to come...

Legal Notice
============

Copyright (2006-2010) Sandia Corporation.
Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
the U.S. Government retains certain rights in this software.

Contact: Bryan T. Richardson, Sandia National Laboratories, btricha@sandia.gov

This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or (at
your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this library; if not, write to the Free Software Foundation, Inc.,
59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
