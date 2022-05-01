function [C, alpha, kappaPlk, kappaPlak, Mk] = constitutiveModel(modelVec, b, h, kappa, kappaPlHist, kappaPlaHist, i)

	% Model variables
	E 			= modelVec(1) ; 
	sigmaY 	= modelVec(2) ;
	K 			= modelVec(3) ;

	kappa_e = 2*sigmaY / (E*h) ;
	
	W = b*h^2/6 ;
	I = b*h^3/12 ;
	My = sigmaY * W ;	
	
	if i == 1 
			C = E ;
			kappaPlk = kappaPlHist{i} ;
			kappaPlak = kappaPlaHist{i}	 ;
			alpha = 1 ;
			Mk = E*I*kappa ;
	else	
		
		Me = -E*I*( kappa - kappaPlHist{i-1} ) ;
		phi = abs(Me)-My ;

		if phi <= 0
			Mk = Me ;
			C = E ;
			kappaPlk = kappaPlHist{i-1} ;
			kappaPlak = kappaPlaHist{i-1}	 ;
			alpha = 1 ;
		else
			deltaGamma = ( abs(Me) - My ) / (E*I) ;
			Mk = Me - E * I * deltaGamma * sign(Me) ;
			kappaPlk = kappaPlHist{i-1} + deltaGamma * sign(Me) ;
			kappaPlak = kappaPlaHist{i-1} + deltaGamma ;
			C = abs( 3*sigmaY / (kappa*h) * ( 1 - kappa_e^2/(3*kappa^2) ) ) ;
			alpha = kappa_e / kappa ;
		end

	end
		%~ if kappa <= kappa_e
			%~ C = E ;
			%~ alpha = 1 ;
		%~ else
			%~ C = 3*sigmaY / (kappa*h) * ( 1 - kappa_e^2/(3*kappa^2) ) ;
			%~ alpha = kappa_e / kappa ;
		%~ end


end
