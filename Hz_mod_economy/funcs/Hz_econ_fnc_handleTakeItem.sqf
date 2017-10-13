private _unit = _this select 0;
private _container = _this select 1;
private _itemType = toupper (_this select 2);

//Handle restricted radios differently
if("ACRE_BaseRadio" in ([(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents)) exitWith {
   
	_originalItemType = _itemType;
	 
	//ACRE classname correction
	if ("ACRE_PRC152" in ([(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents) ) then {_itemType = "ACRE_PRC152";} else { 
		if ("ACRE_PRC148" in ([(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents) ) then {_itemType = "ACRE_PRC148";} else {
			if ("ACRE_PRC343" in ([(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents) ) then {_itemType = "ACRE_PRC343";} else {
				if ("ACRE_PRC117F" in ([(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents) ) then {_itemType = "ACRE_PRC117F";} else {
					if ("ACRE_PRC77" in ([(configFile >> "CfgWeapons" >> _itemType), true] call BIS_fnc_returnparents) ) then {_itemType = "ACRE_PRC77";};
					
						};};};};

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

			//could be assigneditem, weaponacc or actual weapon
			default {_itemCategory = "weapon"};

		};
	
	};

} else {

	_parents = [configfile >> "cfgGlasses" >> _itemType, true] call bis_fnc_returnparents;

	if ((count _parents) > 0) then {
	
		_itemCategory = "goggles";
	
	} else {
	
		_parents = [configfile >> "cfgVehicles" >> _itemType, true] call bis_fnc_returnparents;
		
		if ("Bag_Base" in _parents) then {
		
			_itemCategory = "backpack";
		
		};
	
	};

};


switch (true) do {

	case (_itemCategory == "uniform") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			[_unit,_container,uniformContainer _unit,uniformItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
			removeUniform _unit;
			_container addItemCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this uniform!";
		
		};
	
	};
	
	case (_itemCategory == "vest") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			[_unit,_container,vestContainer _unit,vestItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
			removeVest _unit;
			_container addItemCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this vest!";
		
		};
	
	};
	
	case (_itemCategory == "backpack") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			[_unit,_container,backpackContainer _unit,backpackItems _unit] call Hz_econ_fnc_handleTakeRestrictedWearable;
			removeBackpack _unit;
			_container addBackpackCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this backpack!";
		
		};
	
	};
	
	case (_itemCategory == "goggles") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			removeGoggles _unit;
			_container addItemCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this item!";
		
		};
	
	};
	
	case (_itemCategory == "headgear") : {
	
		if (_itemType in Hz_econ_restrictedItems) then {
		
			removeHeadgear _unit;
			_container addItemCargoGlobal [_itemType,1];
			hint "You are not allowed to wear this item!";
		
		};
	
	};
	
	case (_itemCategory == "weapon") : {
	
		//could be assigneditem, weaponacc or actual weapon
		
		switch (true) do {

			case (_baseWeapon in Hz_econ_restrictedWeapons) : {_this call Hz_econ_fnc_handleTakeRestrictedWeapon};
			case (_itemType in Hz_econ_restrictedAttachments) : {_this call Hz_econ_fnc_handleTakeRestrictedAttachment};
			
			//could be assigneditem (but not binoculars -- binoculars must be defined under weapons)
			case (_itemType in Hz_econ_restrictedItems) : {
			
				{
				
					if (_itemType == (toUpper _x)) exitWith {
					
						_unit removeItem _itemType;
						_container addItemCargoGlobal [_itemType,1];
				
						hint "You are not trained to use this item!";
					
					};
				
				} foreach assigneditems _unit;
			
			};
			
			default {
			
				//could be a non-restricted base weapon, but with restricted attachments
				_attachments = _unit weaponAccessories _itemType;
				
				//definitely a weapon with attachments
				if ((str _attachments) != "["""","""","""",""""]") then {
				
					{
						_attachment = toupper _x;
					
						if (_attachment in Hz_econ_restrictedAttachments) then {
						
							[_unit,_container,_attachment] call Hz_econ_fnc_handleTakeRestrictedAttachment;
						
						};
					
					} foreach _attachments;
				
				};
			
			};

		};

	};

	default {};

};