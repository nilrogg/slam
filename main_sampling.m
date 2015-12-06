clear all;
close all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Sampling interval
Delta_t= 1;

%Noises powers
alfa=[0.1 0.1 0.1 0.1 0.01 0.01];


%Number of samples
N=500;

%Make space for the result
X=zeros(3,N);

%Initial position
X0=[0 0 0];

%Motion [V_lineal W_rotation] 
U0=[5 0.00 ];

for i=1:N
	X(:,i)=odometry_sampling(U0,X0,alfa,Delta_t)';
end

fig=figure(1);
plot(X(2,:),X(3,:),'r+');
axis([-10,10,-20,20]);
grid on;
title('Robot position');
xlabel('X position [m]');
ylabel('Y position [m]')


filename=strcat('grafico_sampling',datestr(now,30));
print(fig, '-djpeg', filename);