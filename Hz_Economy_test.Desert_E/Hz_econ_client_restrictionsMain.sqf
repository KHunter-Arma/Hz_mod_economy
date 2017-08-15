/*******************************************************************************
* Copyright (C) Hunter'z Economy Module
*
* This file is licensed under a Creative Commons
* Attribution-NonCommercial-ShareAlike 4.0 International License.
* 
* For more information about this license view the LICENSE.md distributed
* together with this file or visit:
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*******************************************************************************/

while {true} do {
    
    while {alive player} do {
  
        sleep 5;
				
				_allgear = player call Hz_econ_combatStore_fnc_getGear;
        _allWeps = (_allgear select 0) select 0;
				_allAttachments = (_allgear select 1) select 0;
				_allItems = (_allgear select 2) select 0;
				_allMags = (_allgear select 3) select 0;
				
        _spitItems = [];
  
        {
            _item = _x;
    
            if ((toupper _item) in Hz_econ_restrictedWeapons) then {_spitItems set [count _spitItems, _x];};
            sleep 0.01;
						
        }foreach _allWeps;
				
				{
            _item = _x;
    
            if ((toupper _item) in Hz_econ_restrictedAttachments) then {_spitItems set [count _spitItems, _x];};
            sleep 0.01;
						
        }foreach _allAttachments;
				
				{
            _item = _x;
    
            if ((toupper _item) in Hz_econ_restrictedMagazines) then {_spitItems set [count _spitItems, _x];};
            sleep 0.01;
						
        }foreach _allMags;
				
				{
            _item = _x;
      
            if("ACRE_BaseRadio" in ([(configFile >> "CfgWeapons" >> _item), true] call BIS_fnc_returnparents)) then {
      
                //ACRE classname correction
                if ("ACRE_PRC152" in ([(configFile >> "CfgWeapons" >> _item), true] call BIS_fnc_returnparents) ) then {_item = "ACRE_PRC152";} else { 
                    if ("ACRE_PRC148" in ([(configFile >> "CfgWeapons" >> _item), true] call BIS_fnc_returnparents) ) then {_item = "ACRE_PRC148";} else {
                        if ("ACRE_PRC343" in ([(configFile >> "CfgWeapons" >> _item), true] call BIS_fnc_returnparents) ) then {_item = "ACRE_PRC343";} else {
                            if ("ACRE_PRC117F" in ([(configFile >> "CfgWeapons" >> _item), true] call BIS_fnc_returnparents) ) then {_item = "ACRE_PRC117F";} else {
                                if ("ACRE_PRC77" in ([(configFile >> "CfgWeapons" >> _item), true] call BIS_fnc_returnparents) ) then {_item = "ACRE_PRC77";};
      
            };};};};};
      
            if ((toupper _item) in Hz_econ_restrictedItems) then {_spitItems set [count _spitItems, _x];};
            sleep 0.01;
						
        }foreach _allItems;

        if ((count _spitItems) > 0) then {_spitItems call Hz_econ_fnc_spitOutItems;};
   
        if ((vehicle player)!= player) then {[] spawn Hz_econ_fnc_checkVehicle;};  
   
    };         
                
    sleep 10;   

};