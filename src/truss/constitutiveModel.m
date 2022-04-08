function [C, epsPlk, epsPlak, sigmak, phi] = constitutiveModel(modelVec, epsPlHist, epsPlaHist, eps, i)

	% Model variables
	E 			= modelVec(1) ; 
	sigmaY 	= modelVec(2) ;
	K 			= modelVec(3) ;

	
	if i == 1 
			C = E ;
			epsPlk = epsPlHist{i} ;
			epsPlak = epsPlaHist{i}	 ;
			sigmak = C * eps ;	
			phi = abs(sigmak) - (sigmaY + K*epsPlaHist{i}) ;
	else
		
		% Return method
		
		
		sigmaE = E * (eps - epsPlHist{i-1}) ;
		phi = abs(sigmaE) - ( sigmaY + K * epsPlaHist{i-1} ) ;
		
		if phi <= 0
			sigmak 	= sigmaE ;
			epsPlk 	= epsPlHist{i-1} ;
			epsPlak = epsPlaHist{i-1} ;
			C = E ;
		else
			deltaGamma = ( abs(sigmaE) - sigmaY - K * epsPlaHist{i-1} ) / (K + E) ;
			sigmak = sigmaE - E * deltaGamma * sign(sigmaE) ;
			epsPlk = epsPlHist{i-1} + deltaGamma * sign(sigmaE) ;
			epsPlak = epsPlaHist{i-1} + deltaGamma ;
			C = E*K / (E+K) ;
		end
				
	end % if time
end
