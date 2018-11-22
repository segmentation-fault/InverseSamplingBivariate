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

function [X,Y] = generate_sample_bivariate(JointFun, varargin)
%function [X,Y] = generate_sample_bivariate(JointFun)
% Generates two samples from the Joint CDF JointFun(x,y) by approximating
% it as the generation of X=x from the marginal and Y as Y=y|X=x
%function [X,Y] = generate_sample_bivariate(JointFun, margFunX)
% Generates two samples from the Joint CDF JointFun(x,y) given the marginal
% CDF of x margFunX(x)

if numel(varargin) > 0
    margFunX = varargin{1};
else
    margFunX = @(x) JointFun(x,1e5);    %Sufficiently high number to approximate Inf
end

X = generate_sample(margFunX);

ConditionedFun = @(y) JointFun(X,y) / margFunX(X);

Y = generate_sample(ConditionedFun);

end