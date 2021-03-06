function [costs, controllerStats, plantStats] = ncs_finalize(ncsHandle)
    % Finish a control task (NCS simulation) in Matlab and clean up resources.
    %
    % Parameters:
    %   >> ncsHandle (Key into ComponentMap, uint32)
    %      A handle (key into ComponentMap) which uniquely identifies a NetworkedControlSystem.
    %
    % Returns:
    %   << costs (Nonnegative scalar)
    %      The accrued costs according to the controller's underlying cost functional.
    %
    %   << controllerStats (Struct)
    %     Struct containing control-related data gathered during the execution
    %     of the control task. At least the following fields are present:
    %     -numUsedMeasurements (Row vector of nonnegative integers), indicating the number
    %     of measurements that have been used by the controller/estimator at each time step
    %     -numDiscardedMeasurements (Row vector of nonnegative integers), indicating the number
    %     of measurements that have been discarded by the controller/estimator at each time step
    %     -controllerStates (Matrix), 
    %     containing the plant states kept by the controller per time step
    %     -numDiscardedControlSequences (Row vector of nonnegative integers), indicating the number
    %     of received control sequences that have been discarded by the actuator at each time step
    %
    %   << plantStats (Struct)
    %     Struct containing plant-related data gathered during the execution
    %     of the control task. At least the following fields are present:
    %     -appliedInputs (Matrix), 
    %     containing the actually applied control inputs per time step (time step w.r.t
    %     plant sampling rate)
    %     -trueStates (Matrix), 
    %     containing the true plant states per time step (time step w.r.t
    %     plant sampling rate)  
    
    %    This program is free software: you can redistribute it and/or modify
    %    it under the terms of the GNU General Public License as published by
    %    the Free Software Foundation, either version 3 of the License, or
    %    (at your option) any later version.
    %
    %    This program is distributed in the hope that it will be useful,
    %    but WITHOUT ANY WARRANTY; without even the implied warranty of
    %    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %    GNU General Public License for more details.
    %
    %    You should have received a copy of the GNU General Public License
    %    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    ncs = GetNcsByHandle(ncsHandle);

    ncsStats = ncs.getStatistics();
    costs = ncs.computeTotalControlCosts();
    controllerStats.numUsedMeasurements = ncsStats.numUsedMeasurements;
    controllerStats.numDiscardedMeasurements = ncsStats.numDiscardedMeasurements;
    controllerStats.numDiscardedControlSequences = ncsStats.numDiscardedControlSequences;        
    controllerStats.controllerStates = ncsStats.controllerStates;
    
    plantStats.trueStates = ncsStats.trueStates;
    plantStats.appliedInputs = ncsStats.appliedInputs;
      
    ComponentMap.getInstance().removeComponentByIndex(ncsHandle);
end

