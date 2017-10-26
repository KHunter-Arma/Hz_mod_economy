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



/*------------------------------------------------------------------------------

        Information in all config variables to be stored in the following way:

                                      [
                                      [UID,INFO],
                                      [UID,INFO],
                                      [UID,INFO],
                                      [UID,INFO],
                                          .
                                          .
                                          .
                                      ]
                                      
      where UID is the player ID as a string, and INFO is an array of strings
      holding classnames (upper case!) of all assets restricted for that UID.

------------------------------------------------------------------------------*/

_clientID = _this select 0;
_clientUID = _this select 1;

/*******************
		 VEHICLES
*******************/

_index = -1;
_info = Hz_econ_cfg_vehicleRestrictions_default;

_found = -1;
{

	_found = _x find _clientUID;

	if(_found != -1) exitwith {_index = _foreachIndex};

}foreach Hz_econ_cfg_vehicleRestrictions;

if(_index != -1) then {

_info = (Hz_econ_cfg_vehicleRestrictions select _index) select 1;

};

Hz_econ_restrictedVehicles = +_info;
_clientID publicVariableClient "Hz_econ_restrictedVehicles";

/*******************
		 WEAPONS
*******************/

_index = -1;
_info = Hz_econ_cfg_weaponsRestrictions_default;

_found = -1;
{

	_found = _x find _clientUID;

	if(_found != -1) exitwith {_index = _foreachIndex};

}foreach Hz_econ_cfg_weaponsRestrictions;

if(_index != -1) then {

_info = (Hz_econ_cfg_weaponsRestrictions select _index) select 1;

};

Hz_econ_restrictedWeapons = +_info;
_clientID publicVariableClient "Hz_econ_restrictedWeapons";

/*******************
		 ATTACHMENTS
*******************/

_index = -1;
_info = Hz_econ_cfg_attachmentRestrictions_default;

_found = -1;
{

	_found = _x find _clientUID;

	if(_found != -1) exitwith {_index = _foreachIndex};

}foreach Hz_econ_cfg_attachmentRestrictions;

if(_index != -1) then {

_info = (Hz_econ_cfg_attachmentRestrictions select _index) select 1;

};

Hz_econ_restrictedAttachments = +_info;
_clientID publicVariableClient "Hz_econ_restrictedAttachments";

/*******************
		 ITEMS
*******************/

_index = -1;
_info = Hz_econ_cfg_itemRestrictions_default;

_found = -1;
{

	_found = _x find _clientUID;

	if(_found != -1) exitwith {_index = _foreachIndex};

}foreach Hz_econ_cfg_itemRestrictions;

if(_index != -1) then {

_info = (Hz_econ_cfg_itemRestrictions select _index) select 1;

};

Hz_econ_restrictedItems = +_info;
_clientID publicVariableClient "Hz_econ_restrictedItems";

/*******************
		 MAGAZINES
*******************/

_index = -1;
_info = Hz_econ_cfg_magazineRestrictions_default;

_found = -1;
{

	_found = _x find _clientUID;

	if(_found != -1) exitwith {_index = _foreachIndex};

}foreach Hz_econ_cfg_magazineRestrictions;

if(_index != -1) then {

_info = (Hz_econ_cfg_magazineRestrictions select _index) select 1;

};

Hz_econ_restrictedMagazines = +_info;
_clientID publicVariableClient "Hz_econ_restrictedMagazines";

/*******************
		 VARIABLES
*******************/

_index = -1;
_info = Hz_econ_cfg_variables_default;

_found = -1;
{

	_found = _x find _clientUID;

	if(_found != -1) exitwith {_index = _foreachIndex};

}foreach Hz_econ_cfg_variables;

if(_index != -1) then {

_info = (Hz_econ_cfg_variables select _index) select 1;

};

Hz_econ_restrictionVariables = +_info;
_clientID publicVariableClient "Hz_econ_restrictionVariables";