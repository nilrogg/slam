function prob_x_t=odometry_closed(u_t,x_tm1,alfa,Delta_t,x_t)

%Define entry parameters
v=u_t(1);
w=u_t(2);

%Define state variables
theta_inicial=x_tm1(1);
x_inicial=x_tm1(2);
y_inicial=x_tm1(3);

%
theta_final=x_t(1);
x_final=x_t(2);
y_final=x_t(3);


mu=0.5*((x_inicial-x_final)*cos(theta_inicial)+(y_inicial-y_final)*sin(theta_inicial))/((y_inicial-y_final)*cos(theta_inicial)-(x_inicial-x_final)*sin(theta_inicial));

%

x_rot=0.5*(x_inicial+x_final)+mu*(y_inicial-y_final);
y_rot=0.5*(y_inicial+y_final)+mu*(x_final-x_inicial);
Radio_rot=sqrt((x_inicial-x_rot)^2+(y_inicial-y_rot)^2);

%
Delta_theta=(atan2(y_final-y_rot,x_final-x_rot)-atan2(y_inicial-y_rot,x_inicial-x_rot));

v_hat=((Delta_theta)/Delta_t)*Radio_rot;

if sign(v_hat)~=sign(v)
        v_hat=v_hat*-1;
end 
w_hat=(Delta_theta/Delta_t);
gamma_hat=(theta_final-theta_inicial)/Delta_t - w_hat;

%

prob_x_t=prob(v-v_hat,alfa(1)*abs(v)+alfa(2)*abs(w))*prob(w-w_hat,alfa(3)*abs(v)+alfa(4)*abs(w))*prob(gamma_hat,alfa(5)*abs(v)+alfa(6)*abs(w));


