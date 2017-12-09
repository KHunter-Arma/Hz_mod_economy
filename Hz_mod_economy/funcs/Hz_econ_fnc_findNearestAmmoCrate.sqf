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

private ["_unit", "_types", "_objects", "_return"];

_unit = _this select 0;
_types = _this select 1;

_objects = nearestobjects [_unit,_types,30];
_return = objNull;


if(count _objects > 0) then {_return = _objects select 0;};

_return