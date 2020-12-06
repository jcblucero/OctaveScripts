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
## @deftypefn {} {@var{retval} =} quat2dcm (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: porqu <porqu@DESKTOP-MAAH8H2>
## Created: 2020-12-05

#https://www.mathworks.com/help/aerotbx/ug/quatrotate.html
#qw,qx,qy,qz
function retval = quat2dcm (q0 ,q1 ,q2 ,q3)
  q2_sq = q2* q2;
  q0_sq = q0*q0;
  q1_sq = q1*q1;
  q3_sq = q3*q3;
  
  q1q2 = q1*q2;
  q0q3 = q0*q3;
  q1q3 = q1*q3;
  q0q2 = q0*q2;
  q2q3 = q2*q3;
  q0q1 = q0*q1;
  
  retval = [
    (1-2*q2_sq-2*q3_sq), 2*(q1q2+q0q3), 2*(q1q3-q0q2);
    2*(q1q2-q0q3), (1-2*q1_sq-2*q3_sq), 2*(q2q3+q0q1);
    2*(q1q3+q0q2), 2*(q2q3-q0q1), (1-2*q1_sq-2*q2_sq);];

endfunction
