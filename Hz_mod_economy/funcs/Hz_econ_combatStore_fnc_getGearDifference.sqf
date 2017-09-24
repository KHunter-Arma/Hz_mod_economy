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

#define A_TYPE 0
#define A_COUNT 1
#define A_WEP 0
#define A_ATT 1
#define A_ITM 2
#define A_MAG 3
#define A_AMM 4

_itemsBefore = (_this select 1) select A_ITM;
_weaponsBefore = (_this select 1) select A_WEP;
_magazinesBefore = (_this select 1) select A_MAG;
_attachmentsBefore = (_this select 1) select A_ATT;
_ammoBefore = (_this select 1) select A_AMM;
_itemsNow = (_this select 0) select A_ITM;
_weaponsNow = (_this select 0) select A_WEP;
_magazinesNow = (_this select 0) select A_MAG;
_attachmentsNow = (_this select 0) select A_ATT;
_ammoNow = (_this select 0) select A_AMM;

_returnItems = [[],[]];
_returnWeapons = [[],[]];
_returnAttachments = [[],[]];
_returnMagazines = [[],[]];
_returnAmmo = [[],[]];

{
	_existingAmount = 0;
	_index = (_itemsBefore select A_TYPE) find _x;
	
	if (_index != -1) then {
	
	_existingAmount = (_itemsBefore select A_COUNT) select _index;
	
	};
	
	_newAmount = ((_itemsNow select A_COUNT) select _foreachIndex) - _existingAmount;
	
	if (_newAmount > 0) then {
	
		(_returnItems select A_TYPE) pushback _x;
		(_returnItems select A_COUNT) pushback _newAmount;
	
	};

} foreach (_itemsNow select A_TYPE);


{
	_existingAmount = 0;
	_index = (_weaponsBefore select A_TYPE) find _x;
	
	if (_index != -1) then {
	
	_existingAmount = (_weaponsBefore select A_COUNT) select _index;
	
	};
	
	_newAmount = ((_weaponsNow select A_COUNT) select _foreachIndex) - _existingAmount;
	
	if (_newAmount > 0) then {
	
		(_returnWeapons select A_TYPE) pushback _x;
		(_returnWeapons select A_COUNT) pushback _newAmount;
	
	};

} foreach (_weaponsNow select A_TYPE);

{
	_existingAmount = 0;
	_index = (_attachmentsBefore select A_TYPE) find _x;
	
	if (_index != -1) then {
	
	_existingAmount = (_attachmentsBefore select A_COUNT) select _index;
	
	};
	
	_newAmount = ((_attachmentsNow select A_COUNT) select _foreachIndex) - _existingAmount;
	
	if (_newAmount > 0) then {
	
		(_returnAttachments select A_TYPE) pushback _x;
		(_returnAttachments select A_COUNT) pushback _newAmount;
	
	};

} foreach (_attachmentsNow select A_TYPE);

{
	_existingAmount = 0;
	_index = (_magazinesBefore select A_TYPE) find _x;
	
	if (_index != -1) then {
	
	_existingAmount = (_magazinesBefore select A_COUNT) select _index;
	
	};
	
	_newAmount = ((_magazinesNow select A_COUNT) select _foreachIndex) - _existingAmount;
	
	if (_newAmount > 0) then {
	
		(_returnMagazines select A_TYPE) pushback _x;
		(_returnMagazines select A_COUNT) pushback _newAmount;
	
	};

} foreach (_magazinesNow select A_TYPE);

{
	_existingAmount = 0;
	_index = (_ammoBefore select A_TYPE) find _x;
	
	if (_index != -1) then {
	
	_existingAmount = (_ammoBefore select A_COUNT) select _index;
	
	};
	
	_newAmount = ((_ammoNow select A_COUNT) select _foreachIndex) - _existingAmount;
	
	if (_newAmount > 0) then {
	
		(_returnAmmo select A_TYPE) pushback _x;
		(_returnAmmo select A_COUNT) pushback _newAmount;
	
	};

} foreach (_ammoNow select A_TYPE);


[_returnWeapons,_returnAttachments,_returnItems,_returnMagazines,_returnAmmo]