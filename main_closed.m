clear all;
close all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
t=cputime;

%Sampling interval
Delta_t= 1;

%Noises powers
alfa=[0.1 0.1 0.1 0.1 0.01 0.01];

%Number of samples
N=50;

%Make space for the result
X=zeros(3,N);

%Initial position
X0=[0 0 0];

%Motion [V_lineal W_rotation] 
U0=[5 0.1 ];

%Make the cells
grid=zeros(N,N,N);

x_final_ideal = odometry_sampling(U0, X0, [0 0 0 0 0 0 ], Delta_t);

int_plano = 1 / N  ;
int_angulo = pi / N;

for i=1:N
	for j=1:N
		for k=1:N
			x_final = x_final_ideal - [N/2*int_angulo, N/2 * int_plano , N/2 * int_plano] + [ i * int_angulo , j * int_plano ,  k * int_plano];
            grid(i,j,k)=odometry_closed(U0,X0,alfa,Delta_t,x_final);

        end
    end
end



%%
imagen = zeros(N,N);
for j=1:N
	for k=1:N
		sumando = 0.0;
		for i=1:N
			sumando = sumando + grid(i,j,k);
        end
        if sumando>0
            imagen(N+1-k,j) = (sumando);
        else
            imagen(N+1-k,j) = 0;
        
        end     
      %  disp(imagen(j,k));
    end
end

%Normalize image values

beta= sum(sum(imagen));
imagen=imagen/beta;

%Scale image
fig=figure;
imagen=255-(imagen*255/max(max(imagen)));
image(imagen);
colormap('gray');
title('Probabilities of the robot position');
xlabel('X pixels');
ylabel('Y pixels');

%Calculate time
tiempo=cputime-t;
tiempo_string=sprintf('Total time elapsed: %f seconds \n',tiempo);
disp(tiempo_string);

%Save image

filename=strcat('grafico_closed',datestr(now,30));
print(fig, '-djpeg', filename);