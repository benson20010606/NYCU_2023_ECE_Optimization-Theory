clc;
clear;

AAA=(gamma(1+1.5)*sin(pi*1.5/2)/(gamma((1+1.5)/2)*1.5*2^((1.5-1)/2)))^(1/1.5)


syms x1 x2 

rng('shuffle') 

Sd=@(beta) (gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);

f=100*(x2-x1^2)^2+(1-x1)^2;
F=matlabFunction(f, 'Vars', {sym('x', [2, 1])});
range=[-2 2];
iterate=500;
local_search_rate=[0.25   0.5  0.75];
type=["more global","equilibrium","more local"];
CS_fx=zeros(iterate,5);
CS_x=zeros(2,iterate,5);
pop_size=8;
dimension=2;
X=(rand(dimension,pop_size))*(range(2)-range(1))+range(1);
for i =1:3
    [CS_fx(:,i),CS_x(:,:,i)]= my_cs(F,X,pop_size,dimension,range,Sd(1.5),1.5,local_search_rate(i),iterate);
    plot(1:iterate,CS_fx(:,i));
    hold on
    grid on
    disp(type(i))
    disp(min(CS_fx(:,i)))
end
legend("more global","equilibrium","more local"')






function [fx, x]= my_cs(F,X,pop_size,dimension,~,SD,beta,local_search_rate,iterate)


    x=zeros(dimension,iterate);
    

    for i=1:iterate
        u=randn(2,1)*SD;
        v=randn(2,1);
        s=u/norm(v)^(1/beta);
        [~,X_index]=min(F(X));
        Xgbest=X(:,X_index);
        
        for j=1:pop_size   
            X_new= X(:,j)+randn(2,1).*0.01.*s.*(X(:,j)-Xgbest);
            if F(X_new)<F( X(:,j))
                X(:,j)=X_new;
            end
        end
        for k=1:pop_size   
            r=rand(2,1);
            d=randi([1 pop_size],2,1);
            X_new= X(:,j)+randn(2,1).*(X(:,d(1))-X(:,d(2)));
            if r(1)<local_search_rate
                X_new(1,1)=X(1,j);
            end
            if r(2)<local_search_rate
                X_new(2,1)=X(2,j);
            end
            if F(X_new)<F( X(:,j))
                X(:,j)=X_new;
            end    
                
        end
        x(:,i)=Xgbest;
    end
    fx=F(x);
end