clc;
clear;

syms x1 x2  x3 x4 x5 

rng('shuffle') 

range=[-2 2];
iterate=500;
pop_size=8;
dimension=2;


f=100*(x2-x1^2)^2+(1-x1)^2;
FF=matlabFunction(f, 'Vars', {sym('x', [2, 1])});

%DROP-WAVE FUNCTION
%ff=-(1 + cos(12*sqrt(x1^2+x2^2)))/(0.5*(x1^2+x2^2) + 2);
%FF=matlabFunction(ff, 'Vars', {sym('x', [2, 1])});

%SCHAFFER FUNCTION N. 2
%ff=0.5+(((sin(x1^2-x2^2))^2 - 0.5)/( (1 + 0.001*(x1^2+x2^2))^2))
%FF=matlabFunction(ff, 'Vars', {sym('x', [2, 1])});

%ACKLEY FUNCTION
%sum1 = x1^2+x2^2+x3^2+x4^2+x5^2;
%sum2 = cos(2*pi*x1)+cos(2*pi*x2)+cos(2*pi*x3)+cos(2*pi*x4)+cos(2*pi*x5);
%ff=  -20 * exp(-0.2*sqrt(sum1/5))  -exp(sum2/5) +20 + exp(1);
%FF=matlabFunction(ff, 'Vars', {sym('x', [5, 1])});

%RASTRIGIN FUNCTION
%ff=10*dimension+(x1^2 - 10*cos(2*pi*x1))+(x2^2 - 10*cos(2*pi*x2))+(x3^2 - 10*cos(2*pi*x3))+(x4^2 - 10*cos(2*pi*x4))+(x5^2 - 10*cos(2*pi*x5))
%FF=matlabFunction(ff, 'Vars', {sym('x', [5, 1])});




intital_X=randi([0 1],pop_size,dimension*32);
intital_XX=B2D(intital_X,32,dimension,range);

[PSO_fx,PSO_x]= my_pso(FF,pop_size,dimension,range,0.729844,1.496180,1.496180,iterate,intital_XX);  %  my_pso(F,pop_size,dimension,range,w,c1,c2,iterate)
[CS_fx, CS_x]=   my_cs(FF,pop_size,dimension,range,0.69660,1.50,0.25,iterate,intital_XX);                                %  my_cs  (F,pop_size,dimension,range,SD,beta,iterate)
[GA_fx, GA_x,GA_fxgbest]=   my_ga(FF,pop_size,dimension,32,range,0.8,0.01,iterate,intital_X);                                   %  my_ga(F,pop_size,dimension,bit_size,range,Crossover_rate,Mutation_rate,iterate)
hold on
grid on
plot(1:iterate,PSO_fx,'r', 'Linewidth', 0.55);
plot(1:iterate,CS_fx,'g', 'Linewidth', 0.55);
plot(1:iterate,GA_fx,'b', 'Linewidth', 0.55);
plot(1:iterate,GA_fxgbest,"k",'Linewidth', 0.55);
legend('PSO','CS','GA(iteration best)','GA(Global best)');
xlabel('iterate');
ylabel('best');
set(gcf,'position',[0,50,1440,720]);
hold off
disp('best PSO:')
disp(min(PSO_fx))
disp('best CS')
disp(min(CS_fx))
disp('best GA:')
disp(min(GA_fxgbest))
%================================================================================================================================================================

%PSO
function [fx, x]= my_pso(F,pop_size,dimension,range,w,c1,c2,iterate,X)
    x=zeros(dimension,iterate);
    %X=(rand(dimension,pop_size))*(range(1)-range(2))+range(2);
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


