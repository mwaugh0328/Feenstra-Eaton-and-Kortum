
function [elasticity] = gen_feenstra_data_estimate(theta,rho,ssd,tau,code_fake)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This generates code from the Eaton and Kortum (2002) model using the
% the techniques in SW(2014) and then applies Feenstra's (1994) method
% to data from our model. Generating variation across time periods are shocks
% to the ''S'' parameters and the trade frictions.
%
% Key finding: Feenstra's method estimates the elasticity
% of substitution across goods. NOT THE ELASTICITY OF TRADE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Some house keeping here. Not important.
theta = 1./theta;
n_country = length(ssd);
% Run the regression to paramerters

good = 15; % This will be the particular good for which will will apply feenstra's method.

% Run this for t time periods to construct the panel. I think Broda
% Weinstein had about 30 years????
for t = 1:29
    
    % Set the seed to last periods seed, again to compute the panel natrue
    % of the code. Note, I am going to shock the ``S's'' and tau's to get variation
    % across the time periods. I will keep the seed that draws the
    % individual frechet goods completely fixed.

    rng(03281978 + (t-1))
    
    tau_hat = tau.*lognrnd(0,.05,length(tau),length(tau));
    tau_hat(eye(length(tau))==1) = 1;
        
    [mhat, fpt, good_sharest] = sim_trade_pattern_ek(exp(ssd).*lognrnd(0,.10,n_country,1),tau_hat,1./theta,rho,code_fake);


    % Set the seed to this period. Shock the ``S's'' again    
    rng(03281978 + (t))
    
    tau_hat = tau.*lognrnd(0,.05,length(tau),length(tau));
    tau_hat(eye(length(tau))==1) = 1;

    [mhat1, fpt1, good_sharest1] = sim_trade_pattern_ek(exp(ssd).*lognrnd(0,.10,n_country,1),tau_hat,1./theta,rho,code_fake);

    % Add some error to the prices. This seems like the generates some
    % kindo fo errors in variables bias.
    
    
    
    final_pricet = lognrnd(0,.01,size(fpt)).*fpt;
    final_pricet1 = lognrnd(0,.01,size(fpt1)).*fpt1;

    
    ref_cntry = length(ssd); % This will be the reference country in the whole simmulation

    for cnt = 1:ref_cntry-1
    % Now we want to compute the price and share changes in log terms for
    % each country and the reference country
        
        % These go into computing equations 2.15-2.19 in Feenstra (2010). 
        delta_pi = log(final_pricet(cnt,good))-log(final_pricet1(cnt,good));
        delta_pk = log(final_pricet(ref_cntry,good))-log(final_pricet1(ref_cntry,good));

        delta_si = log(good_sharest(cnt,good))-log(good_sharest1(cnt,good));
        delta_sk = log(good_sharest(ref_cntry,good))-log(good_sharest1(ref_cntry,good));

        Y(t,cnt) = (delta_pi - delta_pk).^2;
        X1(t,cnt) = (delta_si - delta_sk).^2;
        X2(t,cnt) = (delta_pi - delta_pk)*(delta_si - delta_sk);
    
    % Then compute the Y variabels and the X variables

    end

end

% Now we average across time, as in equation 2.21 in Feenstra (2010)
feenstra_var = [mean(Y)', mean(X1)', mean(X2)'];

% Then run the regression across countries. Note that this will provied a
% consistent estimate, not necessarily effecient though. Also note, there
% is an issue in that sometimes it gives an imaginary number for the
% elasticity. One way to deal with this is to constrain the value of
% theta_1 to be positive, per Feenstra (2010) Page 19's theorem. The function
% below does this.

b = lsqlin([ones(length(feenstra_var),1), feenstra_var(:,2:3)],feenstra_var(:,1),[],[],[],[],[-1000;0;-1000],[]);

% b =lsqnonneg([ones(length(feenstra_var),1), feenstra_var(:,2:3)],feenstra_var(:,1));

disp('Theta_1 and Theta_2 in Feenstra Language')
disp(b)

% % Now use Theorem 2.3 of Feenstra to compute the implied elasticity 
if b(3) < 0
    rho = (1/2) - abs(( (1/4) - 1./(4 + (b(3).^2./b(2))))).^.5;
else
    rho = (1/2) + ( (1/4) - 1./(4 + (b(3).^2./b(2)))).^.5;
end

elasticity = 1 + ((2.*rho - 1)./(1-rho)).*(1./b(3));

% if b(3) == 0
%     elasticity = 1 + (b(2))^-.5;
% end

disp('Feenstra Elasticity')
disp(elasticity)





