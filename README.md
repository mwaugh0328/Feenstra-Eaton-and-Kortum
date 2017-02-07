# Feenstra-Eaton-and-Kortum
Applies Feenstra's (1994) estimation method to simulated data from Eaton and Kortum (2002) model.

This code (i) estimates the structural parameters for the EK(2002) modelfrom a gravity regression (ii) simulates micro level prices and shares from the EK (2002) model and (iii) performs the Feenstra (1994) (I closely follow the presentation in his 2010 Prodcut Variety and Gains from Trade book). The results from this code were presented in the appendix of working paper versions of SW(2014).

Key finding: Feenstra's method estimates the elasticity of substitution across goods. NOT THE ELASTICITY OF TRADE. This has the implication that IF the data generating process is of the EK model, then Feenstra's method is not estimating a welfare relevant parameter.

Stucture of code: "run_feenstra.m" is the driver file. It first calls "stata_to_tau_to_trade.m" and "gravity_run.do" to estimate the structural paramters from bilateral trade flows. The file "gen_feenstra_data_estimate.m" then simmulates micro level data from the EK(2002) model and then applies Feenstra's method to the data.  
