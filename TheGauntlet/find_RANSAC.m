function [v,endpoints,inliers,outliers,bestfit_pairs,polar] = find_RANSAC(scan,d,n)
    GAP_LIMIT = 0.25;
    nozero = scan(all(scan,2),:);
    r = nozero(:,1);
    theta = deg2rad(nozero(:,2));
    polar = [r rad2deg(theta)];
    
    x = r .* cos(theta);
    y = r .* sin(theta);
    
    cartesians = [x y];
    
    %RANSAC
   
    max_inlier_count = 0;
    final_inlier = [];
    final_outlier = [];

    a_final =0;
    b_final=0;
    c_final=0;
   
    
    bestfit_points = zeros(2,2);
    
    
    for i = 1:n
    
        inlier_count = 0;
        inlier_points = [];
        
        outliers_points = [];
        %get two random points
        point1 = cartesians(randi(length(x)),:);
        point2 = cartesians(randi(length(x)),:);
        while point2 == point1
            point2 = cartesians(randi(length(x)),:);
        end
        x1 = point1(1);
        y1 = point1(2);
        x2 = point2(1);
        y2 = point2(2);
        
        %find line going through 2 points in ax+by+c = 0 form
        a = y1-y2;
        b = -(x1-x2);
        c = x1*y2-x2*y1;
      
    
        
        for j = 1:length(x) %Find remaining points' distance from line
            rj=  cartesians(j,:);
            xj=rj(1);
            yj=rj(2);
            distance = abs(a*xj+b*yj+c)/sqrt(a^2+b^2);
            %Count inliers for this line
            if  distance < d 
                inlier_count = inlier_count+1;
                inlier_points(j,1) = xj;
                inlier_points(j,2) = yj;
                
            else
                outliers_points(j,1) = xj;
                outliers_points(j,2) = yj;
                
            end
        end
        sorted_inlier = remove_zero(sortrows(inlier_points));
        

        gaps = [];
        for k = 1:length(sorted_inlier)-1 %Gap check
            xi1 = sorted_inlier(k,1);
            yi1 = sorted_inlier(k,2);
            xi2 = sorted_inlier(k+1,1);
            yi2 = sorted_inlier(k+1,2);
            
            distance = sqrt((yi2-yi1)^2+(xi2-xi1)^2);

           
           gaps(k) = distance;
        end
            
        if max(gaps) >= GAP_LIMIT
            continue
        end
                
        if inlier_count > max_inlier_count %Inlier count check
            max_inlier_count = inlier_count;
            a_final = a;
            b_final = b;
            c_final = c;
            final_inlier=inlier_points;
            final_outlier = outliers_points;
            bestfit_points(1,1) = x1;
            bestfit_points(1,2) = y1;
            bestfit_points(2,1) = x2;
            bestfit_points(2,2) = y2;
        end
    end
    
    m = -a_final/b_final;
    b = -c_final/b_final;

    v = [m;b];
    inliers = remove_zero(final_inlier); %inliers
    outliers =remove_zero(final_outlier); %outliers
    endpoints = [min(inliers(:,1)) m*min(inliers(:,1))+b; max(inliers(:,1)) m*max(inliers(:,1))+b];
    bestfit_pairs = bestfit_points; %two points used for best fit line
end