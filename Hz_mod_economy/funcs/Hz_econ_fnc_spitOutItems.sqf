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

private ["_spitItems","_wepholder"];

_spitItems = _this;

_wepholder = objNull;

if((vehicle player) != player) then {

    _wepholder = vehicle player;
    
    hint "You are not allowed to carry this item!\nItem is now stored in vehicle";
    
    
} else {
    	
    _nearcrates = nearestObjects [player,["ReammoBox"],10];        
        
     if((count _nearcrates) > 0) then {
         
      _wepholder = _nearcrates select 0;
      hint "You are not allowed to carry this item!\nItem is now stored in nearest ammo crate";
     
     } else {   
            
    _wepholder = "itemHolder" createvehicle (position player);
    hint "You are not allowed to carry this item!\nItem dropped on ground";
    
    };

};

{
		 if(_x == (toupper (headgear player))) then {
			removeHeadgear player;		 
		 } else {
		 if(_x == (toupper (goggles player))) then {
			removeGoggles player;		 
		 } else {
			
			player removeWeapon _x;
			player unassignItem _x;
			player removeItem _x;	
		 
		 };};
		 
     _wepholder additemcargoglobal [_x, 1];
				
     
}foreach _spitItems;