#Rotate accel data by q and plot data

q = [output_data(:,4),output_data(:,1),output_data(:,2),output_data(:,3)];

#Rotate body frame acceleration to inertial, then subtract gravity
inertial_accel_1 = RotateVecToInertialFrame(accel_x_y_z,q);
inertial_accel_2 = RotateVecToBodyFrame(accel_x_y_z,q);
inertial_accel_3 = RotateVecToInertialFrame_2(accel_x_y_z,q);

time = (1:length(q))';
time = time * 0.0015; #sampled every 1.5ms

#inertial_accel_minus_g = inertial_accel - [0,0,9.80665];

#Rotate gravity to body frame, then subtract from acceleration
#then rotate accel to inertial frame

#rotated_grav = RotateGravityToBodyFrame(q) * 9.80665;
#body_accel_minus_grav = accel_x_y_z - rotated_grav;
#inertial_accel_minus_g_2 = RotateVecToInertialFrame(body_accel_minus_grav,q);

rotated_grav = RotateGravityToBodyFrame(q) * 9.80665;
#rotated_grav = RotateVecToInertialFrame([0 0 1], q) * 9.80665;
body_accel_minus_grav = accel_x_y_z - rotated_grav;
inertial_accel_minus_g_1 = RotateVecToInertialFrame(body_accel_minus_grav,q);
inertial_accel_minus_g_2 = RotateVecToBodyFrame(body_accel_minus_grav,q);




#plot
figure('Name', 'Sensor Data');
axis(1) = subplot(4,1,1);
hold on;
plot(time, accel_x_y_z(:,1), 'r');
plot(time, accel_x_y_z(:,2), 'g');
plot(time, accel_x_y_z(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Body Accelerometer');
hold off;

#plot
axis(2) = subplot(4,1,2);
hold on;
plot(time, rotated_grav(:,1), 'r');
plot(time, rotated_grav(:,2), 'g');
plot(time, rotated_grav(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Acceleration (g)');
title('Gravity Rotated to Body');
hold off;

axis(3) = subplot(4,1,3);
hold on;
plot(time, gyro_x_y_z(:,1), 'r');
plot(time, gyro_x_y_z(:,2), 'g');
plot(time, gyro_x_y_z(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Accel (m/s^2)');
title('Gyro');
hold off;

axis(4) = subplot(4,1,4);
hold on;
plot(time, inertial_accel_minus_g_1(:,1), 'r');
plot(time, inertial_accel_minus_g_1(:,2), 'g');
plot(time, inertial_accel_minus_g_1(:,3), 'b');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Accel (m/s^2)');
title('Final Inertial Accel - G');
hold off;

linkaxes(axis, 'x');