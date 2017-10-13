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