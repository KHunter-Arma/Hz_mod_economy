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
private _vehicle = _this select 2;

if ((toupper typeof _vehicle) in Hz_econ_restrictedVehicles) then {

	if ((_unit == (driver _vehicle)) || (_unit == (gunner _vehicle)) || (_unit == (commander _vehicle))) then {

		hint "You are not trained to use this vehicle!";
		moveout _unit;
		
		[_unit,_vehicle] spawn {
		
			sleep 0.1;
			(_this select 0) moveInCargo (_this select 1);
		
		};

	};

};