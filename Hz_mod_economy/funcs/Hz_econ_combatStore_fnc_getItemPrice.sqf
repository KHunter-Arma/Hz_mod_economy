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

// sometimes returns undefined for unknown reasons -- this is a safeguard

if (isnil "Hz_econ_combatStore_customItemPrice") then {

	-1

} else {

	_this call Hz_econ_combatStore_customItemPrice

}