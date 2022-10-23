function [stress,mass,Zdisplacement] = NonConstantHbeam(drag,lift,E,nu,swept,h_root,h_tip,k,stressmaterial,sf,rho,plotFEA)

stress=1;

k=k/cos(deg2rad(swept));    %here beam length turns from semispan to diagonal value


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


        c1=0.9012*h_root;
        d1=0.0494*h_root;
        a1=0.5*h_root;        
        b1=(h_root-c1)/2;

        c2=0.9012*h_tip;
        d2=0.0494*h_tip;
        a2=0.5*h_tip;
        b2=(h_tip-c2)/2;

      

nbeam=length(lift);

CADHBeam3(a1,b1,c1,d1,a2,b2,c2,d2,k,nbeam,swept);   %k is the semi span b/2

model = createpde("structural","static-solid");
gm = importGeometry(model,"Hbeam2.stl");
if plotFEA==1
    figure(1)
    pdegplot(model,'FaceLabels','on')
    figure(2)
    pdegplot(model,'VertexLabels','on','EdgeLabels','on','CellLabels','on','FaceLabels','on','FaceAlpha',0.5);
end
msh = generateMesh(model,'Hmax',d1,'Hgrad',1.1,'Hmin',d1/2,'Hface',{[5,6,16,17],d1/1.5,[1],d1/5});
V = volume(msh);
if plotFEA==1
    figure(3)
    pdeplot3D(model,'ElementLabels','on','NodeLabels','on');
    pdeplot3D(model);
end

InitFaces=[5,6,16,17];
structuralBoundaryLoad(model,'Face',InitFaces,'SurfaceTraction',[-drag(1),0,lift(1)]);      %first 4 faces
InitFaces=[5+17,6+17,16+16,17+16];
structuralBoundaryLoad(model,'Face',InitFaces,'SurfaceTraction',[-drag(2),0,lift(2)]);   %second 4 faces
for i=1:nbeam-3
    InitFaces=InitFaces+16;
    structuralBoundaryLoad(model,'Face',InitFaces,'SurfaceTraction',[-drag(i+2),0,lift(i+2)]);
end
structuralBoundaryLoad(model,'Face',InitFaces+19,'SurfaceTraction',[-drag(end),0,lift(end)]);  %last 4 faces

structuralProperties(model,'YoungsModulus',E,'PoissonsRatio',nu);  %Pa units
structuralBC(model,'Face',1,'Constraint','fixed');       %cantilever attached at face 1
% 
%structuralBoundaryLoad(model,'Face',150,'SurfaceTraction',[0,0,100]);  %Vertex, Edge, Face
%structuralBoundaryLoad(model,'Face',2,'Pressure',p2);

Rs = solve(model);
if plotFEA==1
    figure(4)
    pdeplot3D(model,'ColorMapData',Rs.VonMisesStress,'Deformation',Rs.Displacement,'DeformationScaleFactor',1);
end
[valor ~]=max(Rs.VonMisesStress);
closestIndex=[];
Zdisplacement=[];
for i=1:nbeam
    [~,closestIndex(i)] = min(abs((k/nbeam)*i-Rs.Mesh.Nodes(2,:)));
    Zdisplacement(i) = Rs.Displacement.z(closestIndex(i));
end


if valor*sf>stressmaterial
        stress=0;
end
mass=V*rho;
end


