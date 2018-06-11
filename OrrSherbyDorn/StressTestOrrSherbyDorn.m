% Copyright © 2018 CA Bezuidenhout
% This file is part of creep-models.
%
% creep-models is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% creep-models is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with creep-models.  If not, see <http://www.gnu.org/licenses/>.
%=====================================================================
function testResult = StressTestOrrSherbyDorn( osdModel, creepData ) 
  testResult.stressActual = creepData.stress;
  testResult.stressPredicted = zeros( size( creepData.stress) );
  testResult.tr = creepData.tr;
  testResult.T = creepData.T; 

  for( c=1:length(testResult.tr) ) 
    for( r=1:length(testResult.T) )
      expectedAwnser = testResult.stressActual(r,c);
      tr = testResult.tr(c);
      T = testResult.T(r);

      pOSD = log10( tr ) - osdModel.Cosd/ConvTemp(T,'c','k');

      
      pOSDmc = fliplr( osdModel.masterCurve.coefficients' );
      pOSDmc( length(pOSDmc) ) = pOSDmc( length(pOSDmc) ) - pOSD;
          
      awnsers = roots(pOSDmc);
      closestAwnser = 0;
      smallestError = Inf;      

      for( i=1:length(awnsers) ) 
        currentAwnser = awnsers(i);

        if( imag( currentAwnser ) == 0 ) 
          currentAwnser = 10^currentAwnser;
          currentError = abs(expectedAwnser-currentAwnser);

          if( currentError < smallestError )
            smallestError = currentError;
            closestAwnser = currentAwnser;
          end
        end 
      end
      
      testResult.stressPredicted(r,c) = closestAwnser;        
    end
  end

  testResult.errors = Errors( testResult.stressPredicted, testResult.stressActual );
endfunction