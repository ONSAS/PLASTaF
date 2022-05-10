function [Finte, epsk, Ck, kappa, kappaPlk, kappaPlak, phik] = beamInternLoad(Uke, Xe, R, l, b, h, modelParams, kappaPlHist, kappaPlaHist, time)
				
	% Elem displacements
	UkeL = R' * Uke ;
	r_1 = UkeL(2) ;
	r_2 = UkeL(4) ;
		
	%~ kappa = (abs( r_2-r_1) / l) ;
	kappa =  (r_2-r_1) / l ;
	
	% Elem strain
	epsk = kappa * h/2 ;
	
	% Constitutive model
	[Ck, alpha, kappaPlk, kappaPlak, ~, phik] = constitutiveModel(modelParams, b, h, kappa, kappaPlHist, kappaPlaHist, time) ;
												
	% Stiffnes matrix
	I = b*h^3/12 ;
	[Kloc] = stiffnessMatrix(Ck, I, l) ;
	
	Finte = Kloc * UkeL ;
		
end
