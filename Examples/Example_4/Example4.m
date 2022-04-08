% ----------------------------------------------------------------------
% Plastic modulus of I section
% ----------------------------------------------------------------------

clear all, close all, clc

b1 = 125 ;
h1 = 8 ;

b2 = 6 ;
h2 = 100 ;

b3 = 75 ;
h3 = 8 ;


sec_rec = [ b1 h1 ; ...
						b2 h2 ; ...
						b3 h3 ] ;



% Solver path
% ------------------------------

curr_path = pwd ;
solver_path = '../../src/plastic_modulus/' ;

cd(solver_path)

plastic_modulus

cd(curr_path)

% Analytical check
% ------------------------------


Zana = 94733.3 ;

err = (Z-Zana) / Zana *100 
