/*******************************************************************************
* Copyright (C) 2017-2018 K.Hunter
*
* This file is licensed under a Creative Commons
* Attribution-NonCommercial-ShareAlike 4.0 International License.
* 
* For more information about this license view the LICENSE.md distributed
* together with this file or visit:
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*******************************************************************************/

waitUntil {dialog};

waituntil {!isnil "Hz_econ_vehStore_vehicle" || !dialog};

if (!dialog) exitWith {deleteVehicle Hz_econ_vehStore_showroomCenterObj};

waituntil {!isnull Hz_econ_vehStore_vehicle || !dialog};

if (!dialog) exitWith {deleteVehicle Hz_econ_vehStore_showroomCenterObj};

//start music
ace_hearing_disableVolumeUpdate = true;
playmusic "Hz_econ_media_showroom";

//rotate
while {dialog} do {
            
    while {!isnull Hz_econ_vehStore_vehicle && dialog} do {
    
        Hz_econ_vehStore_vehicle setdir ((getdir Hz_econ_vehStore_vehicle) + 0.13);
        
        sleep 0.01;
                
    };

};

deletevehicle Hz_econ_vehStore_vehicle;
deleteVehicle Hz_econ_vehStore_showroomCenterObj;

5 fademusic 0;
{
	_veh = vehicle _x;
	if (_veh == _x) then {							
		deletevehicle _x;							
	} else {
		moveout _x;
		sleep 1;
		deletevehicle _x;
	};
} foreach (uinamespace getvariable "Hz_econ_vehStore_dummyObjects");
sleep 5;
playmusic "";
ace_hearing_disableVolumeUpdate = false;