%   Copyright (C) 2017  Antonio Franco
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

%Tests various univariate distributions against our sampler

clc
clear
close all
reset(symengine)

tic

nSamples = 1e4;

%exponential
lambda = 1.2;
%Generating samples with our sampler
PDFFun = @(t) lambda*exp(-lambda*t).*heaviside(t);
CDFFun = @(t) (1 - exp(-lambda*t)).*heaviside(t);
F = zeros(1,nSamples);
for i = 1:nSamples
    F(i) = generate_sample(CDFFun);
end

%Plotting CDF
figure
hold on
h=histogram(F,'DisplayName','Sampler','Normalization','cdf');
X = diff(h.BinEdges(1:2)/2)+h.BinEdges(1:end-1);
plot(X,CDFFun(X),'DisplayName','Analytical','LineWidth',2);
legend('show');
xlabel('t')
ylabel('CDF')
title(['exponential \lambda = ' num2str(lambda)]);
hold off

%Plotting PDF
figure
hold on
h=histogram(F,'DisplayName','Sampler','Normalization','pdf');
X = diff(h.BinEdges(1:2)/2)+h.BinEdges(1:end-1);
plot(X,PDFFun(X),'DisplayName','Analytical','LineWidth',2);
xlabel('t')
ylabel('PDF')
title(['exponential \lambda = ' num2str(lambda)]);
hold off

%Sum of two exponentials
lambda = 1.2;
mu = 1;
%Generating samples with our sampler
PDFFun = @(t) (lambda/(lambda-mu).*mu*exp(-mu*t) - mu/(lambda-mu) * lambda*exp(-lambda*t)).*heaviside(t);
CDFFun = @(t) (lambda/(lambda-mu).*(1-exp(-mu*t)) - mu/(lambda-mu) * (1-exp(-lambda*t))).*heaviside(t);
F = zeros(1,nSamples);
for i = 1:nSamples
    F(i) = generate_sample(CDFFun);
end

%Plotting CDF
figure
hold on
h=histogram(F,'DisplayName','Sampler','Normalization','cdf');
X = diff(h.BinEdges(1:2)/2)+h.BinEdges(1:end-1);
plot(X,CDFFun(X),'DisplayName','Analytical','LineWidth',2);
legend('show');
xlabel('t')
ylabel('CDF')
title(['sum of exponential \lambda = ' num2str(lambda) ' and exponential \mu = ' num2str(mu)]);
hold off

%Plotting PDF
figure
hold on
h=histogram(F,'DisplayName','Sampler','Normalization','pdf');
X = diff(h.BinEdges(1:2)/2)+h.BinEdges(1:end-1);
plot(X,PDFFun(X),'DisplayName','Analytical','LineWidth',2);
xlabel('t')
ylabel('PDF')
title(['sum of exponential \lambda = ' num2str(lambda) ' and exponential \mu = ' num2str(mu)]);
hold off

elapsedTime = toc;
s = seconds(elapsedTime);
s.Format = 'hh:mm:ss.SSS';
disp('Elapsed time (hms): ');
disp(s);