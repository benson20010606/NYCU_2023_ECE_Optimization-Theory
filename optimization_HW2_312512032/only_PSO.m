clc;
clear;

syms x1 x2 

rng('shuffle') 
f=100*(x2-x1^2)^2+(1-x1)^2;
F=matlabFunction(f, 'Vars', {sym('x', [2, 1])});
range=[-2 2];
iterate=500;
dimension=2;
pop_size=4;

w= [ 0.729844    0.729844     0.729844];
c1=[ 1.496180    0                  1.496180];
c2=[ 0                 1.496180     1.496180];
type=["cognition-only","social-only","best"];
PSO_fx=zeros(iterate,3);
PSO_x=zeros(2,iterate,3);


X=(rand(dimension,pop_size))*(range(1)-range(2))+range(2);
for i =1:3
    [PSO_fx(:,i),PSO_x(:,:,i)]= my_pso(F,pop_size,dimension,range,w(i),c1(i),c2(i),iterate,X);  %  my_pso(F,pop_size,dimension,range,w,c1,c2,iterate)
    plot(1:iterate,PSO_fx(:,i), 'Linewidth', 0.55);
    hold on
    grid on
    disp(type(i))
    disp(min(PSO_fx(:,i)))
end
legend('cognition-only','social-only','best')


function [fx, x]= my_pso(F,pop_size,dimension,~,w,c1,c2,iterate,X)
    x=zeros(dimension,iterate);
    
    V=zeros(dimension,pop_size);
    %V=(rand(dimension,pop_size))*(range(1)-range(2))+range(2);
    [~,X_index]=min(F(X));
    Xgbest=X(:,X_index);
    
    for i=1:iterate
        Xpbest=X(:,1);
        for j=1:pop_size   
                r1=rand(dimension,1);
                r2=rand(dimension,1);
                V(:,j)=w* V(:,j)+c1*r1.*(Xpbest-X(:,j))+c2*r2.*(Xgbest-X(:,j));
                X(:,j)=X(:,j)+V(:,j);
            if F(X(:,j))< F(Xpbest)
                Xpbest=X(:,j);
                if F(Xpbest)< F(Xgbest)
                    Xgbest=X(:,j);
                end
            end
        end
        x(:,i)=Xgbest;
    end
    fx=F(x);
end