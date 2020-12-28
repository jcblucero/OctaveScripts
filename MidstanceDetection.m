#Plotting for initial contact detection/midstance for zero velocity update

x_delta = sqrt([0;0;(gyro_x_y_z(3:end,1) - gyro_x_y_z(1:end-2,1)).^2]);
y_delta = sqrt([0;0;(gyro_x_y_z(3:end,2) - gyro_x_y_z(1:end-2,2)).^2]);
z_delta = sqrt([0;0;(gyro_x_y_z(3:end,3) - gyro_x_y_z(1:end-2,3)).^2]);

gyro_delta_2 = x_delta + y_delta + z_delta;


#### Rest Detection ###

gyro_sq = gyro_x_y_z.^2;
gyro_norm = sqrt(gyro_sq(:,1) + gyro_sq(:,2) + gyro_sq(:,3) );

w_thresh = 100;

gyro_at_rest = gyro_norm < w_thresh;

######################

### Accel Rest Detection

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

#scatter
figure('Name', 'Sensor Data');
axis(1) = subplot(3,1,1);
hold on;
plot(time, gyro_norm(:), '.r');
plot(time, accel_norm(:), '.g');
plot(time, z_delta(:), '.b');
#plot(time, gyro_delta_2(:), 'k');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Magnitude');
title('Gyro Angular Accel Delta^2');
hold off;

axis(2) = subplot(3,1,2);
hold on;
plot(time, gyro_x_y_z(:,1), 'r');
plot(time, gyro_x_y_z(:,2), 'g');
plot(time, gyro_x_y_z(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Angular rate (deg/s)');
title('Gyroscope');
hold off

axis(3) = subplot(3,1,3);
hold on;
plot(time, gyro_at_rest(:,1), 'r');
plot(time, accel_at_rest(:,1), 'g');
plot(time, both_at_rest(:,1), 'b');
#legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Angular rate (deg/s)');
title('Gyroscope');
hold off

linkaxes(axis, 'x');