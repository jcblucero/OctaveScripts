#Rotate accel data by q and plot data

q = [output_data(:,4),output_data(:,1),output_data(:,2),output_data(:,3)];

#Rotate body frame acceleration to inertial, then subtract gravity
inertial_accel = RotateVecToInertialFrame(accel_x_y_z,q);

time = (1:length(q))';
time = time * 0.0015; #sampled every 1.5ms

inertial_accel_minus_g = inertial_accel - [0,0,9.80665];

#Rotate gravity to body frame, then subtract from acceleration
#then rotate accel to inertial frame
rotated_grav = RotateGravityToBodyFrame(q) * 9.80665;
body_accel_minus_grav = accel_x_y_z - rotated_grav;
inertial_accel_minus_g_2 = RotateVecToInertialFrame(body_accel_minus_grav,q);




#scatter
figure('Name', 'Sensor Data');
axis(1) = subplot(3,1,1);
hold on;
scatter(time, inertial_accel(:,1), 'r');
scatter(time, inertial_accel(:,2), 'g');
scatter(time, inertial_accel(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Accelerometer Rotated');
hold off;

#scatter
axis(2) = subplot(3,1,2);
hold on;
scatter(time, inertial_accel_minus_g(:,1), 'r');
scatter(time, inertial_accel_minus_g(:,2), 'g');
scatter(time, inertial_accel_minus_g(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Accelerometer Minus Gravity');
hold off;

#scatter
##axis(1) = subplot(3,1,3);
##hold on;
##scatter(time, inertial_accel_minus_g_2(:,1), 'r');
##scatter(time, inertial_accel_minus_g_2(:,2), 'g');
##scatter(time, inertial_accel_minus_g_2(:,3), 'b');
##legend('X', 'Y', 'Z');
##xlabel('Time (s)');
##ylabel('Acceleration (g)');
##title('Accelerometer Minus Gravity V2');
##hold off;

axis(3) = subplot(3,1,3);
hold on;
scatter(time, gyro_x_y_z(:,1), 'r');
scatter(time, gyro_x_y_z(:,2), 'g');
scatter(time, gyro_x_y_z(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Angular rate (deg/s)');
title('Gyroscope');

linkaxes(axis, 'x');