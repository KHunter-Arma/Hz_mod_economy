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

_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_setupRestrictions.sqf");
_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_initVehStore.sqf");
_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_initCombatStore.sqf");