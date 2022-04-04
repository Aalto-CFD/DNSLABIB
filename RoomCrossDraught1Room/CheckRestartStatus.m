ScalarFieldInitIndex = 0;

if (UseRestart == 0)
    CreateFields;
    InitializeDrops;
    InitializeScalar;
    ScalarFieldInitIndex = 0;

    if (UseGPU==0)
      CreateCpuArrays;
    else
      CreateGpuArrays;
    end

    t=1;
    MeanFieldUpdateIndex = 1;
else
     RemapFields;
end
