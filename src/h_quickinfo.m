function Aout = h_quickinfo(header)

if header.software.version >=3.8
    Aout.zoom = header.acq.zoomFactor;
    Aout.resolution = [header.acq.pixelsPerLine,header.acq.linesPerFrame];
    maxPower = header.init.eom.maxPower;
    PA_power = header.init.eom.boxPowerArray;
    Aout.imaging_power = maxPower(1);
    if length(PA_power)>=2
        Aout.PA_power = PA_power(2);
    else
        Aout.PA_power = nan;
    end
    Aout.acqTimeString = header.internal.triggerTimeString;
    Aout.relPosition = [header.motor.relXPosition,header.motor.relYPosition,header.motor.relZPosition];
    Aout.distance = header.motor.distance;
else
    Aout.zoom = header.acq.zoomhundreds*100 + header.acq.zoomtens*10 + header.acq.zoomones;
    
    Aout.resolution = [header.acq.pixelsPerLine,header.acq.linesPerFrame];
    if ischar(header.init.eom.maxPower) %different scanimage version use different subfields
        maxPower = eval(header.init.eom.maxPower);
        PA_power = str2num(header.init.eom.boxPowerArray);
    else
        maxPower = header.init.eom.maxPower;
        PA_power = str2num(header.init.eom.boxPowerArrayString);
    end
    
    Aout.imaging_power = maxPower(1);
    if length(PA_power)>=2
        Aout.PA_power = PA_power(2);
    else
        Aout.PA_power = nan;
    end
    Aout.acqTimeString = header.internal.triggerTimeString;
    Aout.relPosition = [header.motor.relXPosition,header.motor.relYPosition,header.motor.relZPosition];
    Aout.distance = header.motor.distance;
end