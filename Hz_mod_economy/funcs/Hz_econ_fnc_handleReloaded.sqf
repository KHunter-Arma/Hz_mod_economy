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

	_this spawn {
	
		_unit = _this select 0;
		_weapon = _this select 1;
		_muzzle = _this select 2;
		_magType = toupper ((_this select 3) select 0);
		_ammoCount = (_this select 3) select 1;
		_oldMagArray = _this select 4;

		if ((_weapon == (primaryWeapon _unit)) || (_weapon == (secondaryWeapon _unit)) || (_weapon == (handgunWeapon _unit))) then {
			
			private _weaponsItems = weaponsItems _unit;
			_unit removeWeapon _weapon;
			
			//best way to handle to avoid any exploits and unfair removal of stuff
			{
			
				if ((_x select 0) == _weapon) exitWith {

					_unit addWeapon (_x select 0);	
					
					//add magazine
					_magArray = _x select 4;
					if ((count _magArray) > 0) then {
						if ((toupper (_magArray select 0)) != _magType) then {
							_unit addWeaponItem [(_x select 0), [(_magArray select 0), (_magArray select 1)],true];
						};
					};
					
					//attachments
					_wep = _x select 0;
					_wepComponents = _wep call BIS_fnc_weaponComponents;
					
					{
					
						if ((_x != "") && {!((tolower _x) in _wepComponents)}) then {
						
							_unit addWeaponItem [_wep, _x,true];
							sleep 0.1;
						
						};
					
					} foreach [_x select 1, _x select 2, _x select 3, _x select 6];
					
					_magArray = _x select 5;
					if ((count _magArray) > 0) then {
						if ((toupper (_magArray select 0)) != _magType) then {
							_unit addWeaponItem [(_x select 0), [(_magArray select 0), (_magArray select 1)],true];
						};
					};
				
				};

			} foreach _weaponsItems;
			
			_wepHolder = objNull;
			
			_countMags = {(toupper _x) == _magType} count (magazines _unit);
			_unit addMagazine [_magType, _ammoCount];
			sleep 0.1;
			_countMagsNow = {(toupper _x) == _magType} count (magazines _unit);
			
			if (_countMags == _countMagsNow) then {
			
				if ((vehicle _unit) == _unit) then {
				
					_wepHolder = "groundWeaponHolder" createVehicle [0,0,0];
					_wepHolder setposatl (getposatl _unit);
					
					hint "You are not trained to use this magazine!\nDropped magazine on ground.";
				
				} else {
				
					_wepHolder = vehicle _unit;
					hint "You are not trained to use this magazine!\nMagazine stored in vehicle.";
				
				};
				
				_wepHolder addMagazineAmmoCargo [_magType,1,_ammoCount];

			} else {
			
				hint "You are not trained to use this magazine!";
			
			};

		};

	};

};