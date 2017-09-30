waitUntil {sleep 0.1; !isnil "ace_refuel_fnc_refuel"};
sleep 0.1;
ace_refuel_fnc_refuel = compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "refuel\fnc_refuel.sqf");  