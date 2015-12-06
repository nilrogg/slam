function x_t=odometry_sampling(u_t,x_tm1,alfa,Delta_t)
%Define entry parameters
v=u_t(1);
w=u_t(2);

%Define state variables
theta=x_tm1(1);
x=x_tm1(2);
y=x_tm1(3);

%
v_hat=v+sample(alfa(1)*abs(v)+alfa(2)*abs(w));
w_hat=w+sample(alfa(3)*abs(v)+alfa(4)*abs(w));
gamma_hat=sample(alfa(5)*abs(v)+alfa(6)*abs(w));

%
x_prima=x-(v_hat/w_hat)*sin(theta)+(v_hat/w_hat)*sin(theta+w_hat*Delta_t);
y_prima=y+(v_hat/w_hat)*cos(theta)-(v_hat/w_hat)*cos(theta+w_hat*Delta_t);
theta_prima=theta+w_hat*Delta_t+gamma_hat*Delta_t;

%Construct the exit vector
x_t=[theta_prima x_prima y_prima];



