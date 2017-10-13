private _unit = _this select 0;
private _vehicle = _this select 2;

if ((toupper typeof _vehicle) in Hz_econ_restrictedVehicles) then {

	if ((_unit == (driver _vehicle)) || (_unit == (gunner _vehicle)) || (_unit == (commander _vehicle))) then {

		hint "You are not trained to use this vehicle!";
		_unit action ["Eject", _vehicle];

	};

};