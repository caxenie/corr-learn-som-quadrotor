clear all
close all

main_AccVsGTRoll
main_AccVsGTPitch

main_GyroVsGTRoll
main_GyroVsGTPitch
main_GyroVsGTYaw

main_EKFVsGTRoll
main_EKFVsGTPitch
main_EKFVsGTYaw

main_EKFLinAccVsGTAccX
main_EKFLinAccVsGTAccY
main_EKFLinAccVsGTAccZ

main_GTLinAccVsGTAccX
main_GTLinAccVsGTAccY
main_GTLinAccVsGTAccZ

main_MagEKFVsGTYaw
main_MagGTVsGTYaw

main_AllVsGTYaw

main_MagBackCalcEKFMagX
main_MagBackCalcEKFMagY
main_MagBackCalcEKFMagZ

main_MagBackCalcGTMagX
main_MagBackCalcGTMagY
main_MagBackCalcGTMagZ

main_MagBackCalcAllMagX
main_MagBackCalcAllMagY
main_MagBackCalcAllMagZ

main_AccRawX
main_AccRawY
main_AccRawZ
main_GTArotObjCosyX
main_GTArotObjCosyY
main_GTArotObjCosyZ

if isfield(data,'OF')==1
    main_OFVsGTHeight
    main_OFVsGTVelX
    main_OFVsGTVelY
end