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