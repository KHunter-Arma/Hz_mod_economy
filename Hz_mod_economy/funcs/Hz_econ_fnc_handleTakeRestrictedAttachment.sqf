private _unit = _this select 0;
private _container = _this select 1;
private _attachmentType = _this select 2;

// scan all currently used weapons
private _found = false;
{
					
	if ((toupper _x) == _attachmentType) exitWith {

	_found = true;
	_unit removePrimaryWeaponItem _attachmentType;
	_container addItemCargoGlobal [_attachmentType,1];
	
	};

} foreach primaryWeaponItems _unit;

if (_found) exitWith {hint "You are not trained to use this attachment!";};

{
					
	if ((toupper _x) == _attachmentType) exitWith {

	_found = true;
	_unit removeSecondaryWeaponItem _attachmentType;
	_container addItemCargoGlobal [_attachmentType,1];
	
	};

} foreach secondaryWeaponItems _unit;

if (_found) exitWith {hint "You are not trained to use this attachment!";};

{
					
	if ((toupper _x) == _attachmentType) exitWith {

	_found = true;
	_unit removeHandgunItem _attachmentType;
	_container addItemCargoGlobal [_attachmentType,1];
	
	hint "You are not trained to use this attachment!";
	
	};

} foreach handgunItems _unit;




