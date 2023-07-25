function [pot,X,Y] = line_potential(m,b,ep1,ep2)
    fun = @(t,x,y,k) k.*log(sqrt((x-t).^2+(y-(b+m.*t)).^2))*sqrt(1+m^2);
    k = 1000;
    j = 1;
    for x = -2:1/80:2
        i = 1;
        for y = -2:1/80:2
            pot(i,j) = integral(@(t) fun(t,x,y,k),ep1,ep2);
            X(i,j) = x;
            Y(i,j) = y;
            i = i + 1;
        end
        j = j + 1;
    end
end