/*******************************************************************************
* Copyright (C) Hunter'z Economy Module
*
* This file is licensed under a Creative Commons
* Attribution-NonCommercial-ShareAlike 4.0 International License.
* 
* For more information about this license view the LICENSE.md distributed
* together with this file or visit:
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*******************************************************************************/

_originalPos = _this select 0;

player hideObjectGlobal true;

waituntil {!isnil "Hz_econ_vehStore_vehicle"};
waituntil {!isnull Hz_econ_vehStore_vehicle};

waitUntil {dialog};

//start music
ace_hearing_disableVolumeUpdate = true;
playmusic "Hz_econ_media_showroom";

//rotate
while {dialog} do {
    
    player attachto [Hz_econ_vehStore_vehicle,[0,0,0]];    
            
    while {!isnull Hz_econ_vehStore_vehicle && dialog} do {
    
        Hz_econ_vehStore_vehicle setdir ((getdir Hz_econ_vehStore_vehicle) + 0.13);
        
        sleep 0.01;
                
    };

};

deletevehicle Hz_econ_vehStore_vehicle;
detach player;
player setposatl _originalPos;
player hideObjectGlobal false;

5 fademusic 0;
{deletevehicle _x} foreach (uinamespace getvariable "Hz_econ_vehStore_dummyObjects");
sleep 5;
playmusic "";
ace_hearing_disableVolumeUpdate = false;