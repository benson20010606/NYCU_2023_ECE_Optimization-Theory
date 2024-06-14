clc ;
clear;

syms x1 x2 

f=100*(x2-x1^2)^2+(1-x1)^2;
F=matlabFunction(f, 'Vars', {sym('x', [2, 1])});

pop_size=100;
dimension=2
range=[3 3;3 3]
w=0.729844
c1=1.496180
c2=1.496180
iterate=100

X=rand(pop_size)