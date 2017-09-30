waitUntil {sleep 0.1; !isnil "ace_rearm_fnc_rearmSuccessLocal"};
sleep 0.1;
ace_rearm_fnc_rearmSuccessLocal = compile preprocessFileLineNumbers (Hz_econ_aceInterfacePath + "rearm\fnc_rearmSuccessLocal.sqf");  