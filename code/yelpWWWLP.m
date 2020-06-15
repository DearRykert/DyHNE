clc;clear;
addpath(genpath(pwd))

load ./data/yelpWWW_lp/bsb_csr.mat;
load ./data/yelpWWW_lp/brurb_csr.mat;

W_bsb = bsb_csr;
W_brurb = brurb_csr;

k = 100;
gamma = 1;

t1=clock;
W_unify = W_bsb+W_brurb;
dunify = sum(W_unify,2);
D_unify = diag(dunify);
L_unify = D_unify- W_unify;  
W_unify = NormalizeAdj(W_unify,0,2);
M_unify = (speye(size(W_unify,1)) - W_unify)' * (speye(size(W_unify,1)) - W_unify);
[unify_embedding, U_unify, Lambda_unify] = DHINOffline(L_unify, D_unify, k);
save  ./data/yelpWWW_lp/result/unify_bsb+brurb_embedding_1st.mat unify_embedding;
t2=clock;
fprintf('Time for static model: %f s  \n', etime(t2,t1)) 

% for i = 1:10
%     t1=clock;
%     W_unify = (i/10)*W_bsb+(1-i/10)*W_brurb;
%     dunify = sum(W_unify,2);
%     D_unify = diag(dunify);
%     L_unify = D_unify- W_unify;  
%     W_unify = NormalizeAdj(W_unify,0,2);
%     M_unify = (speye(size(W_unify,1)) - W_unify)' * (speye(size(W_unify,1)) - W_unify);
%     [unify_embedding, U_unify, Lambda_unify] = DHINOffline(L_unify + M_unify, D_unify,k);
%     data_name = ['./data/yelpWWW_lp/result/unify_',num2str(i/10),'bsb+',num2str(1-i/10),'brurb_embedding.mat'];
%     save  (data_name,'unify_embedding');
% 
%     t2=clock;
%     fprintf('Time for static model: %f s  \n', etime(t2,t1)) 
% end