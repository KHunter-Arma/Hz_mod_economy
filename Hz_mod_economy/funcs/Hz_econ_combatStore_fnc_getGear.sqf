/*******************************************************************************
* File: 			Hz_econ_combatStore_fnc_getGear.sqf
*
* Author: 		K.Hunter
*
* ARGUMENTS: 	_this: 							Unit													Type: OBJECT
*
* RETURN: 	_return select 0:		List of weapons								Type: 2D ARRAY		FORMAT: [type, count]
*						_return select 1:		List of weapon attachments		Type: 2D ARRAY		FORMAT: [type, count]
*						_return select 2:		List of items and wearables		Type: 2D ARRAY		FORMAT: [type, count]
*						_return select 3:		List of magazines							Type: 2D ARRAY		FORMAT: [type, count]
*						_return select 4:		Ammo													Type: 2D ARRAY		FORMAT: [type, count]		
********************************************************************************
* Copyright (C) 2017-2018 K.Hunter
*
* This file is licensed under a Creative Commons
* Attribution-NonCommercial-ShareAlike 4.0 International License.
* 
* For more information about this license view the LICENSE.md distributed
* together with this file or visit:
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*******************************************************************************/

private ["_return", "_unit", "_addToArray", "_items", "_weapons", "_magazines", "_ammo", "_attachments", "_addToArray", "_wepFilterBody", "_wep", "_ammoArray", "_mag", "_ammoCount", "_ammoType", "_acc", "_container", "_wepFilter"];

_unit = _this;
_return = [];

_addToArray = {

	private ["_inputType", "_inputArray", "_addCount", "_arrayType", "_arrayCount", "_index"];

	_inputType = _this select 0;
	_inputArray = _this select 1;
	_addCount = 1;
	
	if ((count _this) > 2) then {_addCount = _this select 2;};

	if (_inputType != "") then {
	
		_arrayType = _inputArray select 0;
		_arrayCount = _inputArray select 1;
		_index = _arrayType find _inputType;
		
		if (_index == -1) then {
		
			_arrayType pushback _inputType;
			_arrayCount pushBack _addCount;
		
		} else {
		
		  _arrayCount set [_index, (_arrayCount select _index) + _addCount];
		
		};	
	
	};

};

_items = [[],[]];
_weapons = [[],[]];
_magazines = [[],[]];
_ammo = [[],[]];
_attachments = [[],[]];

{

	[_x, _items] call _addToArray;

} foreach [backpack _unit, vest _unit, uniform _unit, headgear _unit, goggles _unit];

_wepFilterBody = [];

{

	_wep = _x select 0;
	
	if (_wep != "") then {

		_wepFilterBody pushBack _wep;
		_wep = [_wep] call BIS_fnc_baseWeapon;
	
		[_wep, _weapons] call _addToArray;

		{
		
			if (_x != "") then {
			
				[_x, _attachments] call _addToArray;
			
			};
			
		} foreach [_x select 1, _x select 2, _x select 3];
		
		if((typename (_x select 5)) == "ARRAY") then {
		
			//has GL
			_ammoArray = _x select 5;
			
			if ((count _ammoArray) > 0) then {
			
				_mag = _ammoArray select 0;
			
				[_mag, _magazines] call _addToArray;	
				
				if ((getNumber (configfile >> "cfgMagazines" >> _mag >> "count")) > 1) then {
			
					_ammoCount = _ammoArray select 1;
					_ammoType = getText (configfile >> "cfgMagazines" >> _mag >> "ammo");
					[_ammoType, _ammo, _ammoCount] call _addToArray;	
					
				};
			
			};
		
		} else {
		
			_acc = _x select 5;
		
			if (_acc != "") then {
			
				[_acc, _attachments] call _addToArray;
			
			};
		
		};		
		
		_ammoArray = _x select 4;
		
		if ((count _ammoArray) > 0) then {
		
			_mag = _ammoArray select 0;
		
			[_mag, _magazines] call _addToArray;

			if ((getNumber (configfile >> "cfgMagazines" >> _mag >> "count")) > 1) then {
			
				_ammoCount = _ammoArray select 1;
				_ammoType = getText (configfile >> "cfgMagazines" >> _mag >> "ammo");
				[_ammoType, _ammo, _ammoCount] call _addToArray;
					
			};	
			
		};
	
	};

} foreach weaponsitems _unit;

{

	if (!(_x in _wepFilterBody)) then {
	
		[_x, _items] call _addToArray;
		
	};

} foreach assignedItems _unit;

{

	if (!isnull _x) then {

		_container = _x;
		_wepFilter = [];
		
		{

			_wep = _x select 0;
			
			if (_wep != "") then {			
				
				_wepFilter pushBack _wep;
				_wep = [_wep] call BIS_fnc_baseWeapon;				
			
				[_wep, _weapons] call _addToArray;

				{
				
					if (_x != "") then {
					
						[_x, _attachments] call _addToArray;
					
					};
					
				} foreach [_x select 1, _x select 2, _x select 3,_x select 5];
				
				_ammoArray = _x select 4;
				_mag = _ammoArray select 0;
				
				if (_mag != "") then {
				
					[_mag, _magazines] call _addToArray;	
					
					if ((getNumber (configfile >> "cfgMagazines" >> _mag >> "count")) > 1) then {
			
						_ammoCount = _ammoArray select 1;
						_ammoType = getText (configfile >> "cfgMagazines" >> _mag >> "ammo");	

						[_ammoType, _ammo, _ammoCount] call _addToArray;
					
					};						
				
				};
			
			};

		} foreach weaponsitemscargo _container;

		{
		
			if (!(_x in _wepFilter)) then {
			
				if (!("CA_Magazine" in ([(configfile >> "CfgMagazines" >> _x), true] call BIS_fnc_returnParents))) then {
				
					if ((_x call Hz_econ_combatStore_fnc_getAttachmentPrice) != -1) then {
					
						[_x, _attachments] call _addToArray;
					
					} else {
					
						[_x, _items] call _addToArray;
					
					};
				
				};
			
			};
		
		} foreach itemcargo _container;
		
		{

			_mag = _x select 0;
			_ammoCount = _x select 1;
		
			[_mag, _magazines] call _addToArray;		

			if ((getNumber (configfile >> "cfgMagazines" >> _mag >> "count")) > 1) then {
			
				_ammoType = getText (configfile >> "cfgMagazines" >> _mag >> "ammo");
				[_ammoType, _ammo, _ammoCount] call _addToArray;						
			
			};
		
		} foreach magazinesAmmoCargo _container;
	
	};

} foreach [backpackcontainer _unit, vestcontainer _unit, uniformcontainer _unit];

_return = [_weapons,_attachments,_items,_magazines,_ammo];

_return