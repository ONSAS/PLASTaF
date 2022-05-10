function [C, alpha, kappaPlk, kappaPlak, Mk, phi] = constitutiveModel(modelVec, b, h, kappa, kappaPlHist, kappaPlaHist, i)

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
			phi = abs(Mk)-My ;
	else	
		
		Me = E*I*( kappa - kappaPlHist{i} ) ;
		phi = abs(Me)-My ;

		if phi <= 0
			Mk = Me ;
			C = E ;
			kappaPlk = kappaPlHist{i} ;
			kappaPlak = kappaPlaHist{i}	 ;
			alpha = 1 ;
		else
			deltaGamma = ( abs(Me) - My ) / (E*I) ;
			Mk = Me - E*I*deltaGamma * sign(Me) ;
			
			kappaPlk = -(kappaPlHist{i} + deltaGamma *sign(Me)) ;
			kappaPlak = kappaPlaHist{i} + deltaGamma ;
			C = abs( 3*sigmaY / (kappa*h) ) * ( 1 - kappa_e^2/(3*kappa^2) ) ;
			%~ C = abs( 1/kappa * ( 1-1/(kappa^2) ) ) ;
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
