% Judge whether a watermelon is good by its density and sugar content
% Based on LDA method
% The purpose is to find the best projection direction omega

% We use the data given as DATASET_3.0alpha on page 89
% Firstly, get all dadta
% There are 17 records in total, and each row represents a watermelon
% The data of each watermelon is in form:
% [number of the watermelon, density, sugar content, good(1) or bad(0)]
watermelons = [1 0.697 0.460 1;
               2 0.774 0.376 1;
               3 0.634 0.264 1;
               4 0.608 0.318 1;
               5 0.556 0.215 1;
               6 0.403 0.237 1;
               7 0.481 0.149 1;
               8 0.437 0.211 1;
               9 0.666 0.091 0;
               10 0.243 0.267 0;
               11 0.245 0.057 0;
               12 0.343 0.099 0;
               13 0.639 0.161 0;
               14 0.657 0.198 0;
               15 0.360 0.370 0;
               16 0.593 0.042 0;
               17 0.719 0.103 0];

% Get good ones and bad ones in the dataset
good_watermelons = [];
bad_watermelons = [];
for i = 1:1:17
    if watermelons(i,4) == 1
        good_watermelons = [good_watermelons; watermelons(i,1:end)];
    else
        bad_watermelons = [bad_watermelons; watermelons(i,1:end)];
    end
end

% test
% good_watermelons
% bad_watermelons

% Calculate the certer of each class

% The certer of good watermelons in coloum vector form
% miu_1 is the center of good watermelons
% miu_0 is the center of bad watermelons
miu_1 = [mean(good_watermelons(1:end,2)), mean(good_watermelons(1:end,3))]';
miu_0 = [mean(bad_watermelons(1:end,2)), mean(bad_watermelons(1:end,3))]';

% test
% miu_0
% miu_1

% Calculate the between-class sactter matrix Sb
Sb = (miu_0-miu_1)*(miu_0-miu_1)';

% test
% Sb

% Calculate the within_class scatter matrix

% The shape of Sw is decided by the numbers of properties given in the dataset
Sw = zeros(2,2); 

for i = 1:1:size(good_watermelons,1)
    Sw = Sw+(good_watermelons(i,2:3)'-miu_1)*(good_watermelons(i,2:3)'-miu_1)';
end
for i = 1:1:size(bad_watermelons,1)
    Sw = Sw+(bad_watermelons(i,2:3)'-miu_0)*(bad_watermelons(i,2:3)'-miu_0)';
end

% test
% Sw

% Do Singular Value Decomposition(SVD) for Sw and calculate the inverse of Sw
[U,S,V] = svd(Sw);
Sw_inverse = V*S^(-1)*U';

% test
% Sw_inverse

% Calculate the projection direction 
w = Sw_inverse*(miu_0-miu_1);
display('The projection direction vector is:');
display(w);

% The norm of w might not be 1, so we need to normlize it
norm_w = norm(w);
w = 1/norm_w*w;
display('The normalized projection direction vector is:');
display(w);

w = -1*w; % In later process we find w is double negetive, so reverse it
% do not effect the projection direction
% but make calculate more convenient
display('The normalized and reversed projection direction vector is:');
display(w);

% test
% w
% norm(w)

% The next is to make the results visionable
% Let desity be the first axis(x), and sugar content the second(y)
hold on;
xlabel('density');
ylabel('sugar content');

% Show bad watermelons and good watermelons
plot(bad_watermelons(1:end,2), bad_watermelons(1:end,3), 'ro');
plot(good_watermelons(1:end,2), good_watermelons(1:end,3), 'go');

% Show projection direction
x = 0:0.01:1;
y = x/w(1)*w(2);
plot(x,y,'k-');

% process bad watermelons
bad_projection_length = w'*bad_watermelons(1:end,2:3)';
bad_projection_points = [w(1)*bad_projection_length;w(2)*bad_projection_length];
plot(bad_projection_points(1,1:end),bad_projection_points(2,1:end),'r*');
bad_projection_center = w'*miu_0*w;
plot(bad_projection_center(1),bad_projection_center(2),'bo');

% process good watermelons
good_projection_length = w'*good_watermelons(1:end,2:3)';
good_projection_points = [w(1)*good_projection_length;w(2)*good_projection_length];
plot(good_projection_points(1,1:end),good_projection_points(2,1:end),'g*');
good_projection_center = w'*miu_1*w;
plot(good_projection_center(1),good_projection_center(2),'bo');

hold off;