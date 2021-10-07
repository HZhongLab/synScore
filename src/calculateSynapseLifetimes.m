function [vec] = calculateSynapseLifetimes(binaryMatrix)

sz = size(binaryMatrix);
numSynapses = sz(1);
numTP = sz(2);

synapseLifetimes = sum(binaryMatrix,2);

x = unique(synapseLifetimes);

   N = numel(x);
   count = zeros(N,1);
   for k = 1:N
      count(k) = sum(synapseLifetimes==x(k));
   end
   disp([ x(:) count ]);

normalizedCount = count / numSynapses;

vec = zeros(1,numTP);
%Patch
delINDX = find(x == 0);
x(delINDX) = [];
normalizedCount(delINDX) = [];
vec(x) = normalizedCount;

end

