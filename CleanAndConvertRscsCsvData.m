 #Read data collected from IMU in following header format
 #qx,qy,qz,qw,qtime,mx,my,mz,mtime,ax,ay,az,atime,gyrox,gyroy,gyroz,gyrotime,linax,linay,linaz
 #Convert time from counts to seconds
 #convert mag,accel, and gyro data to SI units from sensor counts
 #
 ## Output - CSV in same format with unit conversions
  #qx,qy,qz,qw,qtime,mx,my,mz,mtime,ax,ay,az,atime,gyrox,gyroy,gyroz,gyrotime,linax,linay,linaz

 csv_data = csvread('RTTLogger_Channel_Terminal_STRIPPED_VER2.csv');
 #csv_data = csvread('t1_on_desk_pitch.csv');
 #csv_data = csvread('t3_pitch_moving.csv');
 
 #First row is headers, which octave won't read
 #second row is bad data for whatever reason
 #ignore these 2 and start with 3rd row
 cleaned_data = csv_data(3:10922,1:20);
 
 #qx,qy,qz,qw,qtime,mx,my,mz,mtime,ax,ay,az,atime,gyrox,gyroy,gyroz,gyrotime,linax,linay,linaz
 #Timestamp cols
 qtime_col = 5;
 mtime_col = 9;
 atime_col = mtime_col+4;
 gyrotime_col = atime_col+4;

function converted_time = convert_mcu_timestamp_to_seconds(col, cleaned_data)
  rollover = cleaned_data(2:end,col) < cleaned_data(1:end-1,col);
  rollover = cumsum(rollover);
  rollover *= 65536; #2^16, timestamp is 16 bits
  total_counts = cleaned_data(:,col) + [0; rollover];
  converted_time = total_counts / 32768.0; #Timer resolution on EM7180 Sentral is 32khz
endfunction
  
qtime = convert_mcu_timestamp_to_seconds(qtime_col, cleaned_data);
mtime = convert_mcu_timestamp_to_seconds(mtime_col, cleaned_data);
atime = convert_mcu_timestamp_to_seconds(atime_col, cleaned_data);
gyrotime = convert_mcu_timestamp_to_seconds(gyrotime_col, cleaned_data);

acc_x_col = 10;
mag_x_col = 6;
gyro_x_col = 14;
linacc_x_col = 18;
acceleration_scale_factor = 0.00048828125;
gravity_to_meter_second_sq = 9.80665;
accel_meter_second_sq_factor = gravity_to_meter_second_sq  * acceleration_scale_factor;
magnetomoeter_scale_factor =	0.03051757813; 
gyro_scale_factor =	0.1525878906; 

#acc_x = cleaned_data(:,acc_x_col) * 0.00048828125;
#Convert 16 bit counts from sensors to units (
accel_x_y_z = cleaned_data(:,acc_x_col:acc_x_col+2) * accel_meter_second_sq_factor;
linaccel_x_y_z = cleaned_data(:,linacc_x_col:linacc_x_col+2) * accel_meter_second_sq_factor;
mag_x_y_z = cleaned_data(:,mag_x_col:mag_x_col+2) * magnetomoeter_scale_factor;
gyro_x_y_z = cleaned_data(:,gyro_x_col:gyro_x_col+2) * gyro_scale_factor;


#Format output and put to csv
output_file_name = "cleaned_formatted_data.csv"
output_data = cleaned_data;
output_data(:,qtime_col) = qtime;
output_data(:,mtime_col) = mtime;
output_data(:,atime_col) = atime;
output_data(:,gyrotime_col) = gyrotime;

output_data(:,acc_x_col:acc_x_col+2) = accel_x_y_z;
output_data(:,linacc_x_col:linacc_x_col+2) = linaccel_x_y_z;
output_data(:,mag_x_col:mag_x_col+2) = mag_x_y_z;
output_data(:,gyro_x_col:gyro_x_col+2) = gyro_x_y_z;

headers = {"qx","qy","qz","qw","qtime","mx","my","mz","mtime","ax","ay","az","atime","gyrox","gyroy","gyroz","gyrotime","linax","linay","linaz"}

fid = fopen(output_file_name,"w");
fprintf(fid,"%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", headers'{:});
fclose(fid);
#cell2csv(output_file_name,headers);
#csvwrite(output_file_name,headers,"append","on");
csvwrite(output_file_name,output_data,"append","on");

