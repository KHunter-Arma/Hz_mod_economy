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

Hz_econ_fnc_serverSendRestrictionInfo = compile preprocessfilelinenumbers (Hz_econ_serverFuncsPath + "Hz_econ_fnc_serverSendRestrictionInfo.sqf");

_moduleLogic = _this select 0;
Hz_econ_enableRestrictions = _moduleLogic getVariable ["Hz_econ_module_pRestrictions",false];
Hz_econ_combatStore_stores = _moduleLogic getVariable ["Hz_econ_module_pCombatStores",[]];
Hz_econ_vehStore_stores = _moduleLogic getVariable ["Hz_econ_module_pVehStores",[]];
Hz_econ_funds = _moduleLogic getVariable ["Hz_econ_module_pFunds",0];

publicvariable "Hz_econ_enableRestrictions";
publicvariable "Hz_econ_combatStore_stores";
publicvariable "Hz_econ_vehStore_stores";
publicvariable "Hz_econ_funds";

Hz_econ_module_pRestrictionsSetupFunctionName = _moduleLogic getVariable ["Hz_econ_module_pRestrictionsSetupFunctionName",""];

if (Hz_econ_enableRestrictions) then {

	[] spawn {

		waitUntil {
		
			sleep 0.1;
			
			!isnil {missionNamespace getVariable Hz_econ_module_pRestrictionsSetupFunctionName};
		
		};
		
		_func = missionNamespace getVariable Hz_econ_module_pRestrictionsSetupFunctionName;

		call _func;
		
		Hz_econ_preInitDone = true;
		publicVariable "Hz_econ_preInitDone";
		
	};

} else {

	Hz_econ_preInitDone = true;
	publicVariable "Hz_econ_preInitDone";

};

