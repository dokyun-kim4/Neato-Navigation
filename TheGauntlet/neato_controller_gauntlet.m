load("path.mat");
max_count = 15;
distances = zeros(max_count, 1);
change_angles = zeros(max_count, 1);


max_points=3000;
encoder_data=zeros(max_points,3);
iter=0;

close all;

%Connect to your Neato or the Simulator - choose one or the other
% [sensors,vels]=neatoSim(.933,.838,pi,1); %uncomment for simulator
[sensors,vels]=neato('192.168.16.87'); %uncomment for physical neato
pause(5) %wait a bit for the robot to start up


current_angle = pi + 30 * (pi/180); %Starting angle
tic;
sec = toc;
for i = 2:length(r_xes)
    sec = toc;
    iter=iter+1;
    %Calculate where the NEATO is headed
    if iter<=max_points
        encoder_data(iter,:)=[sec,sensors.encoders(1),sensors.encoders(2)];
    end 
    current_x = r_xes(i-1);
    current_y = r_yes(i-1);
    next_x = r_xes(i);
    next_y = r_yes(i);

    current_mag = sqrt(current_x^2+current_y^2);
    next_mag = sqrt(next_x^2+next_y^2);

    distance_to_next_point = sqrt((next_y - current_y)^2 + (next_x - current_x)^2);
    
    
    next_angle = atan2(next_y - current_y, next_x - current_x);
    change_angle = next_angle - current_angle;

    distances(i-1) = distance_to_next_point;
    change_angles(i-1) = change_angle;
    
    % turn to new angle
    vl = 0.1;
    vr = 0.1;

    if change_angle > 0
        vl = -0.1;
    else
        vr = -0.1;
    end
    
    omega = (vr-vl)/0.245;

    time_spent_angular = abs(change_angle/omega);
    
    t0 = clock;
    while (etime(clock,t0)<time_spent_angular)
        vels.lrWheelVelocitiesInMetersPerSecond=[vl,vr]; 
    end
    current_angle = next_angle;
    sec = toc;
    if iter<=max_points
        encoder_data(iter,:)=[sec,sensors.encoders(1),sensors.encoders(2)];
    end 
    iter=iter+1;

    %Set linear velocity
    vl = 0.1;
    vr = 0.1;

    %Go to new location
    time_spent_linear = distance_to_next_point/0.1;
    t1 = clock;
    while (etime(clock,t1)<time_spent_linear)
        vels.lrWheelVelocitiesInMetersPerSecond=[vl,vr]; 
    end
    sec = toc;
    if iter<=max_points
        encoder_data(iter,:)=[sec,sensors.encoders(1),sensors.encoders(2)];
    end 
    iter=iter+1;
    vels.lrWheelVelocitiesInMetersPerSecond=[0,0];   
end

encoder_data=encoder_data(1:iter,:);
vels.lrWheelVelocitiesInMetersPerSecond=[0,0];
pause(1);
save("encoder_data_2.mat", "encoder_data")

clc