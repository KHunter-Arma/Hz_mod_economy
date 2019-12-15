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

//compile funcs
Hz_econ_combatStore_fnc_getAmmoPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getAmmoPrice.sqf");
Hz_econ_combatStore_fnc_getAttachmentPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getAttachmentPrice.sqf");
Hz_econ_combatStore_fnc_getItemPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getItemPrice.sqf");
Hz_econ_combatStore_fnc_getMagazinePrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getMagazinePrice.sqf");
Hz_econ_combatStore_fnc_getWeaponPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getWeaponPrice.sqf");
Hz_econ_combatStore_fnc_openStore = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_openStore.sqf");
Hz_econ_combatStore_fnc_getGear = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getGear.sqf");
Hz_econ_combatStore_fnc_makePayment = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_makePayment.sqf");
Hz_econ_combatStore_fnc_getGearDifference = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getGearDifference.sqf");
Hz_econ_combatStore_fnc_checkout = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_checkout.sqf");
Hz_econ_combatStore_fnc_getCheckoutCost = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getCheckoutCost.sqf");
Hz_econ_combatStore_fnc_handleAcreRadios = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_handleAcreRadios.sqf");
Hz_econ_combatStore_fnc_checkIfAccessingBackpack = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_checkIfAccessingBackpack.sqf");

_moduleLogic = _this select 0;
_fncName = _moduleLogic getVariable "CombatStoreExitFunctionName";

if (_fncName != "") then {

	waituntil {sleep 1; !isnil {missionNamespace getVariable _fncName}};

	Hz_econ_combatStore_customExitFnc = missionNamespace getVariable _fncName;

} else {

	Hz_econ_combatStore_customExitFnc = {};

};

{
_store = missionnamespace getVariable [_x,objNull];
["AmmoboxInit",[_store,true]] call BIS_fnc_arsenal_M;  

}foreach Hz_econ_combatStore_stores;

[] spawn {

	waitUntil {sleep 1; !isnull player};
	
	player addEventHandler ["Reloaded",{

		_oldmag = _this select 4;

		if (!isnil "_oldmag") then {

			if ((_oldmag select 1) == 0) then {

				player addMagazine [_oldmag select 0,0];

			};

		};

	}];
		
	player addEventHandler ["InventoryOpened",{
	
		params ["_unit", "_container"];
	
		_owner = objectParent _container;
		
		player setVariable ["Hz_econ_lastAccessedContainerOwner",_owner];

		if (isNull _owner) exitWith {false};
		
		if (_owner getVariable ["Hz_econ_backpackLocked",false]) exitWith {true};
		
		false
	
	}];

};
