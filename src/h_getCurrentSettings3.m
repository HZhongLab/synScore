function currentSettings = h_getCurrentSettings3(handles)

% this function gets the red, green and blue limits and z limits from h_imstack2/2a
% as specified in handles.

currentSettings.zLim(1) = str2num(get(handles.zStackStrLow, 'string'));
currentSettings.zLim(2) = str2num(get(handles.zStackStrHigh, 'string'));

currentSettings.redLim(1) = str2num(get(handles.redLimitStrLow, 'string'));
currentSettings.redLim(2) = str2num(get(handles.redLimitStrHigh, 'string'));

currentSettings.greenLim(1) = str2num(get(handles.greenLimitStrLow, 'string'));
currentSettings.greenLim(2) = str2num(get(handles.greenLimitStrHigh, 'string'));

currentSettings.blueLim(1) = str2num(get(handles.blueLimitStrLow, 'string'));
currentSettings.blueLim(2) = str2num(get(handles.blueLimitStrHigh, 'string'));

