clc ;
clear;

syms x1 x2 

f=100*(x2-x1^2)^2+(1-x1)^2;
F=matlabFunction(f, 'Vars', {sym('x', [2, 1])});

disp("gradient")
disp(gradient(f,[x1,x2]));
G=gradient(f,[x1 x2]);
G=matlabFunction(G, 'Vars', {sym('x', [2, 1])});

disp("hessian")
disp(hessian(f,[x1,x2]));
H=hessian(f,[x1 x2]);
H=matlabFunction(H, 'Vars', {sym('x', [2, 1])});


x(:,1)=[-1.2;1.0];
%steep_desent_start=tic;

[x_steep_desent ,value_steep_desent,ALPHA ]= Steep_Desent(F,G,x,0.00001,'fx');

%toc(steep_desent_start);

%newton_start=tic;
[x_newton ,value_newton ]=Newton(F,G,H,x,0.00001);
%toc(newton_start);


%%%%%
fc=fcontour(  @(xx1,xx2) 100*(xx2-xx1^2)^2+(1-xx1)^2,[-1.5 1.5 -3.2 2.2],'Fill','on');
fc.LineWidth = 1;

colorbar
hold on
grid on 
plot(x_newton(1,:),x_newton(2,:),'r-*', 'Linewidth', 2, 'MarkerSize', 4);
plot(x_steep_desent(1,:),x_steep_desent(2,:),'M-*', 'Linewidth', 1, 'MarkerSize', 4);
plot(1,1,"pentagram", 'Linewidth', 2, 'MarkerSize', 4)
plot(-1.2,1,"k pentagram", 'Linewidth', 2, 'MarkerSize', 4)

xlabel('x1'); 
ylabel('x2') ;
legend('level set','Newton','Steep Desent','goal','intital','location', 'southwestoutside')
set(gcf,'position',[0,50,1440,720]);
%legend('level set','Newton','goal','intital')
%legend('level set','Steep Desent','goal','intital')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x ,value,alpha_i]= Steep_Desent(Function,Gradient,Intital,Tolerance,stop)

    F=Function;
    g=Gradient;
    x=Intital;
    value=zeros(1,4000);
    value(1)=F(x(:,1));
    alpha_i=zeros(1,4000);
    i=2;
    while true
        g_i=g(x(:,i-1));
        x_i=x(:,i-1);
        %value(i-1)=F(x(:,i-1));
        alpha_i(i-1)=find_alpha(x_i,g_i);
        x(:,i)=x_i-alpha_i(i-1)*g_i;
        value(i)=F(x(:,i));
        if stop == 'fx'
            if(abs(value(i)-value(i-1))/value(i-1)<Tolerance)
                break;
            end
        elseif stop =='x'
            if( norm(x(:,i)-x(:,i-1))/norm(x(:,i-1)) < Tolerance)
                break;
            end
        end
        i=i+1; 
    
    end

end

function [x ,value]= Newton(Function,Gradient,Hessian,Intital,Tolerance)
    F=Function;
    g=Gradient;
    H=Hessian;
    x=Intital;
    i=2;
    value=zeros(1,4000);
    value(1)=F(x(:,1));
    while true
        g_now=g(x(:,i-1));
        H_inv=inv(H(x(:,i-1)));
        x(:,i)=x(:,i-1)-H_inv*g_now;
        if (norm(x(:,i)-x(:,i-1))/norm(x(:,i-1)) < Tolerance)
            break;
        end     
        value(i)=F(x(:,i));
        i=i+1;
        abs(g_now);

    end
end

function best_alpha=find_alpha(x,g)
    f_alpha=@(alpha) 100*((x(2)-alpha*g(2))-(x(1)-alpha*g(1))^2)^2+(1-(x(1)-alpha*g(1)))^2;
    
    best_alpha=fminsearch(f_alpha,2); % 堪用
    
    %best_alpha=fmincon(f_alpha,0,[],[],[],[],0,1); %time consume too big
end