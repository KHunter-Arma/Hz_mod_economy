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

private _unit = _this select 0;
private _weapon = _this select 1;
private _magType = toUpper ((_this select 3) select 0);
private _ammoCount = (_this select 3) select 1;

if (_magType in Hz_econ_restrictedMagazines) then {

		if ((_weapon == (primaryWeapon _unit)) || (_weapon == (secondaryWeapon _unit)) || (_weapon == (handgunWeapon _unit))) then {

			_unit removeWeapon _weapon;
			_unit addMagazine [_magType,_ammoCount];
			_unit addWeapon _weapon;

			hint "You are not trained to use this magazine!";

		};

};