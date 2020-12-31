
running_sum = 0;

##In rotated inertiall frame, y is forward (x) motion
integrate_series = inertial_accel_minus_g_1(:,2);
sum_series = zeros(length(integrate_series),1);
for i = 2:length(accel_x_y_z)
  
  #If foot is on ground (initial contact OR rest), don't integrate
  if gait_state_series(i) >= 1
    running_sum = 0;
  #Otherwise moving, integrate
  else
    low = integrate_series(i-1);
    high = integrate_series(i);
    dt = time(i) - time(i-1);
    running_sum += (low+high)/2 * dt;
  endif
  
  sum_series(i) = running_sum;
  
end

running_sum

