% single dimension plot
x = linspace(0,2*pi);% x axis range
y = sin(x);


plot(x,y,"g:*" )
xlabel("x")
ylabel("sin(x)")
title("Plot of the Sine Function")

hold on

y2 = cos(x);
plot(x,y2,":")
legend("sin","cos")

hold off

% two dimension plot
x = linspace(-2,2,20);
y = x';
z = x .* exp(-x.^2 - y.^2);
mesh(x,y,z)% surf() 

xlabel("x")
ylabel("sin(x)")
zlabel("yahu")
title("Plot of the Sine Function")

% four plots in one picture
t = tiledlayout(2,2);
title(t,"Trigonometric Functions")
x = linspace(0,30);

nexttile
% Create and plot a sphere with radius r.
[x,y,z] = sphere;       % Create a unit sphere.
r = 2;
surf(x,y,z)       % Adjust each dimension and plot.
axis equal              % Use the same scale for each axis. 

nexttile
% two dimension plot
x = linspace(-2,2,20);
y = x';
z = x .* exp(-x.^2 - y.^2);
mesh(x,y,z)% surf() 
xlabel("x");
ylabel("sin(x)");
zlabel("yahu");

nexttile
plot(x,tan(x))
title("Tangent")

nexttile
plot(x,sec(x))
title("Secant")


