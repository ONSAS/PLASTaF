function [R,length] = elemGeom(cord1, cord2, ndofs)

length = sqrt(sum(( cord2 - cord1 ).^2 )) ;

Deltax = cord2(1)-cord1(1) ;
Deltay = cord2(2)-cord1(2) ;

ex = [ Deltax Deltay ] / length ;
ey = [ -Deltay Deltax ] / length ;


R = zeros(2*ndofs, 2*ndofs) ;

aux = [ ex' ey' ] ;

R(1:2,1:2) = aux ;
R(3:4,3:4) = aux ;

end
