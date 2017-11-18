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

private _unit = _this select 0;
private _container = _this select 1;
private _attachmentType = _this select 2;

// scan all currently used weapons
private _found = false;
{
					
	if ((toupper _x) == _attachmentType) exitWith {

	_found = true;
	_unit removePrimaryWeaponItem _attachmentType;
	_container addItemCargoGlobal [_attachmentType,1];
	
	};

} foreach primaryWeaponItems _unit;

if (_found) exitWith {hint "You are not trained to use this attachment!";};

{
					
	if ((toupper _x) == _attachmentType) exitWith {

	_found = true;
	_unit removeSecondaryWeaponItem _attachmentType;
	_container addItemCargoGlobal [_attachmentType,1];
	
	};

} foreach secondaryWeaponItems _unit;

if (_found) exitWith {hint "You are not trained to use this attachment!";};

{
					
	if ((toupper _x) == _attachmentType) exitWith {

	_found = true;
	_unit removeHandgunItem _attachmentType;
	_container addItemCargoGlobal [_attachmentType,1];
	
	hint "You are not trained to use this attachment!";
	
	};

} foreach handgunItems _unit;




