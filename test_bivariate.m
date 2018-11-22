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

%Tests various bivariate distributions against our sampler

clc
clear
close all
reset(symengine)

tic

nSamples = 1e3;

%Bivariate exponential type 3
m = 2;
JointCDF = @(x,y) (1 - exp(-x) - exp(-y) + exp(-(x.^m+y.^m).^(1/m))) .* heaviside(x) .* heaviside(y);
margCDFX = @(x) (1 - exp(-x)).*heaviside(x);
JointPDF = @(x,y) (x.^m + y.^m).^(-2+1/m) .* x.^(m-1) .* y.^(m-1) .* ((x.^m+y.^m).^(1/m) + m - 1).*exp(-(x.^m+y.^m).^(1/m)).*heaviside(x).*heaviside(y);

X1 = zeros(1,nSamples);
Y1 = zeros(1,nSamples);
X2 = zeros(1,nSamples);
Y2 = zeros(1,nSamples);
parfor i=1:nSamples
    %No marginal provided
    [x,y] = generate_sample_bivariate(JointCDF);
    X1(i) = x;
    Y1(i) = y;
    %Marginal provided
    [x,y] = generate_sample_bivariate(JointCDF,margCDFX);
    X2(i) = x;
    Y2(i) = y;
end

figure
hold on
h = histogram2(X1,Y1,'Normalization','pdf','DisplayName','Sampling');
h.FaceAlpha = 0.5;
t1 = diff(h.XBinEdges(1:2)/2)+h.XBinEdges(1:end-1);
t2 = diff(h.YBinEdges(1:2)/2)+h.YBinEdges(1:end-1);
[T1,T2] = meshgrid(t1,t2);
h1=surf(T1,T2,JointPDF(T1,T2),'DisplayName','Analytical');
h1.FaceAlpha = 0.5;
h1.FaceColor = 'r';
title('PDF sampling (marginal automatically calculated)');
view([61,22]);
legend('show')
xlabel('x')
ylabel('y')
hold off

figure
hold on
h = histogram2(X2,Y2,'Normalization','pdf','DisplayName','Sampling');
h.FaceAlpha = 0.5;
t1 = diff(h.XBinEdges(1:2)/2)+h.XBinEdges(1:end-1);
t2 = diff(h.YBinEdges(1:2)/2)+h.YBinEdges(1:end-1);
[T1,T2] = meshgrid(t1,t2);
h1=surf(T1,T2,JointPDF(T1,T2),'DisplayName','Analytical');
h1.FaceAlpha = 0.5;
h1.FaceColor = 'r';
title('PDF sampling (marginal provided)');
view([61,22]);
legend('show')
xlabel('x')
ylabel('y')
hold off

elapsedTime = toc;
s = seconds(elapsedTime);
s.Format = 'hh:mm:ss.SSS';
disp('Elapsed time (hms): ');
disp(s);