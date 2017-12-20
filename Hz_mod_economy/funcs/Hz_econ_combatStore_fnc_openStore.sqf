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

if (Hz_econ_funds <= 0) exitwith {hint "Insufficient funds!";};

[] spawn {

  call Hz_pers_API_disablePlayerSaveStateOnDisconnect;

	_gearBegin = player call Hz_econ_combatStore_fnc_getGear;
  
  Hz_econ_combatStore_gearAtStoreEntry = _gearBegin;

	waituntil {dialog};
	waituntil {sleep 0.1; !dialog};
	sleep 1;

	//revert not implemented
	Hz_econ_combatStore_checkout = true;

	if (Hz_econ_combatStore_checkout) then {

		//purchase
		_gearEnd = player call Hz_econ_combatStore_fnc_getGear;
		
		_newGear = [_gearEnd, _gearBegin] call Hz_econ_combatStore_fnc_getGearDifference;
		
    _cost = _newGear call Hz_econ_combatStore_fnc_getCheckoutCost;
    
		if (_cost > 0) then {
		
			_cost call Hz_econ_combatStore_fnc_makePayment;
			
			[_cost,_newGear] call Hz_econ_combatStore_customExitFnc;
			
		};

	} else {

		//revert

	};

  call Hz_pers_API_enablePlayerSaveStateOnDisconnect;
  
};

Hz_econ_combatStore_checkout = false;
_this call (uinamespace getVariable "bis_fnc_arsenal_UI");
