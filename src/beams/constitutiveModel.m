function [C, alpha] = constitutiveModel(modelVec, b, h, kappa)

	% Model variables
	E 			= modelVec(1) ; 
	sigmaY 	= modelVec(2) ;
	K 			= modelVec(3) ;

	kappa_e = 2*sigmaY / (E*h) ;
	
		if kappa <= kappa_e
			C = E ;
			alpha = 1 ;
		else
			C = 3*sigmaY / (kappa*h) * ( 1 - kappa_e^2/(3*kappa^2) ) ;
			alpha = kappa_e / kappa ;
		end

end
