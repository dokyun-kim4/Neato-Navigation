function [fltrdTimeAndSpeed] = filterSpeed(speeds,time,threshold)
%filterSpeed Remove rows that exceed a specified speed threshold
% Both speeds and time are n by 1 column vectors
    fltrdSpeed = [];
    fltrdTime = [];
    count = 1;
    for i=1:length(speeds)
        curSpeed = speeds(i,1);
        curTime = time(i,1);
        % Neato's max speed is 0.3 m/s, remove noise that is greater.
        if curSpeed ~= 0 && curSpeed <= threshold
            fltrdSpeed(count,1) = curSpeed;
            fltrdTime(count,1) = curTime;
            count = count + 1;
        end
    end
    fltrdTimeAndSpeed = [fltrdTime(:),fltrdSpeed(:)];
end