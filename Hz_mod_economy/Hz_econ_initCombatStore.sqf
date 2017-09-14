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

//compile funcs
Hz_econ_combatStore_fnc_getAttachmentPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getAttachmentPrice.sqf");
Hz_econ_combatStore_fnc_getItemPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getItemPrice.sqf");
Hz_econ_combatStore_fnc_getMagazinePrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getMagazinePrice.sqf");
Hz_econ_combatStore_fnc_getWeaponPrice = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getWeaponPrice.sqf");
Hz_econ_combatStore_fnc_openStore = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_openStore.sqf");
Hz_econ_combatStore_fnc_getGear = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getGear.sqf");
Hz_econ_combatStore_fnc_makePayment = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_makePayment.sqf");
Hz_econ_combatStore_fnc_getGearDifference = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_getGearDifference.sqf");
Hz_econ_combatStore_fnc_checkout = compile preprocessfilelinenumbers (Hz_econ_funcsPath + "Hz_econ_combatStore_fnc_checkout.sqf");

{
_store = missionnamespace getVariable [_x,objNull];
["AmmoboxInit",[_store,true]] call BIS_fnc_arsenal;  

}foreach Hz_econ_combatStore_stores;