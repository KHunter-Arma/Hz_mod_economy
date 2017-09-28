#define A_TYPE 0
#define A_COUNT 1

_totalCost = 0;
_weaponsArray = _this select 0;
_attachmentsArray = _this select 1;
_itemsArray = _this select 2;
_magazinesArray = _this select 3;
_ammoArray = _this select 4;

{

_cost = _x call Hz_econ_combatStore_fnc_getWeaponPrice;
_cost = _cost*((_weaponsArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_weaponsArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getAttachmentPrice;
_cost = _cost*((_attachmentsArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_attachmentsArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getItemPrice;
_cost = _cost*((_itemsArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_itemsArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getMagazinePrice;
_cost = _cost*((_magazinesArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_magazinesArray select A_TYPE);

{

_cost = _x call Hz_econ_combatStore_fnc_getAmmoPrice;
_cost = _cost*((_ammoArray select A_COUNT) select _foreachIndex);

_totalCost = _totalCost + _cost;

} foreach (_ammoArray select A_TYPE);


_totalCost