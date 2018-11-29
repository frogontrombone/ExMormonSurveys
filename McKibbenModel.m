D01 = 3; %cm
p = 100; %1:1:500;
l = 7:.1:10;
l0 = 10;
epsilon = 1-(l/l0);%cm
theta0 = (54.7:.1:89.1);

[xx,yy] = meshgrid(epsilon,theta0);
F = zeros(size(xx));
for i=1:size(xx,1)
    for j=1:size(xx,2)
        F(i,j) = pi * D01^2 * p *(3 *(1-xx(i,j))^2/(tan(yy(i,j)*pi/180))^2 - 1/(sin(yy(i,j)*pi/180))^2) / 4;
    end
end

figure
mesh(xx,yy,F)