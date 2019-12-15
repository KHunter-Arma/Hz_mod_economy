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
private _container = _this select 1;
private _weaponType = _this select 2;

switch (true) do {

	case (_weaponType == (toUpper (primaryWeapon _unit))) : {

		_unit removeWeapon _weaponType;
		_container addWeaponCargoGlobal [_weaponType,1];
		
		hint "You are not trained to use this weapon!";

	};
	
	case (_weaponType == (toUpper (secondaryWeapon _unit))) : {

		_unit removeWeapon _weaponType;
		_container addWeaponCargoGlobal [_weaponType,1];
		
		hint "You are not trained to use this weapon!";

	};

	case (_weaponType == (toUpper (handgunWeapon _unit))) : {

		_unit removeWeapon _weaponType;
		_container addWeaponCargoGlobal [_weaponType,1];
		
		hint "You are not trained to use this weapon!";	

	};
	
	default {
	
		// check for binoculars		
		{
		
			if (_weaponType == (toUpper _x)) exitWith {
			
				_unit removeWeapon _weaponType;
				_container addWeaponCargoGlobal [_weaponType,1];
		
				hint "You are not trained to use this item!";
			
			};
		
		} foreach assigneditems _unit;
		
	};

};