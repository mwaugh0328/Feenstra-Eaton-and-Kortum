%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code (i) estimates the structural parameters for the EK(2002) model
% from a gravity regression (ii) simulates micro level prices and shares
% from the EK model and (iii) performs the Feenstra (1994) (I closely follow
% the presentation in his 2010 Prodcut Variety and Gains from Trade book). 
% The results from this code were presented in the appendix of working paper versions of SW(2014).
%
% Key finding: Feenstra's method estimates the elasticity
% of substitution across goods. NOT THE ELASTICITY OF TRADE. This has the
% implication that IF the data generating process is of the EK model, then
% Feenstra's method is not estimating a welfare relevant parameter.
%
%
% Michael Waugh 1/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear

n_sims = 100; % Number of simmulations...
theta = 4; % The Frechet parameter 
rho = 2.5; % The elasticity of substitution across varieties. 

elasticity = zeros(n_sims,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First run the code to generate Ts and taus from gravity regression as in
% EK(2002) or Waugh (2010). Note I'm useing code that will call a stata
% file which executes this in a more transparent way...

stata_to_tau_to_trade

% The key aspects of the code are in ``gravity_run.do'' and you must have
% the gravity_data.csv and trade_grav_est_30.mat in the working directory. 
% It will gennerate the ``S'' parameters from EK(2002) and the trade costs
% or taus..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now the next routine generates micro level data from the EK(2002) model
% and then performs the estimation. 


parfor runs = 1:n_sims
    
    [elasticity(runs)] = gen_feenstra_data_estimate(theta,rho,ssd_stata,tau_stata,09112001+runs);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now what did we get...
clc
disp('EK(2002) Shape Parameter')
disp(theta)
disp('Elasticity of Substiution Across Varieties')
disp(rho)
disp('')
disp('')
disp('')
disp('Mean of Feenstra Estimate Across Simmulations')
disp(mean(elasticity))
disp('Median of Feenstra Estimate Across Simmulations')
disp(median(elasticity))

