% FEM solver of trusses with material non linearity
% ----------------------------------------------------------------------


% Initial defs
% ------------------------------
generalDefs

% Solver
% ------------------------------

while (nTimes > time)
	
	Uk = matUk(:,time) ;
	
	% Assembly forces
	% ---------------------------------------

	% Update external force
	loadedNodes = nodalForceMatrix(:,1) ;
	lambdak = loadFactorsVec(time) ;

	for i = 1:length(loadedNodes)
		dofs = nodes2dofs(loadedNodes(i),ndofs) ;
		Fextk(dofs) = Fextk(dofs) + lambdak * nodalForceMatrix(i,2:3)'  ;
	end
	
	matFext = [ matFext Fextk ] ;
	
	% Finds Uk
	k = 0 ; % NR iter counter
	convIter = 0 ; % Convergence control parameter
	
	while convIter == 0
	
		% Asssembly of forces and system resolution
		% ------------------------------
		assembly

	end
	
	% Store variables
	% ------------------------------
	
	matUk 	= [ matUk Uk ] ;
	matFint = [ matFint Fintk ] ;
	matFintL = [ matFintL FintkL ] ;
	convParam = [ convParam ; cond ] ;
	KTstore{time+1} = KTkred ;
	
	% Updates time
	time = time+1 ;
	
end


