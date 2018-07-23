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
private _muzzle = _this select 2;
private _magType = toupper ((_this select 3) select 0);
private _ammoCount = (_this select 3) select 1;
private _oldMagArray = _this select 4;

if (_magType in Hz_econ_restrictedMagazines) then {

		if ((_weapon == (primaryWeapon _unit)) || (_weapon == (secondaryWeapon _unit)) || (_weapon == (handgunWeapon _unit))) then {

			_unit setAmmo [_weapon, 0];
			
			_wepHolder = objNull;
			
			if ((vehicle _unit) == _unit) then {
			
				_wepHolder = "groundWeaponHolder" createVehicle [0,0,0];
				_wepHolder setposatl (getposatl _unit);
			
			} else {
			
				_wepHolder = vehicle _unit;
			
			};		
			
			_wepHolder addMagazineAmmoCargo [_magType,1,_ammoCount];

			hint "You are not trained to use this magazine!";

		};

};