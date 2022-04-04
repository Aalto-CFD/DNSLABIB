if (SimulationTime > printTimeBegin & (floor(t/100)==t/100))
   UMean = (UMean*(MeanFieldUpdateIndex-1) + U)/MeanFieldUpdateIndex;
   VMean = (VMean*(MeanFieldUpdateIndex-1) + V)/MeanFieldUpdateIndex;
   WMean = (WMean*(MeanFieldUpdateIndex-1) + W)/MeanFieldUpdateIndex;
   UVWMagMean = (UVWMagMean*(MeanFieldUpdateIndex-1) + UVWMag)/MeanFieldUpdateIndex;
   MeanFieldUpdateIndex = MeanFieldUpdateIndex + 1;
end

if (updateMeanCO2Field < SimulationTime)
   CO2MeanTimes = [CO2MeanTimes SimulationTime];
   CO2Mean = [CO2Mean mean(mean(mean(T(Beta==1)*600 + 400)))];
   CO2MeanVar = [CO2MeanVar (mean(mean(mean((T(Beta==1)*600 + 400).^2))) - mean(mean(mean(T(Beta==1)*600 + 400))).^2)];
   updateMeanCO2Field = updateMeanCO2Field + dtCO2TimeAveragingInterval;
end
