Hz_econ_aceInterfacePath = Hz_econ_path + "ace_interface\";

_moduleLogic = _this select 0;
Hz_econ_fuelPrice = call compile (_moduleLogic getVariable "FuelPrice");

Hz_econ_fnc_getFuelCapacity = compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "Hz_econ_fnc_getFuelCapacity.sqf");

_this call compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "Hz_econ_aceInterface_initRefuel.sqf");
_this call compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "Hz_econ_aceInterface_initRearm.sqf");
_this call compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "Hz_econ_aceInterface_initRepair.sqf");
