
pkg load signal;

running_sum = 0;

##In rotated inertiall frame, y is forward (x) motion
#integrate_series = inertial_accel_minus_g_1(:,2);
#sum_series = zeros(length(integrate_series),1);
integrate_series = inertial_accel_minus_g_1(:,:);
sum_series = accel_x_y_z .* 0;


##for i = 2:length(accel_x_y_z)
##  
##  #If foot is on ground (initial contact OR rest), don't integrate
##  if gait_state_series(i) >= 1
##    #running_sum = 0;
##    running_sum = [0 0 0];
##  #Otherwise moving, integrate
##  else
##    low = integrate_series(i-1,:);
##    high = integrate_series(i,:);
##    #dt = time(i) - time(i-1);
##    dt = atime(i) - atime(i-1);
##    running_sum += (low+high)/2 * dt;
##  endif
##  
##  sum_series(i,:) = running_sum;
##  
##end


for i = 2:length(accel_x_y_z)
    low = integrate_series(i-1,:);
    high = integrate_series(i,:);
    #dt = time(i) - time(i-1);
    dt = atime(i) - atime(i-1);
    running_sum += (low+high)/2 * dt;
    
    sum_series(i,:) = running_sum;
end

#only look at forward motion axis (y in inertial) for smooth peaks
#peak_finding_data = sum_series(:,2);
peak_finding_data = inertial_accel_minus_g_1(:,2);
#Peak finding
  ## Rough estimates of first and second derivative
  #df1 = diff (peak_finding_data, 1)([1; (1:end).']);
  #df2 = diff (peak_finding_data, 2)([1; 1; (1:end).']);
  df1 = peak_finding_data;
  df2 = diff (peak_finding_data, 1)([1; (1:end).']);

  ## check for changes of sign of 1st derivative and negativity of 2nd
  ## derivative.
  ## <= in 1st derivative includes the case of oversampled signals.
  idx = find (df1.*[df1(2:end); 0] <= 0 & [df2(2:end); 0] < 0);
  
  pks = peak_finding_data(idx);


