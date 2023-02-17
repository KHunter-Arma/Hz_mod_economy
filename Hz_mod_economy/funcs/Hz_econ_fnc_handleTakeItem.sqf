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
private _itemType = toupper (_this select 2);

//Handle restricted radios differently
private _parents = [(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents;

if("ACRE_BaseRadio" in _parents) exitWith {
   
	private _originalItemType = _itemType;
	 
	switch (true) do {
	
		case ("ACRE_PRC343" in _parents) : {
		
			_itemType = "ACRE_PRC343";
		
		};
		
		case ("ACRE_PRC148" in _parents) : {
		
			_itemType = "ACRE_PRC148";
		
		};
		
		case ("ACRE_PRC117F" in _parents) : {
		
			_itemType = "ACRE_PRC117F";
		
		};
		
		case ("ACRE_PRC152" in _parents) : {
		
			_itemType = "ACRE_PRC152";
		
		};
		
		case ("ACRE_PRC77" in _parents) : {
		
			_itemType = "ACRE_PRC77";
		
		};
	
	};

	if (_itemType in Hz_econ_restrictedItems) then {

		_unit removeItem _originalItemType;
		_unit removeItemFromBackpack _originalItemType;
		_unit removeItemFromVest _originalItemType;
		_unit removeItemFromUniform _originalItemType;
		_container addItemCargoGlobal [_originalItemType,1];
		hint "You are not allowed to use this radio!";
		
	};
						
};

private _parents = [configfile >> "cfgWeapons" >> _itemType, true] call bis_fnc_returnparents;
private _itemCategory = "";

private _baseWeapon = "";

if ((count _parents) > 0) then {

	//seems like it's safe to do this with any cfgweapons class
	_baseWeapon = toupper ([_itemType] call bis_fnc_baseweapon);

	if ("ItemCore" in _parents) then {
	
		switch (true) do {

			case ("Uniform_Base" in _parents) : {_itemCategory = "uniform"};
			case (("Vest_Camo_Base" in _parents) || ("Vest_NoCamo_Base" in _parents)) : {_itemCategory = "vest"};
			case ("H_HelmetB" in _parents) : {_itemCategory = "headgear"};

			//could be assigneditem, weaponacc, wearable or actual weapon
			default {_itemCategory = "weapon"};

		};
	
	} else {
	
		_itemCategory = "weapon";
	
	};

} else {

	_parents = [configfile >> "cfgGlasses" >> _itemType, true] call bis_fnc_returnparents;

	if ((count _parents) > 0) then {
	
		_itemCategory = "goggles";
	
	} else {
	
		_parents = [configfile >> "cfgVehicles" >> _itemType, true] call bis_fnc_returnparents;
		
		if ("Bag_Base" in _parents) then {
		
			_itemCategory = "backpack";
		
		} else {
		
			_parents = [configfile >> "cfgMagazines" >> _itemType, true] call bis_fnc_returnparents;
			
			if ((count _parents) > 0) then {
			
				_itemCategory = "magazine";
			
			};
		
		};
	
	};

};


switch (true) do {

	case (_itemCategory == "uniform") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			[_unit,_container,uniformContainer _unit,uniformItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
			removeUniform _unit;
			_container addItemCargoGlobal [_itemType,1];
			{
				if ((toupper (_x select 0)) ==  _itemType) then {
				
					clearItemCargoGlobal (_x select 1); 
				
				};			
			} foreach everyContainer _container;
			
			hint "You are not allowed to wear this uniform!";
		
		};
	
	};
	
	case (_itemCategory == "vest") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			[_unit,_container,vestContainer _unit,vestItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
			removeVest _unit;
			_container addItemCargoGlobal [_itemType,1];
			{
				if ((toupper (_x select 0)) ==  _itemType) then {
				
					clearItemCargoGlobal (_x select 1); 
				
				};			
			} foreach everyContainer _container;						
			
			hint "You are not allowed to wear this vest!";
		
		};
	
	};
	
	case (_itemCategory == "backpack") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			[_unit,_container,backpackContainer _unit,backpackItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
			//some problem with removing backpack... try a delay
			_unit spawn {sleep 1; removeBackpackGlobal _this};			
			_container addBackpackCargoGlobal [_itemType,1];
			{
				if (_x iskindof _itemType) then {
				
					clearItemCargoGlobal _x; 
				
				};			
			} foreach everyBackpack _container;			
			
			hint "You are not allowed to wear this backpack!";
		
		};
	
	};
	
	case (_itemCategory == "goggles") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			if ((toUpper goggles _unit) == _itemType) then {
				removeGoggles _unit;
			} else {
				_unit removeItem _itemType;
			};
			_container addItemCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this item!";
		
		};
	
	};
	
	case (_itemCategory == "headgear") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			if ((toUpper headgear _unit) == _itemType) then {
				removeHeadgear _unit;
			} else {
				_unit removeItem _itemType;
			};
			_container addItemCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this item!";
		
		};
	
	};
	
	case (_itemCategory == "weapon") : {
	
		//could be assigneditem, weaponacc, wearable or actual weapon
		
		switch (true) do {

			case (_baseWeapon in Hz_econ_restrictedWeapons) : {_this call Hz_econ_fnc_handleTakeRestrictedWeapon};
			case (_itemType in Hz_econ_restrictedAttachments) : {_this call Hz_econ_fnc_handleTakeRestrictedAttachment};
			
			//could be assigneditem (but not binoculars -- binoculars must be defined under weapons), or wearable
			case (_itemType in Hz_econ_restrictedItems) : {
						
				private _handled = false;		
						
				{
				
					if (_itemType == (toUpper _x)) exitWith {
					
						_unit removeItem _itemType;
						_container addItemCargoGlobal [_itemType,1];
				
						hint "You are not trained to use this item!";
						
						_handled = true;
					
					};
				
				} foreach assigneditems _unit;				
				
				//iterate through remaining possibilities
				if (!_handled) then {
									
					if (_itemType == (toupper uniform _unit)) exitWith {
		
						[_unit,_container,uniformContainer _unit,uniformItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
						removeUniform _unit;
						_container addItemCargoGlobal [_itemType,1];					
						{
							if ((toupper (_x select 0)) ==  _itemType) then {
							
								clearItemCargoGlobal (_x select 1); 
							
							};			
						} foreach everyContainer _container;
						
						hint "You are not allowed to wear this uniform!";
					
					};
					
					if (_itemType == (toupper vest _unit)) exitWith {
		
						[_unit,_container,vestContainer _unit,vestItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
						removeVest _unit;
						_container addItemCargoGlobal [_itemType,1];
						{
							if ((toupper (_x select 0)) ==  _itemType) then {
							
								clearItemCargoGlobal (_x select 1); 
							
							};			
						} foreach everyContainer _container;
						
						hint "You are not allowed to wear this vest!";
					
					};
					
					if (_itemType == (toupper headgear _unit)) exitWith {
					
						removeHeadgear _unit;
						_container addItemCargoGlobal [_itemType,1];
						hint "You are not allowed to wear this item!";
					
					};
					
					if (_itemType == (toupper goggles _unit)) exitWith {
					
						removeGoggles _unit;
						_container addItemCargoGlobal [_itemType,1];
						hint "You are not allowed to wear this item!";
					
					};
									
				};
			
			};
			
			default {
			
				//could be a non-restricted base weapon, but with restricted attachments
				//does not handle if weapon is put straight into backpack, uniform or vest
				
				private _attachments = _unit weaponAccessories _itemType;
				
				//definitely a weapon with attachments
				if ((str _attachments) != "["""","""","""",""""]") then {
				
					{
						private _attachment = toupper _x;
					
						if (_attachment in Hz_econ_restrictedAttachments) then {
						
							[_unit,_container,_attachment] call Hz_econ_fnc_handleTakeRestrictedAttachment;
						
						};
					
					} foreach _attachments;
				
				};
				
				//what about having a restricted magazine loaded automatically when taking wep out of crate?
				//just remove automatic loading of weapon altogether - more realistic :)
				switch (true) do {
				
					case (_itemType == (toupper (primaryWeapon _unit))) : {
					
						_magArray = [];
						_magsAmmo = magazinesAmmoFull _unit;
						{
						
							_magsAmmo = _magsAmmo - [_x];
							
							if ((_x select 3) == 1) exitWith {
							
								_magArray set [0,_x select 0];
								_magArray set [1,_x select 1];
								_magsAmmo = _magsAmmo - [_x];
							
							};
						
						} foreach _magsAmmo;
						
						if ((count _magArray) == 0) exitWith {};
						
						_unit removePrimaryWeaponItem (_magArray select 0);
						_container addMagazineAmmoCargo [_magArray select 0, 1, _magArray select 1];
						
						//do it again in case of underbarrel
						_magArray = [];
						{
													
							if ((_x select 3) == 1) exitWith {
							
								_magArray set [0,_x select 0];
								_magArray set [1,_x select 1];
							
							};
						
						} foreach _magsAmmo;
						
						if ((count _magArray) == 0) exitWith {};
						
						_unit removePrimaryWeaponItem (_magArray select 0);
						_container addMagazineAmmoCargo [_magArray select 0, 1, _magArray select 1];
						
					
					};
					case (_itemType == (toupper (secondaryWeapon _unit))) : {
					
						_magArray = [];
						{
						
							if ((_x select 3) == 4) then {
							
								_magArray set [0,_x select 0];
								_magArray set [1,_x select 1];
							
							};
						
						} foreach magazinesAmmoFull _unit;
						
						if ((count _magArray) == 0) exitWith {};
						
						_unit removeSecondaryWeaponItem (_magArray select 0);
						_container addMagazineAmmoCargo [_magArray select 0, 1, _magArray select 1];
					
					};
					case (_itemType == (toupper (handgunWeapon _unit))) : {
					
						_magArray = [];
						{
						
							if ((_x select 3) == 2) then {
							
								_magArray set [0,_x select 0];
								_magArray set [1,_x select 1];
							
							};
						
						} foreach magazinesAmmoFull _unit;
						
						if ((count _magArray) == 0) exitWith {};
						
						_unit removeHandgunItem (_magArray select 0);
						_container addMagazineAmmoCargo [_magArray select 0, 1, _magArray select 1];
					
					};
				
				};
			
			};

		};

	};
	
	case (_itemCategory == "magazine") : {
	
		if (_itemType in Hz_econ_restrictedMagazines) then {
		
			//don't restrict actual magazines unless they're about to be used (handled by reload EH)
			//only restrict other items like throwables and explosives because they're always locked and loaded
		
			if ((_itemType in Hz_econ_allThrowableMags) || (_itemType in Hz_econ_allPutableMags)) then {
			
				_unit removeItem _itemType;
				_unit removeItemFromBackpack _itemType;
				_unit removeItemFromVest _itemType;
				_unit removeItemFromUniform _itemType;
				_container addItemCargoGlobal [_itemType,1];
				hint "You are not allowed to use this item!";				
			
			};
		
		};
		
	};

	default {};

};