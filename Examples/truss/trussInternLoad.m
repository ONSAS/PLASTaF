function [Finte, epsk, Ck, epsPlk, epsPlak, sigmak, phik] = trussInternLoad(Uke, Xe, R, l, A, modelParams, epsPlHist, epsPlaHist, time)

	Xdef = Xe + reshape(Uke,2,2)' ;	
	ldef = sqrt( sum(( Xdef(2,:) - Xdef(1,:) ).^2) ) ;
	
	UkeL = R' * Uke ;
	
	deltaL = ldef-l ; % Idem dif de desps por analisis lineal
	
	% Elem strain
	epsk = (UkeL(3)-UkeL(1)) / l ;
	
	% Constitutive model
	[Ck, epsPlk, epsPlak, sigmak, phik] = constitutiveModel(modelParams, epsPlHist, epsPlaHist, epsk, time) ;
	
	
	Finte = sigmak * A ;
	
	
end
