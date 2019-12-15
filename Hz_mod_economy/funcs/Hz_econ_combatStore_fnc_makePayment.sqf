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

Hz_econ_funds = Hz_econ_funds - _this;
publicVariable "Hz_econ_funds";

if((random 1) > 0.5) then {

	hint format ["Hope you have fun with that!\nTotal Spent: $%1",_this];

} else {

	if((random 1) > 0.5) then {

		hint format["I'd be careful with that if I were you!\nTotal Spent: $%1",_this];

	} else {

		hint format["Come back again!\nTotal Spent: $%1",_this];    

	};       
	
};