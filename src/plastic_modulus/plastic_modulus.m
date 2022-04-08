% ----------------------------------------------------------------------
% Computation of Plastic Moduluz for open sections
% ----------------------------------------------------------------------


nelems = size(sec_rec,1) ;
ygVec = [] ;

% Computes area
Aelem 	= sec_rec(:,1).*sec_rec(:,2) ;
Atotal 	= sum(Aelem) ;


% Computes centroid of elements
for j = 1:nelems

	b = sec_rec(j,1) ;
	h = sec_rec(j,2) ;
	
	% Element centroids
	if j == 1
		yg = h/2 ;
	else
		yg = ygVec(j-1) + h/2 + sec_rec(j-1,2)/2 ;
	end
	
	ygVec = [ ygVec yg ] ;

end

Aacum = 0 ;
hacum = 0 ;
hTrialVec = [] ;
dVec = [] ;
Zvec = zeros(1, nelems) ;
m = 0 ;

for j =1:nelems
	b = sec_rec(j,1) ;
	h = sec_rec(j,2) ;
	
	if j ~= 1 
		Aacum = Aacum + Aelem(j-1) ;
		hacum = hacum + sec_rec(j-1,2) ;	
	end
	
	htrial = ( Atotal/2 - Aacum ) / b ;
	hTrialVec = [hTrialVec htrial] ; 
	
	if (htrial < h) && (htrial > 0)
		hbar = htrial ;
		ybar = hacum + hbar ;
		Zm = b*hbar^2/2 ;
		m = find(hbar == hTrialVec) ;
	end
		
end	

for j = 1:nelems
	
	if j ~= m
		dbar = ybar - ygVec(j) ;
		dVec = [dVec dbar] ;
		Zvec(j) = Aelem(j) * abs(dbar) ;
	else
		b = sec_rec(j,1) ;
		h = sec_rec(j,2) ;
		Zvec(m) = b*hbar^2/2 + b*(h-hbar)^2/2 ;
	end
end

Z = sum(Zvec) ;

disp('Plastic Modulus')
disp('----------------------------------- ')
Z



