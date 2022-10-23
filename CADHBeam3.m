function [] = CADHBeam3(a1,b1,c1,d1,a2,b2,c2,d2,k,nbeam,swept)
% root.      Height is b1+c1+b1
% a1=2;      Flange width  at root
% b1=1;      Flange thickness at root
% c1=2;      web height at root
% d1=0.2;   web thickness at root



% tip.          Height is b2+c2+b2
% a2=1;        Flange width   at tip
% b2=0.5;      Flange thickness   at tip
% c2=1;         web height  at tip
% d2=0.1;       web thickness at tip
% Define points/vertices

nodes = [...
 -a1/2 0 -b1-c1/2; ...
 -a1/2 0 -c1/2; ...
 -d1/2 0 -c1/2; ...
 -d1/2 0 c1/2; ...
 -a1/2 0 c1/2; ...
 -a1/2 0 b1+c1/2; ...
 a1/2 0 b1+c1/2; ...
 a1/2 0 c1/2; ...
 d1/2 0 c1/2; ...
 d1/2 0 -c1/2; ...
 a1/2 0 -c1/2; ...
 a1/2 0 -b1-c1/2; ...
 -a2/2 k/nbeam -b2-c2/2; ...
 -a2/2 k/nbeam -c2/2; ...
 -d2/2 k/nbeam -c2/2; ...
 -d2/2 k/nbeam c2/2; ...
 -a2/2 k/nbeam c2/2; ...
 -a2/2 k/nbeam b2+c2/2; ...
 a2/2 k/nbeam b2+c2/2; ...
 a2/2 k/nbeam c2/2; ...
 d2/2 k/nbeam c2/2; ...
 d2/2 k/nbeam -c2/2; ...
 a2/2 k/nbeam -c2/2; ...
 a2/2 k/nbeam -b2-c2/2
 ];

T = [1 2 3;
 1 3 12;
 3 10 12;
 10 11 12;
 3 4 10;
 4 9 10;
 4 5 6;
 4 6 7;
 4 7 9;
 7 8 9;
 13 14 15;
 13 15 24;
 15 22 24;
 22 23 24;
 15 22 16;
 16 21 22;
 16 17 18;
 16 18 19;
 16 19 21;
 19 20 21;
 1 13 12;
 12 13 24;
 1 13 2;
 2 13 14;
 2 14 3;
 3 14 15;
 3 4 15;
 4 15 16;
 4 5 16;
 5 16 17;
 5 6 17;
 6 17 18;
 6 7 18;
 7 18 19;
 7 19 8;
 8 19 20;
 8 9 20;
 9 20 21;
 9 10 21;
 10 21 22;
 10 11 22;
 11 22 23;
 11 12 23;
 12 23 24];


T2=[T(1:10,:)];
for i=1:nbeam-1
    nodes=[nodes;[nodes(end-11:end,1) nodes(end-11:end,2)+(k/nbeam) nodes(end-11:end,3)]];
    T2=[T2;(12*(i-1))+T(21:44,:)];
end
T2=[T2;T((11:end),:)+(12*(nbeam-1))];

scale=(b1+c1+b1)/((b2+c2+b2)*(nbeam));
zz=linspace(1,scale*(nbeam),nbeam+1);
xx=linspace(k*sin(deg2rad(swept)),0,nbeam+1);
l=1;
for i=length(nodes):-12:13
    nodes(i-11:i,:)=[nodes(i-11:i,1)*zz(l) nodes(i-11:i,2) nodes(i-11:i,3)*zz(l)];
    nodes(i-11:i,:)=[nodes(i-11:i,1)-xx(l) nodes(i-11:i,2) nodes(i-11:i,3)];
    l=l+1;
end



x=nodes(:,1);
y=nodes(:,2);
z=nodes(:,3);
% For reference only, nodel numbering
% plot3(x,y,z,'k')
% text(x,y,z, cellstr(num2str((1:length(nodes))')));
% axis equal

% Create triangulation
TR = triangulation(T2,x,y,z);
% figure
% trisurf(TR)
% axis equal

% Save triangulation to stl
stlwrite(TR,"Hbeam2.stl")



end