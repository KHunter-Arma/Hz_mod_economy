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

Hz_econ_path = "\x\Hz\Hz_mod_economy\";
uinamespace setvariable ["Hz_econ_path","\x\Hz\Hz_mod_economy\"];

Hz_econ_funcsPath = Hz_econ_path + "funcs\";
Hz_econ_serverFuncsPath = Hz_econ_path + "funcs_server\";
uinamespace setvariable ["Hz_econ_funcsPath",(uiNamespace getVariable "Hz_econ_path") + "funcs\"];

if (isServer) then {_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_init_server.sqf");};
if (!isDedicated) then {_this call compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_init_client.sqf");};

if (isClass (configfile >> "cfgPatches" >> "ace_main")) then {

	_this spawn compile preprocessFileLineNumbers (Hz_econ_path + "Hz_econ_initAceInterface.sqf");

};