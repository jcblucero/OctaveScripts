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
## @deftypefn {} {@var{retval} =} rotateFrameByQuat (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: porqu <porqu@DESKTOP-MAAH8H2>
## Created: 2020-12-05

#https://www.mathworks.com/help/fusion/ug/rotations-orientation-and-quaternions.html
# conj(q) * Vquat * q
function retval = rotateFrameByQuat (quat_array, frame_vector)
  pkg load quaternion
  frame_quat = quaternion(0,frame_vector(1),frame_vector(2),frame_vector(3));
  #frame_quat = quaternion(0,0,0,1);
  quat = quaternion(quat_array(4),quat_array(1),quat_array(2),quat_array(3));
  
  retval = conj(quat) * frame_quat * quat;
endfunction
