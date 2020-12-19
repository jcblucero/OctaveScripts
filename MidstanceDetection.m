#Plotting for initial contact detection/midstance for zero velocity update

x_delta = sqrt([0;0;(gyro_x_y_z(3:end,1) - gyro_x_y_z(1:end-2,1)).^2]);
y_delta = sqrt([0;0;(gyro_x_y_z(3:end,2) - gyro_x_y_z(1:end-2,2)).^2]);
z_delta = sqrt([0;0;(gyro_x_y_z(3:end,3) - gyro_x_y_z(1:end-2,3)).^2]);

gyro_delta_2 = x_delta + y_delta + z_delta;

#scatter
figure('Name', 'Sensor Data');
axis(1) = subplot(3,1,1);
hold on;
plot(time, x_delta(:), '.r');
plot(time, y_delta(:), '.g');
plot(time, z_delta(:), '.b');
plot(time, gyro_delta_2(:), 'k');
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

axis(3) = subplot(3,1,3);

linkaxes(axis, 'x');