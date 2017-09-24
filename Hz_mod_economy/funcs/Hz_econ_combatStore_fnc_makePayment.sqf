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

_totalCost = 0;
_weaponsArray = _this select 0;
_attachmentsArray = _this select 1;
_itemsArray = _this select 2;
_magazinesArray = _this select 3;
_ammoArray = _this select 4;

{

_cost = _x call Hz_econ_combatStore_fnc_getWeaponPrice;
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
_cost = _cost*((_ammoArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_ammoArray select A_TYPE);


Hz_econ_funds = Hz_econ_funds - _totalCost;
publicVariable "Hz_econ_funds";

if((random 1) > 0.5) then {hint format ["Hope you have fun with that!\nTotal Spent: $%1",_totalCost];} else {
if((random 1) > 0.5) then {hint format["I'd be careful with that if I were you!\nTotal Spent: $%1",_totalCost];} else {
hint format["Come back again!\nTotal Spent: $%1",_totalCost];    
		};       
	};