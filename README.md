RPowerFlow
==========

This project provides a steady-state electric power flow program written
in Ruby, based off both the Ruby linalg and Ruby narray libraries.

The program will provide both AC and DC solvers, and the AC solver will be
capable of both Full and Decoupled Newton solves.

The [Ruby linalg library](http://github.com/quix/linalg) is a Fortran-based
linear albegra library, and the [Ruby narray library](http://narray.rubyforge.org/)
is a pure-Ruby linear algebra library. Neither are capable of handling sparse
matrices, thus this project will have a limit as to how big of a power system
it can handle.

Current Status
==============

As of 04-21-2010, both the linalg and narray libraries are supported. Linalg is
loaded first, and if that fails then narray is loaded. A Full Newton solver is
implemented, and two tests exist.

Requirements
============

Either the Ruby linalg or Ruby narray package is necessary (just one, not both).

Ruby linalg is somewhat hard to install on later versions of Ubuntu since it
relies on some Fortran libraries no longer provided in the repositories. One
way around this is to download the required .deb file from the Debian Etch
repository and force the install.

Ruby narray can be installed as a gem.

TODO
====

* Package as a gem and host gem on Rubygems
* Check for expected methods on buses and branches as they are added to the system
* Add a Decoupled Newton solver
* Add a DC solver
* Provide examples of more complex systems
* Allow for enforcement of generator reactive power limits

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
