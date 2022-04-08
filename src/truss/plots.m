% Plots
% ----------------------------------------------------------------------

% View vector
xAxis = 0 ;
yAxis = 0 ;
zAxis = 0 ;

% Plot settings
% ------------------------------------

% Undeformed structure
ms = 5 ;
lw = 1.2 ;
plotFontSize = 22 ;

% Sigma - Epsilon
lw1 = 2.0 ; ms1 = 11 ; plotFontSize = 22 ;

% Scale factor for axis
fac = 0.5 ;




% Undeformed structure
% ------------------------------------

dof = 2 ;

% Elem coords mat
elemCoordsMat = zeros(nelems,dof*2) ;
for i=1:nelems
	nodesElem = Conec(i,1:2)  ;
	elemCoordsMat(i, 1:1:4) = [ Nodes(nodesElem(1),:) Nodes(nodesElem(2),:) ] ;
end


unDef = figure ;
hold on, grid on, axis equal

% Axis
quiver3( xAxis, yAxis, zAxis, fac, 	 0, 	0, 0, 'm',"filled", 'linewidth', 2) ;
quiver3( xAxis, yAxis, zAxis, 0	 , fac, 	0, 0, 'm',"filled", 'linewidth', 2) ;
quiver3( xAxis, yAxis, zAxis, 0	 , 	 0, 	0, 0, 'm',"filled", 'linewidth', 2) ;

% Plot undeformed structure
for j=1:nelems
	%~ plot( elemCoordsMat(j,[1 6+1]), elemCoordsMat(j,[3 3+6]), elemCoordsMat(j,[5 5+6]), 'b--o', 'linewidth', lw, 'markersize',5*ms) ;
	plot( elemCoordsMat(j,[1 2+1]), elemCoordsMat(j,[2 2+2]), 'b--o', 'linewidth', lw, 'markersize',ms) ; 
end

% Labels
tit = title(['Undeformed Structure']) ;
labx = xlabel('X'); laby = ylabel('Y') ;
set(labx, 'fontsize', plotFontSize*.8);
set(laby, 'fontsize', plotFontSize*.8);
set(tit, 'fontsize', plotFontSize);


% Deformed structure
% ----------------------------------------------------------------------
elemDispsMat = zeros(nelems, dof*2) ;

for i = 1:length(plotsVec)
	
	def = figure ;
	
	hold on, grid on, axis equal
	
	% Axis
	quiver3( xAxis, yAxis, zAxis, fac, 	 0, 	0, 0, 'm',"filled", 'linewidth', 2) ;
	quiver3( xAxis, yAxis, zAxis, 0	 , fac, 	0, 0, 'm',"filled", 'linewidth', 2) ;
	quiver3( xAxis, yAxis, zAxis, 0	 , 	 0, 	0, 0, 'm',"filled", 'linewidth', 2) ;
	
	for j=1:nelems
		%~ plot( elemCoordsMat(j,[1 6+1]), elemCoordsMat(j,[3 3+6]), elemCoordsMat(j,[5 5+6]), 'b--o', 'linewidth', lw, 'markersize',5*ms) ;
		plot( elemCoordsMat(j,[1 2+1]), elemCoordsMat(j,[2 2+2]), 'b--o', 'linewidth', lw, 'markersize',ms) ; 
	end

	Ut = matUk(:, plotsVec(i) ) ;
	for j=1:nelems
		nodesElem = Conec(j,1:2) ;
		nod1Dofs = dof*(nodesElem(1)-1)+(1:dof) ;
		nod2Dofs = dof*(nodesElem(2)-1)+(1:dof) ;
		dofs = [nod1Dofs, nod2Dofs ] ;
		elemDispsMat(j,:) = Ut(dofs)' ;
	end

	elemCoordsMatDef = elemCoordsMat + elemDispsMat*scaleFactor ;
	
	for j=1:nelems
		plot( elemCoordsMatDef(j,[1 2+1]), elemCoordsMatDef(j,[2 2+2]), 'g-', 'linewidth', lw, 'markersize',1.2*ms) ;
		tit = title(['Deformed Structure t=' sprintf('%02i', plotsVec(i)) ]) ; 
		labx = xlabel('X'); laby = ylabel('Y') ;
		set(labx, 'fontsize', plotFontSize*.8);
		set(laby, 'fontsize', plotFontSize*.8);
		set(tit, 'fontsize', plotFontSize);
		cd(curr_path)
		print( def	, [ nameDeformed sprintf('%02i', plotsVec(i)) ] ,'-dpng') ;
		cd(solver_path)
	end
end



% Sigma - Epsilon
% ------------------------------------

sig_eps = figure ;
hold on, grid on
 
plot(cell2mat(epsHistElem(elem,plotLoadVec)), cell2mat(sigmaHistElem(elem,plotLoadVec)), 'b-o', 'linewidth', lw1, 'markersize', ms1)

labx = xlabel('Strain'); laby = ylabel('Stress') ;
tit = title('\sigma-\epsilon');
set(labx, 'fontsize', plotFontSize*.5);
set(laby, 'fontsize', plotFontSize*.5);
set(tit, 'fontsize', plotFontSize);

 


