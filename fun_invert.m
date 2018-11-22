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

function [F,exitflag] = fun_invert(a,fun)
%function [F,exitflag] = fun_invert(a,fun)
% Calculates the inverted function fun in point a and returns the value in
% F. exitflag is the exitflag from fzero

options = optimset('Display','off');

maxIter = 10;

zFun = @(t) fun(t) - a;

exitflag = 0;

m = 0;

while exitflag < 1 && m < maxIter
    t0 = rand;
    [F,~,exitflag,~]  = fzero(zFun,t0,options);

    if(exitflag == -6)
        warning('No root found! Retry with another value.')
        break;
    end
    
    if(exitflag < 1)
        m = m + 1;
    end
end

end
