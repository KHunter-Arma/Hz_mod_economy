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
private _restrictedContainer = _this select 2;
private _items = _this select 3;

// transfer everything
{

	if (!("CA_Magazine" in ([(configfile >> "cfgmagazines" >> _x), true] call bis_fnc_returnParents))) then {

		_container addItemCargoGlobal [_x,1];

	};

} foreach _items;

{
	_container addMagazineAmmoCargo [_x select 0, 1, _x select 1];
}foreach magazinesAmmoCargo _restrictedContainer;