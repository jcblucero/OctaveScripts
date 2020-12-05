 csv_data = csvread('RTTLogger_Channel_Terminal_STRIPPED_VER2.csv');
 
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
acc_scale_factor = 0.00048828125;
acc_x = cleaned_data(:,acc_x_col) * 0.00048828125;
