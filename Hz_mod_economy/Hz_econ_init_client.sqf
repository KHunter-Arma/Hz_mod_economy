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

waitUntil {sleep 0.1; !isnil "Hz_econ_preInitDone"};
waitUntil {sleep 0.1; Hz_econ_preInitDone};

_moduleLogic = _this select 0;
Hz_econ_pathToPriceCodeFunctions = _moduleLogic getVariable "PathToPriceFunctions";

if (isnil "Hz_econ_pathToPriceCodeFunctions") exitwith {hintc "Hunter'z Economy Module WARNING: Path to price code functions not defined. The stores will not be functional!"};

Hz_econ_vehStore_customPriceFunction = compile preprocessFileLineNumbers (Hz_econ_pathToPriceCodeFunctions + "\Hz_econ_vehStore_fnc_getVehCost.sqf");
Hz_econ_combatStore_customAmmoPrice = compile preprocessFileLineNumbers (Hz_econ_pathToPriceCodeFunctions + "\Hz_econ_combatStore_fnc_getAmmoPrice.sqf");
Hz_econ_combatStore_customMagazinePrice = compile preprocessFileLineNumbers (Hz_econ_pathToPriceCodeFunctions + "\Hz_econ_combatStore_fnc_getMagazinePrice.sqf");
Hz_econ_combatStore_customWeaponPrice = compile preprocessFileLineNumbers (Hz_econ_pathToPriceCodeFunctions + "\Hz_econ_combatStore_fnc_getWeaponPrice.sqf");
Hz_econ_combatStore_customAttachmentPrice = compile preprocessFileLineNumbers (Hz_econ_pathToPriceCodeFunctions + "\Hz_econ_combatStore_fnc_getAttachmentPrice.sqf");
Hz_econ_combatStore_customItemPrice = compile preprocessFileLineNumbers (Hz_econ_pathToPriceCodeFunctions + "\Hz_econ_combatStore_fnc_getItemPrice.sqf");

_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_setupRestrictions.sqf");
_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_initVehStore.sqf");
_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_initCombatStore.sqf");