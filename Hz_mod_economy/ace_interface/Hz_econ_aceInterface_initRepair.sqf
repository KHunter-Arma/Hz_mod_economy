waitUntil {sleep 0.1; !isnil "ace_repair_fnc_doFullRepair"};
sleep 0.1;
ace_repair_fnc_doFullRepair = compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "repair\fnc_doFullRepair.sqf");
waitUntil {sleep 0.1; !isnil "ace_repair_fnc_doRepair"};
sleep 0.1;
ace_repair_fnc_doRepair = compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "repair\fnc_doRepair.sqf");