function [ output_args ] = normalDistTest( input_args )
%This is a test to see if the data is normally distributed.
%Currently unusued.

%Check if the ages of participants is normally distributed.  This is
%important for determining whether we can use certain tests.
ages = WorkingTable(:,389)+1;
%plot the histogram and plot the normal curve.  Eh, it's good enough.
histogram(ages,'Normalization','pdf')
hold on
y = -5:0.1:15;
mu = mean(ages);
sigma = std(ages);
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',1.5)
%How well does this fit a normal distribution?
probabilityDist = fitdist(ages,'Normal');
[h,p] = chi2gof(ages,'CDF',probabilityDist);
%Turns out, not well, but qualitatively, nothing else is really better.  I
%checked this in the statistics toolkit by applying every possible
%distribution.  A few are slightly closer, but normal is easiest to manage.

%Anderson-Darling test for normality
[h,p] = adtest(WorkingTable(:,389));


end

