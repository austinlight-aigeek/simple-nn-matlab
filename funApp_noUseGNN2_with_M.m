clc
clear all

fun1 = @(x)2./(1+exp(-2*x))-1;
fun2 = @(x)2./(1+exp(-2*x))-1;
Dfun1 = @(x)4*exp(-2*x)./(1+exp(-2*x)).^2;
Dfun2 = @(x)4*exp(-2*x)./(1+exp(-2*x)).^2;

x = (-10:0.1:10)';
yd = sinc(2*x)-0.4*cos(3*x)+0.2*sin(2*x-50)-0.3*sin(0.5*x-5);

n = size(x,1);
m = size(yd,1);
L = 10;

w1 = zeros(L, n+1);
w2 = zeros(m, L+1);

y1 = fun1(w1*[1; x]);
y = fun2(w2*[1; y1]);

g = figure(1);
g.Position = [70 50 1250 600];
h = plot(x, yd, 'o', x, y, '--');
axis([min(x) max(x) min(yd)-0.5 max(yd)+0.5]);

eTol = 1e-2;
eta = 0.01;
mmt1 = 0;
mmt2 = 0;
beta = 0.9;

xBar = [1; x];
epoch = 0;
while(1)
    u1 = w1*xBar;
    y1 = fun1(u1);
    y1Bar = [1; y1];
    u2 = w2*y1Bar;
    y = fun2(u2);
    e = yd - y;
    
    delta2 = e.*Dfun2(u2);
    delta1 = (w2(:,2:end)'*delta2).*Dfun1(u1);
    
    deltaW2 = eta*delta2*y1Bar';
    deltaW1 = eta*delta1*xBar';
    
    mmt2 = deltaW2 + beta*mmt2;
    mmt1 = deltaW1 + beta*mmt1;
    
    w2 = w2 + mmt2;
    w1 = w1 + mmt1;
    E = 0.5*e'*e;
    
    if E< eTol
        break;
    end
    
    if mod(epoch,2)==0
        h(2).YData = y;
        drawnow;
    end
    epoch = epoch + 1;
end
g.Position = [550 220 730 380];
epoch
E