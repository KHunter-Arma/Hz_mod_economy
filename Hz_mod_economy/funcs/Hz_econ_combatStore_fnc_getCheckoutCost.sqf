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

#define A_TYPE 0
#define A_COUNT 1

private _totalCost = 0;
private _weaponsArray = _this select 0;
private _attachmentsArray = _this select 1;
private _itemsArray = _this select 2;
private _magazinesArray = _this select 3;
private _ammoArray = _this select 4;

{

private _cost = _x call Hz_econ_combatStore_fnc_getWeaponPrice;
_cost = _cost*((_weaponsArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_weaponsArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getAttachmentPrice;
_cost = _cost*((_attachmentsArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_attachmentsArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getItemPrice;
_cost = _cost*((_itemsArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_itemsArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getMagazinePrice;
_cost = _cost*((_magazinesArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_magazinesArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getAmmoPrice;

//exception handling
if (_cost == -1) then {_cost = 0;};

_cost = _cost*((_ammoArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_ammoArray select A_TYPE);


_totalCost