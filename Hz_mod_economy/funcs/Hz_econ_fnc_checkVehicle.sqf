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

private ["_veh","_type"];

_veh = vehicle player;
_type = toupper (typeof _veh);

if (_type in Hz_restricted_vehs) then {
    
 if((player == (gunner _veh)) || (player == (commander _veh)) || (player == (driver _veh))) then {
 
 hint "You are not trained to use this vehicle!";
 moveout player;
 sleep 0.1;
 player moveincargo _veh;
     
 };               
                
};