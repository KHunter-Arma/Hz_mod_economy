_disp = findDisplay 602;

if (!isNull _disp) then {

	_owner = player getVariable ["Hz_econ_lastAccessedContainerOwner",objnull];
	
	if (player == _owner) exitWith {};

	if (_owner == _this) then {
	
		_disp closeDisplay 0;
	
	};

};