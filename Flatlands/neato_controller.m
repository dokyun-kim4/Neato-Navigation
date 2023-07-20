close all;
% RUN main.mlx before starting the controller!

%Connect to your Neato or the Simulator - choose one or the other
[sensors,vels]=neatoSim(-2,0,pi/2,1); %uncomment for simulator
%[sensors,vels]=neato('192.168.16.97'); %uncomment for physical neato
pause(2) %wait a bit for the robot to start up

theta_i = pi/2; %Starting angle
for i = 2:length(x_arr)

    x_i = x_arr(i-1);
    y_i = y_arr(i-1);
    x_next = x_arr(i);
    y_next = y_arr(i);
    
    % Turn to new angle
    theta_next = atan2(y_next - y_i, x_next - x_i);
    angle_to_turn = theta_next - theta_i;

    if angle_to_turn > 0
        % CCW
        vr = 0.1;
        vl = -0.1;
    else
        % CW
        vr = -0.1;
        vl = 0.1;
    end
    
    % Calculate angular velocity
    omega = (vr-vl)/0.245;
    % Find time needed to turn necessary amount
    turn_time = abs(angle_to_turn/omega);
    
    % Turn for that amount of time
    t0 = clock;
    while (etime(clock,t0)<turn_time)
        vels.lrWheelVelocitiesInMetersPerSecond=[vl,vr]; 
    end
    % Update theta value
    theta_i = theta_next;

    % Calculate linear travel
    dist_to_next = sqrt((y_next - y_i)^2 + (x_next - x_i)^2);
    vl = 0.1;
    vr = 0.1;
    linear_time = dist_to_next/0.1;
    % Move for that amount of time
    t1 = clock;
    while (etime(clock,t1)<linear_time)
        vels.lrWheelVelocitiesInMetersPerSecond=[vl,vr]; 
    end
    % Stop and ready to turn again
    vels.lrWheelVelocitiesInMetersPerSecond=[0,0];
end
vels.lrWheelVelocitiesInMetersPerSecond=[0,0];
pause(1);

clc