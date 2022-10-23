clear all
close all
clc

E = 70E9;   %aluminum young modulus
nu = 0.32;  %aluminum poison ratio
swept=20;   %degrees
drag=ones(8,1)*1000;  %positive
lift=ones(8,1)*100000; 
h_root=2;   %height at root     
h_tip=1;    %height at tip
k=12;   %semispan of wing

sf=1.5;%safety factor for von mises         
rho=2700; %kg/m3  
stressmaterial=500e6;
plotFEA=1;
[stress,mass,Zdisplacement] = NonConstantHbeam(drag,lift,E,nu,swept,h_root,h_tip,k,stressmaterial,sf,rho,plotFEA)
