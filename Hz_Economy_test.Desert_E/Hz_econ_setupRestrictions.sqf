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

if (!Hz_econ_enableRestrictions) exitwith {};

//compile dependencies
Hz_econ_fnc_spitOutItems = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_spitOutItems.sqf");
Hz_econ_fnc_checkVehicle = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_checkVehicle.sqf");
Hz_econ_fnc_findNearestAmmoCrate = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_findNearestAmmoCrate.sqf");

//receive custom restrictions from server as client....
[clientOwner, getPlayerUID player] remoteExecCall ["Hz_econ_fnc_serverSendRestrictionInfo",2,false];

waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedVehicles"};
waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedWeapons"};
waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedAttachments"};
waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedItems"};
waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedMagazines"};

sleep 1;

[] execVM (Hz_econ_path + "Hz_econ_client_restrictionsMain.sqf");

