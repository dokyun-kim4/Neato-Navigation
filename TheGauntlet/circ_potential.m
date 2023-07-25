function [pot,X,Y] = circ_potential(xc,yc,r)
fun = @(t,x,y,k) -k.*log(sqrt((x-(xc+r.*sin(t))).^2+(y-(yc+r.*cos(t))).^2))*r;
k = 12000;
j = 1;
    for x = -2:1/80:2
        i = 1;
        for y = -2:1/80:2
            pot(i,j) = integral(@(t) fun(t,x,y,k),0,2*pi);
            X(i,j) = x;
            Y(i,j) = y;
            i = i + 1;
        end
        j = j + 1;
    end
end