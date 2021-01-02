
t_1_step = 1:1:length(time);
#Variable to control what to plot on x axis
x_axis_plot = t_1_step;
#x_axis_plot = time;

###TODO: Find Initial Contact
#1) Peak in jerk
#2) high frequency signal (count number of peak/valleys in timer interval)
jerk = [0 0 0; accel_x_y_z(2:end,:) - accel_x_y_z(1:end-1,:)];
jerk_smoothed = movmean(jerk,10);

#jerk squared
jsm2 = jerk_smoothed.^2;
jerk_norm = sqrt( jsm2(:,1) + jsm2(:,2) + jsm2(:,3) );

jerk_threshold = 1.5;
initial_contact = jerk_norm > jerk_threshold;
#Plotting for initial contact detection/midstance for zero velocity update

x_delta = sqrt([0;0;(gyro_x_y_z(3:end,1) - gyro_x_y_z(1:end-2,1)).^2]);
y_delta = sqrt([0;0;(gyro_x_y_z(3:end,2) - gyro_x_y_z(1:end-2,2)).^2]);
z_delta = sqrt([0;0;(gyro_x_y_z(3:end,3) - gyro_x_y_z(1:end-2,3)).^2]);

gyro_delta_2 = x_delta + y_delta + z_delta;


#### Rest Detection Gyro ###

#magnitude of angular rate must be less than threshold for i samples in a row
gyro_rest_samples = 10; 

gyro_sq = gyro_x_y_z.^2;
gyro_norm = sqrt(gyro_sq(:,1) + gyro_sq(:,2) + gyro_sq(:,3) );

w_thresh = 75;

gyro_below_thresh = gyro_norm < w_thresh;
#gyro_at_rest(gyro_rest_samples:end) = sum(gyro_below_thresh
gyro_at_rest = zeros(length(gyro_norm));
rest_count = 0;
total_rest_count = zeros(length(gyro_norm));
for i = 1:length(gyro_below_thresh)
  if gyro_below_thresh(i)
    rest_count += 1;
    if rest_count >= gyro_rest_samples
      gyro_at_rest(i) = 1;
    endif
  else
    rest_count = 0;
  endif
  total_rest_count(i) = rest_count;
end

######################

### Accel Rest Detection ####

#this method is not robust to different angles
#subtracting constant g, but x/z are related to g through sin(g)+cos(g), whose max is 1.4142 (sqrt(2))
#If we subtract 1.4*g, then when < 45deg (say 30deg), we will not have max and be too lenient for transition
#if 45deg but don't account for max, we will not subtract enough and be too hard

accel_sq = accel_x_y_z.^2;
accel_norm = sqrt(accel_sq(:,1) + accel_sq(:,2) + accel_sq(:,3) );

a_thresh = 22;

accel_at_rest = accel_norm < a_thresh;

both_at_rest = gyro_at_rest & accel_at_rest;
#######################

## State Machine ##
gait_state = 0;
gait_state_series = zeros(length(gyro_at_rest));
for i = 1:length(gyro_at_rest)
  #if initial contact, state is 1
  if initial_contact(i)
    gait_state = 1;
  #if at rest and initial contact has happend, move to state 2
  elseif (gyro_at_rest(i) && (gait_state>=1))
    gait_state = 2;
  #stay in state 2 (rest) until threshold exceeded
  elseif  (gait_state==2) && not(gyro_at_rest(i))
    gait_state = 0;
  else
    gait_state = gait_state;
  endif
  
  gait_state_series(i) = gait_state;
end

###################

#scatter
figure('Name', 'Sensor Data');
axis(1) = subplot(4,1,1);
hold on;
plot(x_axis_plot, inertial_accel_minus_g_1(:,1), 'r');
plot(x_axis_plot, inertial_accel_minus_g_1(:,2), 'g');
plot(x_axis_plot, inertial_accel_minus_g_1(:,3), 'b');
#plot(time, gyro_delta_2(:), 'k');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Magnitude');
title('Decision Parameters');
hold off;


axis(2) = subplot(4,1,2);
hold on;
plot(x_axis_plot, jerk_smoothed(:,1), 'r');
plot(x_axis_plot, jerk_smoothed(:,2), 'g');
plot(x_axis_plot, jerk_smoothed(:,3), 'b');
#plot(time, gyro_delta_2(:), 'k');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Magnitude');
title('Body Acccel');
hold off;

axis(3) = subplot(4,1,3);
hold on;
plot(x_axis_plot, gyro_x_y_z(:,1), 'r');
plot(x_axis_plot, gyro_x_y_z(:,2), 'g');
plot(x_axis_plot, gyro_x_y_z(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Angular rate (deg/s)');
title('Gyroscope');
hold off

axis(4) = subplot(4,1,4);
hold on;
plot(x_axis_plot, gyro_at_rest(:,1), 'r');
plot(x_axis_plot, initial_contact(:,1), 'g');
plot(x_axis_plot, gait_state_series(:,1), 'b');
#legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('State');
title('State Machine');
hold off

linkaxes(axis, 'x');