%CS
function [fx, x]= my_cs(F,pop_size,dimension,range,SD,beta,local_search_rate,iterate,X)


    x=zeros(dimension,iterate);
    %X=(rand(dimension,pop_size))*(range(2)-range(1))+range(1);

    for i=1:iterate
        u=randn(dimension,1)*SD;
        v=randn(dimension,1);
        s=u/norm(v)^(1/beta);
        [~,X_index]=min(F(X));
        Xgbest=X(:,X_index);
        
        for j=1:pop_size   
          X_new= X(:,j)+randn(dimension,1).*0.01.*s.*(X(:,j)-Xgbest);
          if F(X_new)<F( X(:,j))
              X(:,j)=X_new;
          end
        end
        for k=1:pop_size   
            r=rand(dimension,1);
            d=randi([1 pop_size],2,1);
            X_new= X(:,j)+randn(dimension,1).*(X(:,d(1))-X(:,d(2)));
            for l=1:dimension
                if r(l)<local_search_rate
                    X_new(l,1)=X(l,j);
                end
            end
            if F(X_new)<F( X(:,j))
                X(:,j)=X_new;
            end    
                
        end
        x(:,i)=Xgbest;
    end
    fx=F(x);
end


%GA
function [fx, x,fx_best]=my_ga(F,pop_size,dimension,bit_size,range,Crossover_rate,Mutation_rate,iterate,X)
    %X=randi([0 1],pop_size,dimension*bit_size);
    fx=zeros(1,iterate);
    fx_best=zeros(1,iterate);
    x=zeros(dimension,iterate);
    fxgbest=min(F(B2D(X,bit_size,dimension,range)));
    for i=1:iterate
        fitness=Fitness(F,B2D(X,bit_size,dimension,range));

        X=do_GA(X,dimension,bit_size,Crossover_rate,Mutation_rate,fitness);
        [fx(i),I]=min(F(B2D(X,bit_size,dimension,range)));
        x(:,i)=B2D(X(I,:),bit_size,dimension,range);
        if fx(i)<fxgbest
            fxgbest=fx(i);
        end
        fx_best(i)=fxgbest;
    end
end

function x_new=do_GA(X,dimension,bit_size,Crossover_rate,Mutation_rate,fitness)
    n=size(X,1);
    x_new=zeros(size(X));
  
    temps=cumsum(fitness)/sum(fitness);
    %temp=(1-fitness./sum(fitness))/(ss-1)
    %temps=cumsum(temp);
    
    for ii =1:n/2
        parent=zeros(2,bit_size*dimension);
        for jj=1:2            
            choose=rand();
            for k=n:-1:1
                if k==1
                    parent(jj,:)=X(k,:);
                    break
                end
                if choose<temps(k) && choose>temps(k-1)
                    parent(jj,:)=X(k,:);
                    break
                end
                
            end   


        end
        parent=Crossover(parent,Crossover_rate,bit_size,dimension);
        parent=Mutation(parent,Mutation_rate,bit_size,dimension);
        x_new(2*ii,:)=parent(2,:);
        x_new(2*ii-1,:)=parent(1,:);
    end
end

function dec=B2D(binary,bit_size,dimension,range)
    T=size(binary);
    b2d=zeros(dimension,T(1));
    for i =1:T(1)
        for j=1:dimension
            b2d(j,i)=polyval(binary(i,(j-1)*bit_size+1:bit_size*j),2);
        end
        %b2d(1,i)=polyval(binary(i,1:bit_size),2);
        %b2d(2,i)=polyval(binary(i,bit_size+1:end),2); 
    end
    dec= b2d./(2^bit_size-1).*(range(2)-range(1))+range(1);
end

function fitness=Fitness(F,XX)
    counter=size(XX);
    fitness=zeros(1,counter(2));
    temp=zeros(1,counter(2));
    for i=1:counter(2)
        temp(i)=F(XX(:,i));
        fitness(i)=exp(-temp(i));
    end
end

function X_new=Crossover(X,Crossover_rate,bit_size,dimension)
    X_new=X;
    r=rand();
    point=randi([2 bit_size],2,1);
    if r<Crossover_rate
        for i=1:dimension
            temp=X(1,:);
            X_new(1,point(1)+(i-1)*bit_size:i*bit_size)=X_new(2,point(1)+(i-1)*bit_size:i*bit_size);
            X_new(2,point(2)+(i-1)*bit_size:i*bit_size)=temp(1,point(2)+(i-1)*bit_size:i*bit_size); 
        end
    end

end

function X_new=Mutation(X,Mutation_rate,bit_size,dimension)
    X_new=X;
    for i=1:2
        for j=1:dimension*bit_size
            choose=rand();
            if choose<Mutation_rate
                X_new(i,j)=~X(i,j);
            end
        end
    end
end

