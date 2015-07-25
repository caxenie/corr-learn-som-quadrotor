% conectivity learning mechanism using mutual information
function net_inf_engine(datafile)
close all; clc;
fprintf(1,'Running the network inference engine ...\n');

% open input data file
load(datafile);

% data props
npoints = size(x, 1); % number of points
ntotal  = size(x, 2); % number of variables

% outlier detection threshold 
threshold = 0.1;

% depending on the number of points we adaptively partition the joint space
% of variables so that the fraction of occupied bins with >=5 is at least a
% fraction given by:
fraction = 0.1*(log10(npoints)-1);
if fraction < 0.01
    fraction = 0.01;
end

% initialization
MI  = zeros(ntotal,ntotal,1);      % mutual information
H2  = zeros(ntotal,ntotal,1);      % joint entropy, 2 variables
fprintf(1,'\t Initialization ... OK \n');

% compute joint entropy between pairs of variables
for i=1:ntotal
    for j=1:ntotal
        pb = 10;
        [MI(i,j,1),fracn,H2(i,j,1)] = ...
            estimate_joint_statistics(x(1:end,i),x(1:end,j),pb);
        while fracn < fraction;
            pb = pb+1;
            [MI(i,j,1),fracn,H2(i,j,1)] = ...
                estimate_joint_statistics(x(1:end,i),x(1:end,j),pb);
        end
    end
end
fprintf(1,'\t Compute joint entropy between pairs of variables ... OK \n');

% compute mutual information between pairs of variables
for i=1:ntotal
    for j=1:ntotal
        pb = 5;
        [MI(i,j,1),fracn,H2(i,j,1)] = ...
            estimate_joint_statistics(x(1:end,i),x(1:end,j),pb);
        while fracn < fraction;
            pb = pb+1;
            [MI(i,j,1),fracn,H2(i,j,1)] = ...
                estimate_joint_statistics(x(1:end,i),x(1:end,j),pb);
        end
    end
end
fprintf(1,'\t Compute mutual information between pairs of variables ... OK \n');

% compute individual variable entropy
H1 = diag(H2(:,:,1));
fprintf(1,'\t Compute individual entropy of variables... OK \n');

% compute the entropy metric construction distance and find minimum
EMC_dist = exp(-MI);
[dist,~] = min(EMC_dist,[],3);
fprintf(1,'\t Compute entropy metric distance among variables ... OK \n');

% compute conditional entropies, , H(Xm|Xn)
cond_entr2     = zeros(ntotal,ntotal);
cond_entr2_A   = zeros(ntotal,ntotal);
cond_entr2_B   = zeros(ntotal,ntotal);
entropy_error    = zeros(ntotal,ntotal);
rel_entr_reduc_2 = zeros(ntotal,ntotal);
for m=1:ntotal
    for n=1:ntotal
        cond_entr2_A(m,n) = H1(m) - MI(m,n,1); % 1st way of calculating H(X|Y)
        cond_entr2_B(m,n) = H2(n,m,1) - H1(n); % 2nd way of calculating H(X|Y)
        cond_entr2(m,n)   = cond_entr2_A(m,n); % choice of H(X|Y)
        entropy_error(m,n)= abs(cond_entr2_A(m,n) - cond_entr2_B(m,n));
        rel_entr_reduc_2(m,n) = MI(m,n,1)/H1(m);
    end
end
fprintf(1,'\t Compute conditional entropies between pairs of variables ... OK \n');

% perform entropy reduction
% for each variable, determine which of the remaining variables yields the
% smallest conditional entropy (that is the most likely connection):
[~, spec_ind_2] = min(cond_entr2 + 1e3*eye(ntotal),[],2); % (add 1e3 to avoid minima)
ERT_array_2              = [(1:ntotal)', spec_ind_2];
% create 'con_array', the array of connections among entities:
con_array = zeros(ntotal,ntotal);
if exist('ERT_array_2','var') == 1
    for i=1:ntotal
        con_array(i,ERT_array_2(i,2)) = ...
            rel_entr_reduc_2(i,ERT_array_2(i,2));
    end
end
% discard false positives in the connection array
for i=1:ntotal
    for j=1:ntotal
        if abs(con_array(i,j)) < threshold
            con_array(i,j) = 0;
        end
    end
end
fprintf(1,'\t Run entropy reduction procedure ... OK \n');

% prepare to plot results
scaled_centered_dist = zscore(dist);
dissimilarities      = pdist(scaled_centered_dist,'euclidean');

% project distances to lower-dimensional space using Multidimensional Scaling
% we need to calculate a lower-dimensional projection of the distances 
% among variables, so that they are preserved as much as possible
% reshape dissimilarities as array
D = squareform(dissimilarities);
% calculate eigenvalues:
W = eye(ntotal) - repmat(1/ntotal,ntotal,ntotal);
M = W * (-.5 * D .* D) * W;
[V, E] = eig((M+M')./2);
% sort eigenvalues in descending order:
[e, i] = sort(diag(E));
fe = flipud(e);
fi = flipud(i);
% use only positive eigenvalues
pe = (fe > 0);
Y = V(:, fi(pe)) * diag(sqrt(fe(pe)));
fprintf(1,'\t Project entropy distances in a low-dim space for representation ... OK \n');

% check their spread
[gridvars,~] = meshgrid(1:ntotal, 0 );
miarray = zeros(ntotal,1);
miarrayneg = zeros(ntotal,1); 
for i=1:ntotal
    figure(i); set(gcf,'Color','w');
    miarray(:,:)    = MI(i,:,:);
    miarrayneg(:,:) = MI(:,i,:);
    miarraynegorder = fliplr(miarrayneg);
    miarraycomplete = [miarraynegorder(:,1:end-1), miarray];
    plot(miarraycomplete', gridvars, '-or'); box off;
    grid on;
    titletext = sprintf('Mutual Information between %s and the other variables', variables{i});
    title(titletext)
    xlabel('Normalised mutual information');
    ylabel('Sensory variables');
    set(gca,'YTick',1:ntotal)
    set(gca,'YTickLabel',variables)
end
fprintf(1,'\t Display mutual information of each variable ... OK \n');
figure(ntotal +1); set(gcf,'Color','w');
% plot map with network stucture 
axis(axis);hold on;
% scale the connection array vals for proper correlation strength visual
scale_con_array = 100;
for i=1:ntotal
    for j=1:ntotal
        if con_array (i,j) > 0
            arrow([Y(i,1),Y(i,2)], [Y(j,1),Y(j,2)],...
                'Width', scale_con_array*(con_array(i,j)),'Length',10,'BaseAngle',10,'TipAngle',10)
        end
    end
end
% second, plot data points and variables with normalised mutual information
plot(Y(:,1),Y(:,2),'ok','Markersize',20,'MarkerFaceColor','k')
text(Y(:,1)+0.3,Y(:,2)-0.10,variables,'FontSize',16)
minaxis = floor(min(min(Y(:,1:2))));
maxaxis = ceil(max(max(Y(:,1:2))));
axis([minaxis maxaxis minaxis maxaxis]);
axis equal; box on;
% this is the projected space so scale is not relevant
% relevant is the relative distance between variables as it encodes the 
% statistical relatedness
set(gca,'YTick',[]); set(gca,'XTick',[]);
title('Inferred network structure: connections and statistical relatedness');
fprintf(1,'\t Display inferred network stucture ... OK \n');
fprintf(1,'Running the network inference engine ... OK\n');
end
