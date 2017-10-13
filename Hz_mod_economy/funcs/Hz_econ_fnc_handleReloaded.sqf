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