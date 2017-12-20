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

disableserialization;

uinamespace setvariable ["bis_fnc_garage_UI", compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_garage_UI.sqf")];
uinamespace setvariable ["Hz_BIS_fnc_initDisplay", compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_initDisplay.sqf")];
uinamespace setvariable ["Hz_BIS_fnc_initDisplayArsenal", compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_initDisplayArsenal.sqf")];
uinamespace setvariable ["bis_fnc_arsenal_UI", compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_arsenal_UI.sqf")];

waituntil {!isnil "bis_fnc_garage"};
//waituntil {!isnil "bis_fnc_garage3DEN"};

sleep 0.1;

bis_fnc_garage_M = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_garage.sqf");
//bis_fnc_garage3DEN = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_garage3DEN.sqf");

waituntil {!isnil "bis_fnc_arsenal"};

sleep 0.1;

bis_fnc_arsenal_M = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_arsenal.sqf");

Hz_econ_vehStore_fnc_showroom = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_vehStore_fnc_showroom.sqf");
uinamespace setvariable ["Hz_econ_vehStore_fnc_getVehCost",compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_vehStore_fnc_getVehCost.sqf")];
Hz_econ_vehStore_fnc_getVehCost = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_vehStore_fnc_getVehCost.sqf");

uinamespace setvariable ["Hz_econ_vehStore_dummyObjects",[]];

_moduleLogic = _this select 0;
_fncName = _moduleLogic getVariable "VehCustomInitFunctionName";

if (_fncName != "") then {

	waituntil {sleep 1; !isnil {missionNamespace getVariable _fncName}};

	Hz_econ_vehStore_customInitFnc = missionNamespace getVariable _fncName;

} else {

	Hz_econ_vehStore_customInitFnc = {};

};

{
  _store = missionnamespace getVariable [_x,objNull];
  _store addaction ["<t color='#e01414'>Hunter'z Vehicle Store</t>",(Hz_econ_funcsPath + "Hz_econ_vehStore_fnc_openStore.sqf"),[],6,true,false,"","if (Hz_econ_limitedStoreAccess) then {!Hz_econ_vehicleStore_storeClosed} else {true}"];

} foreach Hz_econ_vehStore_stores;



