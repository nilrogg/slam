clc;
clear all;
close all;
%%%%%%%%%%%%%%%%%%%

%Motion [V_lineal W_rotation] 
U=[2 0;  2 0 ; 2 0   ];

%Trayectory points
size_U=size(U);
M=size_U(1);


%Sampling interval
Delta_t=1;

%Noises powers
alfa=[0.01 0.01 0.01 0.01 0.01 0.01];



%Number of samples
N=500;

X_M=zeros(3,N,M+1);

%Make space for the result
X=zeros(3,N);

%Initial position
X0=[0 0 0];


for i=1:N
    X_M(:,i,1)=X0;
end


for j=1:M
    for i=1:N
    	X_M(:,i,j+1)=odometry_sampling(U(j,:),X_M(:,i,j),alfa,Delta_t)';            
    end
end


fig=figure;
for i=1:M+1
    plot(X_M(2,:,i),X_M(3,:,i),'r+');
    hold on;
end


L_MAX=max(max(max(X_M)));
L_MIN=min(min(min(X_M)));
axis([L_MIN,L_MAX,L_MIN,L_MAX]);
grid on;
title('Robot position');
xlabel('X position [m]');
ylabel('Y position [m]')


filename=strcat('grafico_trayectory',datestr(now,30));
print(fig, '-djpeg', filename);

