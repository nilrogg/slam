clc;
clear all;
close all;
%%%%%%%%%%%% Exercise 1 %%%%%%%%%%%%%%%%%%%%%%%

%Transition matrix
T=[0.8 0.2 0
   0.4 0.4 0.2
   0.2 0.6 0.2];

%Number of states 
N=3;

%compute the eigenvalues and eigenvector of T transpose
[V,D]=eigs(T');

%Extract the probability vector
p=V(:,1)/sum(V(:,1));


Tinv=zeros(N,N);

for j=1:N
    for i=1:N
            Tinv(j,i)=T(i,j)*p(i);
    end
    Tinv(j,:)=Tinv(j,:)/sum(Tinv(j,:));
end

disp('The inverse probabilites matrix is: ');
disp(round(Tinv*100)/100)


%%%%%%%%%%%% Exercise 2 %%%%%%%%%%%%%%%%%%%%%%%

%Emision matrix
S=[0.6 0.4 0
   0.3 0.7 0
     0   0 1];

%Observations 
obs=[1,2,2,3,1];
M=length(obs);

%Initial probabilities
probs=zeros(M,N);
probs(1,1)=1;

for i=2:M
    for j=1:N
        for k=1:N
                probs(i,j)=probs(i,j)+probs(i-1,k)*T(k,j);           
        end
        probs(i,j)=probs(i,j)*S(j,obs(i));            
    end
    probs(i,:)=probs(i,:)/sum(probs(i,:));
end

disp('The probability that Day 5 is sunny is: ')
disp(probs(5,1))