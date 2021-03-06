function header = parseHeader(input)
% PARSEHEADER   - Read ScanImage Header String and return structure.
%   PARSEHEADER will output the value of the header fields as a structure.
%   Input is the header from ScanImage TIF File (char array).
%
% See also

% Modified by Aleksander Sobczyk on 3/11/04 to allow proper handling of
% uncaging data

tempstring = {};
index = 0;
tempcell = strread(input, '%q');

for lineCounter = 1 : length(tempcell)
    data = tempcell{lineCounter};
    if strncmp(data, 'state.', 6)
        index = index + 1;
        tempstring{index} = data;
    else
        tempstring{index} = [tempstring{index} ' ' data];
    end
end

for i = 1 : index
    data = tempstring{i};
    equal = findstr('=', data);
    param = data(7 : equal-1);
    if length(data) == equal
        val = [];
    else
        if data(equal+1)=='''' & data(end)==''''
            % string
            val = data(equal+2 : end-1);
        else
            % double
            val = str2num(data(equal+1 : end));
        end
    end
    eval(['header.' param '=val;']);
end


% --------------------------------------------
% This is old verion of parseHeader function
% --------------------------------------------
% out={};
% tempcell=strread(input,'%q'); 
% for lineCounter=1:length(tempcell)    
%     data=tempcell{lineCounter};
%     if ~strncmp(data,'state.',6)
%         out{end}=[out{end} ' ' data(1:end-1)];
%         continue
%     end
%     equal=findstr('=',data);
%     param=data(7:equal-1);
%     val=data(equal+1:end);
%     if ~strcmp(val(1),'''')
%         val=str2num(val);
%     else
% 		if strcmp(val(end),'''')
%         	val=val(2:end-1);
% 		else
% 			val=val(2:end);
% 		end
%     end
%     out=[out {param} {val}];
% end
% 
% while length(out)>2
%     eval(['header.' out{1} '=out{2};']);
%     out=out(3:end);
% end