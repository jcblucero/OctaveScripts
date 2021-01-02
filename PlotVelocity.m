
#scatter
figure('Name', 'Sensor Data');
axis(1) = subplot(4,1,1);
hold on;
plot(x_axis_plot, sum_series(:,1), 'r');
plot(x_axis_plot, sum_series(:,2), 'g');
plot(x_axis_plot, sum_series(:,3), 'b');
### Plot Peaks ###
plot(x_axis_plot(idx),sum_series(:,2)(idx),'xm');
##################
#plot(time, gyro_delta_2(:), 'k');
legend('X', 'Y', 'Z');
xlabel('Time (s)');
ylabel('Magnitude');
title('Decision Parameters');
hold off;


axis(2) = subplot(4,1,2);
hold on;
plot(x_axis_plot, inertial_accel_minus_g_1(:,1), 'r');
plot(x_axis_plot, inertial_accel_minus_g_1(:,2), 'g');
plot(x_axis_plot, inertial_accel_minus_g_1(:,3), 'b');
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