if (setHDF5TimeStepArray(setHDF5TimeStepCount+1) < SimulationTime & (setHDF5TimeStepCount+1) <= setHDF5TimeStepCountMax)

   if (ScalarFieldInitIndex == 0)
     InitXDMF;
     EKin = []; EKinDt = []; Chi = []; EkinProd = []; EKinTime = [];
     ScalarFieldInitIndex = 1;
   end

    CreateXDMF;
    CalcTestQuant;
    setHDF5TimeStepCount = setHDF5TimeStepCount + 1;

end
