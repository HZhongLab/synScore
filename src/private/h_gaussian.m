function y = h_gaussian(beta, x)
mu = beta(1);
sigma = beta(2);
height = beta(3);
baseline = beta(4);
y = height*normpdf(x, mu, sigma)+baseline;