clc;
clear;

syms x1 x2 

rng('shuffle') 
f=100*(x2-x1^2)^2+(1-x1)^2;
F=matlabFunction(f, 'Vars', {sym('x', [2, 1])});
range=[-2 2];
iterate=500;
pop_size=10;
dimension=2;
bit_size=32;
Mutation_rate=[ 0.01    0.01      0.03  ];
Crossover_rate=[ 0.8      0.2      0.8   ];
type=["A","B","C"];
GA_fx=zeros(iterate,3);
GA_x=zeros(2,iterate,3);
X=randi([0 1],pop_size,dimension*bit_size);
for i =1:3
   [GA_fx(:,i), GA_x(:,:,i)]=   my_ga(F,8,2,32,range,Crossover_rate(i),Mutation_rate(i),iterate,X);
    plot(1:iterate,GA_fx(:,i));
    hold on
    grid on
    disp(type(i))
    disp(min(GA_fx(:,i)))
end
legend("A","B","C")













%GA
function [fx, x]=my_ga(F,pop_size,dimension,bit_size,range,Crossover_rate,Mutation_rate,iterate,X)
    
    fx=zeros(1,iterate);
    x=zeros(2,iterate);

    for i=1:iterate
        fitness=Fitness(F,B2D(X,bit_size,dimension,range));
        [fx(i),I]=min(F(B2D(X,bit_size,dimension,range)));
        x(:,i)=B2D(X(I,:),bit_size,dimension,range);
        X=do_GA(X,dimension,bit_size,Crossover_rate,Mutation_rate,fitness);
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
        b2d(1,i)=polyval(binary(i,1:bit_size),2);
        b2d(2,i)=polyval(binary(i,bit_size+1:end),2); 
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

