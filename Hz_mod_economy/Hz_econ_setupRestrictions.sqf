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

if (!Hz_econ_enableRestrictions) exitwith {};

//compile dependencies
Hz_econ_fnc_handleTakeItem = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleTakeItem.sqf");
Hz_econ_fnc_handleTakeRestrictedWeapon = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleTakeRestrictedWeapon.sqf");
Hz_econ_fnc_handleTakeRestrictedAttachment = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleTakeRestrictedAttachment.sqf");
Hz_econ_fnc_handleTakeRestrictedWearable = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleTakeRestrictedWearable.sqf");
Hz_econ_fnc_handleReloaded = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleReloaded.sqf");
Hz_econ_fnc_handleGetIn = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleGetIn.sqf");
Hz_econ_fnc_handleSeatSwitch = compile preprocessFileLineNumbers (Hz_econ_funcsPath + "Hz_econ_fnc_handleSeatSwitch.sqf");

_this spawn {
	
	waitUntil {sleep 1; !isnull player};
	sleep 1;

	//receive custom restrictions from server as client....
	[clientOwner, getPlayerUID player] remoteExecCall ["Hz_econ_fnc_serverSendRestrictionInfo",2,false];

	waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedVehicles"};
	waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedWeapons"};
	waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedAttachments"};
	waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedItems"};
	waitUntil {sleep 0.1; !isnil "Hz_econ_restrictedMagazines"};
	waitUntil {sleep 0.1; !isnil "Hz_econ_restrictionVariables"};

	sleep 0.1;

	player addEventHandler ["Take",Hz_econ_fnc_handleTakeItem];
	player addEventHandler ["Reloaded",Hz_econ_fnc_handleReloaded];
	player addEventHandler ["GetInMan",Hz_econ_fnc_handleGetIn];
	player addEventHandler ["SeatSwitchedMan",Hz_econ_fnc_handleSeatSwitch];

	{

		player setvariable _x;

	} foreach Hz_econ_restrictionVariables;


	//store magazine types for Put and Throw weapons

	_throwClass = configFile >> "CfgWeapons" >> "Throw";
	_throwMuzzles = getArray (_throwClass >> "muzzles");
	Hz_econ_allThrowableMags = [];

	{
		_muzzle = _x;
		_magazines = getArray (_throwClass >> _muzzle >> "Magazines");
		
		{
			
			Hz_econ_allThrowableMags pushbackunique (toupper _x);
			
		} foreach _magazines;

	} foreach _throwMuzzles;

	_putClass = configFile >> "CfgWeapons" >> "Put";
	_putMuzzles = getArray (_putClass >> "muzzles");
	Hz_econ_allPutableMags = [];

	{
		_muzzle = _x;
		_magazines = getArray (_putClass >> _muzzle >> "Magazines");
		
		{
			
			Hz_econ_allPutableMags pushbackunique (toupper _x);
			
		} foreach _magazines;

	} foreach _putMuzzles;

};