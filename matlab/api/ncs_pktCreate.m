function packet = ncs_pktCreate(srcAddr, dstAddr, payload)
    % Create/restore a DataPacket (Matlab) from the given payload
    % byte stream (which was created by an earlier call of ncs_pktGetPayload) 
    % and the given (Omnet) source and destination addresses.
    %
    % Parameters:
    %   >> srcAddr (Nonnegative integer)
    %      The source address (i.e., the Omnet index of a NCS component)
    %
    %   >> dstAddr (Nonnegative integer)
    %      The destination address (i.e., the Omnet index of a NCS component)
    %
    %   >> payload (uint8 Vector)
    %      A byte stream (i.e., a uint8 row or column vector) which
    %      represents a serialized (i.e., the result of an earlier call of ncs_pktGetPayload) 
    %      4x1 or 1x4 cell array.
    %
    % Returns:
    %   << packet (DataPacket)
    %      The created DataPacket instance.   
    
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
    
    if ~Checks.isClass(payload, 'uint8', numel(payload))
        error('ncs_pktCreate:InvalidPayload', ...
          '** <payload> expected to be a byte stream, i.e. a uint8 vector **'); 
    end
    % we expect the deserialized payload to be a 4x1 or 1x4 cell array
    % timestamp, isAck, id, payload
    data = getArrayFromByteStream(payload);
    if ~iscell(data) || numel(data) ~= 4
        error('ncs_pktCreate:InvalidPayloadStructure', ...
          '** deserialized <payload> expected to be a cell array with 4 elements **');
    end
    
    % construct/restore the packet
    % addresses start at 1 in Matlab!
    packet = CreateDataPacket(data{4}, data{1}, srcAddr + 1, dstAddr + 1, data{2}, data{3});
end
