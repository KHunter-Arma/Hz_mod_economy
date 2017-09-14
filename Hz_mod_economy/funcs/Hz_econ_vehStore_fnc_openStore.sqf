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

_storeObj = _this select 0;
_caller = _this select 1;

_spawnPos = _storeObj getvariable ["Hz_econ_vehStore_spawnPos",getposatl _storeObj];

if ((count nearestObjects [_spawnPos,["LandVehicle","Air"],10]) > 0) exitwith {hint "Error: Vehicle delivery position obstructed!";};

BIS_fnc_garage_center = nil;
BIS_fnc_arsenal_center = nil;

_originalPos = getposatl _caller;
_caller setposatl _spawnPos;

[_originalPos] spawn Hz_econ_vehStore_fnc_showroom;

["Open",true] call BIS_fnc_garage;