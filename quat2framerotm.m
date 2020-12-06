## Copyright (C) 2020 porqu
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} quat2framerotm (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: porqu <porqu@DESKTOP-MAAH8H2>
## Created: 2020-12-05

#For reference : https://www.mathworks.com/help/fusion/ref/quaternion.rotmat.html
function retval = quat2framerotm (a, b, c, d)
  a_sq = a * a;
  b_sq = b * b;
  c_sq = c * c;
  d_sq = d * d;
  
  bc = b * c;
  ad = a * d;
  bd = b*d;
  ac = a*c;
  cd = c*d;
  ab = a*b;
  
  retval = [
    2*a_sq-1+2*b_sq, 2*(bc+ad), 2*(bd-ac);
    2*(bc-ad), 2*a_sq-1+2*c_sq, 2*(cd+ab);
    2*(bd+ac), 2*(cd-ab), 2*a_sq-1+2*d_sq;]
endfunction
