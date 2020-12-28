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
## @deftypefn {} {@var{retval} =} RotateVecToInertialFrame (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: porqu <porqu@DESKTOP-MAAH8H2>
## Created: 2020-12-13

#rotates a 3d vector (x,y,z) from body frame to inertial frame (earth) using quaternion
#quaternion is converted to rotation matrix, then matrix multiplied by vector
#Quaternion is given scalar first, (w,x,y,z) == (a,b,c,d)
function retval = RotateVecToInertialFrame_2(vec, quaternion)

  %rotation_matrix = [
  %  2*a_sq-1+2*b_sq, 2*(bc-ad), 2*(bd+ac);
  %  2*(bc+ad), 2*a_sq-1+2*c_sq, 2*(cd-ab);
  %  2*(bd-ac), 2*(cd+ab), 2*a_sq-1+2*d_sq;]
    
  #Rotation matrix from inertial to body
  q = quaternion;
  #R(1,1,:) = 2.*q(:,1).^2-1+2.*q(:,2).^2;
  R(1,1,:) = q(:,1).^2+q(:,2).^2-q(:,3).^2-q(:,4).^2;
  R(1,2,:) = 2.*(q(:,2).*q(:,3)+q(:,1).*q(:,4));
  R(1,3,:) = 2.*(q(:,2).*q(:,4)-q(:,1).*q(:,3));
  R(2,1,:) = 2.*(q(:,2).*q(:,3)-q(:,1).*q(:,4));
  #R(2,2,:) = 2.*q(:,1).^2-1+2.*q(:,3).^2;
  R(2,2,:) = q(:,1).^2-q(:,2).^2+q(:,3).^2-q(:,4).^2;
  R(2,3,:) = 2.*(q(:,3).*q(:,4)+q(:,1).*q(:,2));
  #R(2,3,:) = 2.*(q(:,3).*q(:,4)+q(:,1).*q(:,3)); #bad, double y from sentral data sheet
  R(3,1,:) = 2.*(q(:,2).*q(:,4)+q(:,1).*q(:,3));
  R(3,2,:) = 2.*(q(:,3).*q(:,4)-q(:,1).*q(:,2));
  #R(3,2,:) = 2.*(q(:,3).*q(:,4)-q(:,1).*q(:,3)); #bad, double y from setnral data sheet
  #R(3,3,:) = 2.*q(:,1).^2-1+2.*q(:,4).^2;
  R(3,3,:) = q(:,1).^2-q(:,2).^2-q(:,3).^2+q(:,4).^2;
  
  #vec = [0,0,1];
      
  #retval = R * vec;
  for i = 1:length(R(1,1,:))
    retval(i,:) = (R(:,:,i) * vec(i,:)')';
  endfor

endfunction
