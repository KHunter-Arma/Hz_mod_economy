/*
	Author: Karel Moricky

	Modified by K.Hunter to form basis of stores in Hunter'z Economy Module.
	
*/

if (is3DEN && {_fnc_scriptName == "bis_fnc_garage"}) exitwith {_this call compile preprocessfilelinenumbers (Hz_econ_funcsPath + "bis_fnc_garage3DEN.sqf");};

#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"

#define FADE_DELAY	0.15

disableserialization;

_mode = [_this,0,"Open",[displaynull,""]] call bis_fnc_param;
_this = [_this,1,[]] call bis_fnc_param;
_fullVersion = missionnamespace getvariable ["BIS_fnc_arsenal_fullGarage",false];

#ifdef FNC_IS3DEN
	//--- Rewrite left side IDCs to 3DEN specific ones
	#define IDC_RSCDISPLAYGARAGE_TAB_CAR		-1
	#define IDC_RSCDISPLAYGARAGE_TAB_ARMOR		-1
	#define IDC_RSCDISPLAYGARAGE_TAB_HELI		-1
	#define IDC_RSCDISPLAYGARAGE_TAB_PLANE		-1
	#define IDC_RSCDISPLAYGARAGE_TAB_NAVAL		-1
	#define IDC_RSCDISPLAYGARAGE_TAB_STATIC		-1

	#define IDC_RSCDISPLAYGARAGE_TAB_SUBCREW	-1
	#define IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION	IDC_RSCDISPLAYGARAGE3DEN_TAB_SUBANIMATION
	#define IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE	IDC_RSCDISPLAYGARAGE3DEN_TAB_SUBTEXTURE

	#define IDCS_LEFT\
		IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION,\
		IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE

	#define IDCS_RIGHT	
	#define INITTYPES

	#define IDCS	[IDCS_LEFT]
#else
	#define IDCS_LEFT\
		IDC_RSCDISPLAYGARAGE_TAB_CAR,\
		IDC_RSCDISPLAYGARAGE_TAB_ARMOR,\
		IDC_RSCDISPLAYGARAGE_TAB_HELI,\
		IDC_RSCDISPLAYGARAGE_TAB_PLANE,\
		IDC_RSCDISPLAYGARAGE_TAB_NAVAL,\
		IDC_RSCDISPLAYGARAGE_TAB_STATIC

	#define IDCS_RIGHT\
		IDC_RSCDISPLAYGARAGE_TAB_SUBCREW,\
		IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION,\
		IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE

	#define INITTYPES\
			_types = [];\
			_types set [IDC_RSCDISPLAYGARAGE_TAB_CAR,["carx"]];\
			_types set [IDC_RSCDISPLAYGARAGE_TAB_ARMOR,["tankx"]];\
			_types set [IDC_RSCDISPLAYGARAGE_TAB_HELI,["helicopterx"]];\
			_types set [IDC_RSCDISPLAYGARAGE_TAB_PLANE,["airplanex"]];\
			_types set [IDC_RSCDISPLAYGARAGE_TAB_NAVAL,["shipx","sumbarinex"]];\
			_types set [IDC_RSCDISPLAYGARAGE_TAB_STATIC,[""]];

	#define IDCS	[IDCS_LEFT,IDCS_RIGHT]
#endif


#define STATS\
	["maxspeed","armor","fuelcapacity","threat"],\
	[false,true,false,false]


#define CONDITION(LIST)	(_fullVersion || {"%ALL" in LIST} || {{_item == _x} count LIST > 0})
#define ERROR if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};

switch _mode do {

	///////////////////////////////////////////////////////////////////////////////////////////
	case "Open": {
		if !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])) exitwith {"Garage Viewer is already running" call bis_fnc_logFormat;};
		missionnamespace setvariable ["BIS_fnc_arsenal_fullGarage",[_this,0,false,[false]] call bis_fnc_param];

		with missionnamespace do {
			BIS_fnc_garage_center = [_this,1,missionnamespace getvariable ["BIS_fnc_garage_center",player],[objnull]] call bis_fnc_param;
		};
		with uinamespace do {
			_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
			_displayClass = "RscDisplayGarage_Hz";
			if !(isnull finddisplay 312) then {_displayMission = finddisplay 312;};
			if (is3DEN) then {_displayMission = finddisplay 313; _displayClass = "RscDisplayGarage3DEN_Hz";};
			_displayMission createdisplay _displayClass;
		};
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "Init": {
		["BIS_fnc_arsenal"] call bis_fnc_startloadingscreen;
		_display = _this select 0;
		_toggleSpace = uinamespace getvariable ["BIS_fnc_arsenal_toggleSpace",false];
		BIS_fnc_arsenal_type = 1; //--- 0 - Arsenal, 1 - Garage
		BIS_fnc_arsenal_toggleSpace = nil;
		BIS_fnc_garage_turretPaths = [];
		if (isnil "BIS_fnc_garage_centerType") then {BIS_fnc_garage_centerType = "";};
		setstatvalue ["MarkVirtualVehicleInspection",1];

		with missionnamespace do {
			BIS_fnc_arsenal_group = creategroup side group player;
			BIS_fnc_arsenal_center = missionnamespace getvariable ["BIS_fnc_garage_center",player];
		};

		//--- Show specific class
		_classDefault = uinamespace getvariable ["bis_fnc_garage_defaultClass",""];
		if (isclass (configfile >> "cfgvehicles" >> _classDefault)) then {
			bis_fnc_garage_centerType = gettext (configfile >> "cfgvehicles" >> _classDefault >> "model");
		};
		uinamespace setvariable ["bis_fnc_garage_defaultClass",nil];

		//--- Load stats
		if (isnil {uinamespace getvariable "BIS_fnc_garage_stats"}) then {
			_defaultCrew = gettext (configfile >> "cfgvehicles" >> "all" >> "crew");
			uinamespace setvariable [
				"BIS_fnc_garage_stats",
				[
					//("isclass _x && getnumber (_x >> 'scope') == 2") configclasses (configfile >> "cfgvehicles"),
					("isclass _x && {getnumber (_x >> 'scope') == 2} && {gettext (_x >> 'crew') != _defaultCrew}" configclasses (configfile >> "cfgvehicles")),
					STATS
				] call bis_fnc_configExtremes
			];
		};

		INITTYPES
		["InitGUI",[_display,"bis_fnc_garage_UI"]] call (uinamespace getvariable "bis_fnc_arsenal_UI");
		["Preload"] call (uinamespace getvariable "bis_fnc_garage_UI");
		["ListAdd",[_display]] call (uinamespace getvariable "bis_fnc_garage_UI");
		//["ListSelectCurrent",[_display]] call BIS_fnc_garage;
		if (BIS_fnc_garage_centerType == "") then {["buttonRandom",[_display]] call (uinamespace getvariable "bis_fnc_garage_UI");};
		["MouseZChanged",[controlnull,0]] call (uinamespace getvariable "bis_fnc_arsenal_UI"); //--- Reset zoom
		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlsetfade 0;
		} foreach [IDC_RSCDISPLAYARSENAL_LINETABLEFT];

		_ctrl = _display displayctrl IDC_RSCDISPLAYARSENAL_LINEICON;
		_ctrl ctrlshow false;

		with missionnamespace do {
			[missionnamespace,"garageOpened",[_display,_toggleSpace]] call bis_fnc_callscriptedeventhandler;
		};
		["BIS_fnc_arsenal"] call bis_fnc_endloadingscreen;
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "Exit": {
		with missionnamespace do {
			BIS_fnc_garage_center = BIS_fnc_arsenal_center;
/*
			{
				BIS_fnc_arsenal_center deletevehiclecrew _x;
			} foreach crew BIS_fnc_arsenal_center;
			deletevehicle BIS_fnc_arsenal_center;
			BIS_fnc_arsenal_group = nil;
*/
		};
		BIS_fnc_garage_turretPaths = nil;
    
		with missionnamespace do {
			[missionnamespace,"garageClosed",[displaynull,uinamespace getvariable ["BIS_fnc_arsenal_toggleSpace",false]]] call bis_fnc_callscriptedeventhandler;
		};
		"Exit" call (uinamespace getvariable "bis_fnc_arsenal_UI");
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "Preload": {
		if (is3DEN) then {

			//--- 3DEN specific, load only animations and textures
			["bis_fnc_garage_preload"] call bis_fnc_startloadingscreen;
			private ["_data"];
			_data = [];
			_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
			_centerFaction = faction _center;
			{
				_items = [];
				{
					_configName = configname _x;
					_displayName = gettext (_x >> "displayName");
					_factions = getarray (_x >> "factions");
					if (count _factions == 0) then {_factions = [_centerFaction];};
					if (
						_displayName != ""
						&&
						{getnumber (_x >> "scope") > 1 || !isnumber (_x >> "scope")}
						&&
						{{_x == _centerFaction} count _factions > 0}
					) then {
						_items pushback [_x,_displayName];
					};
				} foreach (configproperties [_x,"isclass _x",true]);
				_data pushback _items;
			} foreach [
				configfile >> "cfgvehicles" >> typeof _center >> "animationSources",
				configfile >> "cfgvehicles" >> typeof _center >> "textureSources"
			];

			missionnamespace setvariable ["bis_fnc_garage_data",_data];
			["bis_fnc_garage_preload"] call bis_fnc_endloadingscreen;
			BIS_fnc_garage_centerType = typeof _center;
			true
		} else {

			//--- Non-3DEN, laod vehicle types sorted by category
			if (isnil "_data" || cheatsenabled) then {
				["bis_fnc_garage_preload"] call bis_fnc_startloadingscreen;

				_data = [];
				{
					_data set [_x,[]];
				} foreach [IDCS_LEFT];
				_defaultCrew = gettext (configfile >> "cfgvehicles" >> "all" >> "crew");

				{
					_simulation = gettext (_x >> "simulation");
					_items = switch tolower _simulation do {
						case "car";
						case "carx": {
							_data select IDC_RSCDISPLAYGARAGE_TAB_CAR;
						};
						case "tank";
						case "tankx": {
							if (getnumber (_x >> "maxspeed") > 0) then {
								_data select IDC_RSCDISPLAYGARAGE_TAB_ARMOR;
							} else {
								_data select IDC_RSCDISPLAYGARAGE_TAB_STATIC;
							};
						};
						case "helicopter";
						case "helicopterx";
						case "helicopterrtd": {
							_data select IDC_RSCDISPLAYGARAGE_TAB_HELI;
						};
						case "airplane";
						case "airplanex": {
							_data select IDC_RSCDISPLAYGARAGE_TAB_PLANE;
						};
						case "ship";
						case "shipx";
						case "submarinex": {
							_data select IDC_RSCDISPLAYGARAGE_TAB_NAVAL;
						};
						default {[]};
					};

					//--- Sort vehicles by model (vehicles with the same model are displayed as one, with variable textures / animations)
					_model = tolower gettext (_x >> "model");
					if (getnumber (_x >> "forceInGarage") > 0) then {_model = _model + ":" + configname _x;}; //--- Force specific class
					_modelID = _items find _model;
					if (_modelID < 0) then {
						_modelID = count _items;
						_items pushback _model;
						_items pushback [];
					};
					_modelData = _items select (_modelID + 1);
					_modelData pushback _x;

				} foreach ("isclass _x && {getnumber (_x >> 'scope') == 2} && {gettext (_x >> 'crew') != _defaultCrew}" configclasses (configfile >> "cfgvehicles"));

				missionnamespace setvariable ["bis_fnc_garage_data",_data];
				["bis_fnc_garage_preload"] call bis_fnc_endloadingscreen;
				true
			} else {
				false
			};
		};
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "ListAdd": {
		_display = _this select 0;
		_data = missionnamespace getvariable "bis_fnc_garage_data";
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_checkboxTextures = [
			tolower gettext (configfile >> "RscCheckBox" >> "textureUnchecked"),
			tolower gettext (configfile >> "RscCheckBox" >> "textureChecked")
		];
		if (is3DEN) then {
			_centerTextures = getobjecttextures _center;
			_ctrlList = controlnull; //--- Used by ShowItemInfo
			_cursel = -1; //--- Used by ShowItemInfo
			{
				_items = _x;
				_idc = _foreachindex;
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _foreachindex);
				{
					_configName = configname (_x select 0);
					_displayName = _x select 1;
					
					_configNameUpper = toupper _configName;
					
					if((_configNameUpper call Hz_econ_vehStore_fnc_getVehCost) != -1) then {
					
						_exit = false;
						with missionnamespace do {
						
						if (Hz_econ_enableRestrictions) then {
						
							if(_configNameUpper in Hz_econ_restrictedVehicles) then {_exit = true;};
						
						};
						
						};
						if(_exit) exitwith {};
					
					_lbAdd = _ctrlList lbadd _displayName;
					_ctrlList lbsetdata [_lbAdd,_configName];
					_ctrlList lbsettooltip [_lbAdd,_displayName];
					  //if(((toupper configname _modelExample) call Hz_econ_vehStore_fnc_getVehCost) == -1) then {_ctrlList lbSetColor [_lbAdd, [1, 0, 0, 0.6]];};
                      
					if (_idc == 0) then {
						_ctrlList lbsetpicture [_lbAdd,_checkboxTextures select ((_center animationphase _configName) max 0)];
					} else {
						_configTextures = getarray (configfile >> "cfgvehicles" >> typeof _center >> "texturesources" >> _configName >> "textures");
						_selected = true;
						if (count _configTextures == count _centerTextures) then {
							{if (tolower _x find (_centerTextures select _foreachindex) < 0) exitwith {_selected = false;};} foreach _configTextures;
						} else {
							_selected = false;
						};
						_ctrlList lbsetpicture [_lbAdd,_checkboxTextures select _selected];
					};
					
					};
					
				} foreach _items;

				_ctrlListDisabled = _display displayctrl (IDC_RSCDISPLAYARSENAL_LISTDISABLED + _foreachindex);
				_ctrlListDisabled ctrlshow (lbsize _ctrlList == 0);
			} foreach _data;

			_cfg = configfile >> "cfgvehicles" >> typeof _center;
			["ShowItemInfo",[_cfg,gettext (_cfg >> "displayName")]] call (uinamespace getvariable "bis_fnc_arsenal_UI");
			["ShowItemStats",[_cfg]] call (uinamespace getvariable "bis_fnc_garage_UI");
		} else {
			{
				_items = _x;
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _foreachindex);
				for "_i" from 0 to (count _items - 1) step 2 do {
					_model = _items select _i;
					_modelData = _items select (_i + 1);
					_modelExample = _modelData select 0;
					_displayName = gettext (_modelExample >> "displayName");
					
					if(((toupper configname _modelExample) call Hz_econ_vehStore_fnc_getVehCost) != -1) then {
					
					_lbAdd = _ctrlList lbadd _displayName;
					_ctrlList lbsetpicture [_lbAdd,gettext (_modelExample >> "picture")];
					_ctrlList lbsetdata [_lbAdd,_model];
					_ctrlList lbsetvalue [_lbAdd,_i];
					_ctrlList lbsettooltip [_lbAdd,_displayName];
					
					//if(((toupper configname _modelExample) call Hz_econ_vehStore_fnc_getVehCost) == -1) then {_ctrlList lbSetColor [_lbAdd, [1, 0, 0, 0.6]];};
					if (_fullVersion) then {
					
						_addons = configsourceaddonlist _modelExample;
						if (count _addons > 0) then {
							_dlcs = configsourcemodlist (configfile >> "CfgPatches" >> _addons select 0);
							if (count _dlcs > 0) then {
								_ctrlList lbsetpictureright [_lbAdd,gettext (configfile >> "cfgMods" >> (_dlcs select 0) >> "logo")];
							};
						};
						//_ctrlList lbsetpictureright [_lbAdd,gettext ((configfile >> "cfgMods" >> gettext (_modelExample >> "dlc")) >> "logo")];
					};
					
					};
					
				};
				lbsort _ctrlList;

				//--- Select previously selected item (must be done after sorting)
				for "_i" from 0 to (lbsize _ctrlList - 1) do {
					if ((_ctrlList lbdata _i) == bis_fnc_garage_centerType) then {
						_ctrlList lbsetcursel _i;
					};
				} foreach _data;
			} foreach _data;
		};
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "TabSelectLeft": {
		_display = _this select 0;
		_index = _this select 1;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
/*
		{
			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
			_ctrlList lbsetcursel -1;
			lbclear _ctrlList;
		} foreach [IDCS_RIGHT];
*/
		{
			_idc = _x;
			_active = _idc == _index;

			{
				_ctrlList = _display displayctrl (_x + _idc);
				_ctrlList ctrlenable _active;
				_ctrlList ctrlsetfade ([1,0] select _active);
				_ctrlList ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED];

			_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_ctrlTab ctrlenable !_active;

			_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc);
			if (_active) then {
				_ctrlLineTabLeft = _display displayctrl IDC_RSCDISPLAYARSENAL_LINETABLEFT;
				_ctrlLineTabLeft ctrlsetfade 0;
				_ctrlTabPos = ctrlposition _ctrlTab;
				_ctrlLineTabPosX = (_ctrlTabPos select 0) + (_ctrlTabPos select 2) - 0.01;
				_ctrlLineTabPosY = (_ctrlTabPos select 1);
				_ctrlLineTabLeft ctrlsetposition [
					safezoneX,//_ctrlLineTabPosX,
					_ctrlLineTabPosY,
					(ctrlposition _ctrlList select 0) - safezoneX,//_ctrlLineTabPosX,
					ctrlposition _ctrlTab select 3
				];
				_ctrlLineTabLeft ctrlcommit 0;
				ctrlsetfocus _ctrlList;
				['SelectItem',[_display,_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc),_idc]] call (uinamespace getvariable "bis_fnc_garage_UI");
			} else {
				if ((_center getvariable "bis_fnc_arsenal_idc") != _idc) then {_ctrlList lbsetcursel -1;};
			};

			_ctrlIcon = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICON + _idc);
			//_ctrlIcon ctrlsetfade ([1,0] select _active);
			_ctrlIcon ctrlshow _active;
			_ctrlIcon ctrlenable !_active;
		} foreach [IDCS_LEFT];

		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlsetfade 0;
			_ctrl ctrlcommit FADE_DELAY;
		} foreach [
			//IDC_RSCDISPLAYARSENAL_LINETABLEFT,
			IDC_RSCDISPLAYARSENAL_FRAMELEFT,
			IDC_RSCDISPLAYARSENAL_BACKGROUNDLEFT
		];

		//--- Right lists
		{
			_idc = _x;
			_ctrl = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _x);
			_ctrl ctrlenable true;
			_ctrl ctrlsetfade 0;
			_ctrl ctrlcommit 0;//FADE_DELAY;
			{
				_ctrlList = _display displayctrl (_idc + _x);
				_ctrlList ctrlenable true;
				_ctrlList ctrlsetfade 0;
				_ctrlList ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED];
		} foreach [IDCS_RIGHT];

		//--- Right sidebar
		if !(is3DEN) then {
			{
				_ctrl = _display displayctrl _x;
				_ctrl ctrlsetfade 0;
				_ctrl ctrlcommit FADE_DELAY;
			} foreach [
				IDC_RSCDISPLAYARSENAL_LINETABRIGHT,
				IDC_RSCDISPLAYARSENAL_FRAMERIGHT,
				IDC_RSCDISPLAYARSENAL_BACKGROUNDRIGHT
			];
		};

		['TabSelectRight',[_display,IDC_RSCDISPLAYGARAGE_TAB_SUBCREW]] call (uinamespace getvariable "bis_fnc_garage_UI");
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "TabSelectRight": {
		_display = _this select 0;
		_index = _this select 1;
		_ctrFrameRight = _display displayctrl IDC_RSCDISPLAYARSENAL_FRAMERIGHT;
		_ctrBackgroundRight = _display displayctrl IDC_RSCDISPLAYARSENAL_BACKGROUNDRIGHT;

		{
			_idc = _x;
			_active = _idc == _index;

			{
				_ctrlList = _display displayctrl (_x + _idc);
				_ctrlList ctrlenable _active;
				_ctrlList ctrlsetfade ([1,0] select _active);
				_ctrlList ctrlcommit FADE_DELAY;
			} foreach [IDC_RSCDISPLAYARSENAL_LIST,IDC_RSCDISPLAYARSENAL_LISTDISABLED];

			_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
			_ctrlTab ctrlenable (!_active && ctrlfade _ctrlTab == 0);

			if (_active) then {
				_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _idc);
				_ctrlLineTabRight = _display displayctrl IDC_RSCDISPLAYARSENAL_LINETABRIGHT;
				_ctrlLineTabRight ctrlsetfade 0;
				_ctrlTabPos = ctrlposition _ctrlTab;
				_ctrlLineTabPosX = (ctrlposition _ctrlList select 0) + (ctrlposition _ctrlList select 2);
				_ctrlLineTabPosY = (_ctrlTabPos select 1);
				_ctrlLineTabRight ctrlsetposition [
					_ctrlLineTabPosX,
					_ctrlLineTabPosY,
					safezoneX + safezoneW - _ctrlLineTabPosX,//(_ctrlTabPos select 0) - _ctrlLineTabPosX + 0.01,
					ctrlposition _ctrlTab select 3
				];
				_ctrlLineTabRight ctrlcommit 0;
				ctrlsetfocus _ctrlList;

				_ctrlLoadCargo = _display displayctrl IDC_RSCDISPLAYARSENAL_LOADCARGO;
				_ctrlListPos = ctrlposition _ctrlList;
				_ctrlListPos set [3,(_ctrlListPos select 3) + (ctrlposition _ctrlLoadCargo select 3)];
				{
					_x ctrlsetposition _ctrlListPos;
					_x ctrlcommit 0;
				} foreach [_ctrFrameRight,_ctrBackgroundRight];

				if (_idc in [IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC]) then {
					["SelectItemRight",[_display,_ctrlList,_index]] call (uinamespace getvariable "bis_fnc_arsenal_UI");
				};
			};

			_ctrlIcon = _display displayctrl (IDC_RSCDISPLAYARSENAL_ICON + _idc);
			//_ctrlIcon ctrlenable false;
			_ctrlIcon ctrlshow _active;
			_ctrlIcon ctrlenable (!_active && ctrlfade _ctrlTab == 0);
		} foreach [IDCS_RIGHT];
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "SelectItem": {
		private ["_ctrlList","_index","_cursel"];
		_display = _this select 0;
		_ctrlList = _this select 1;
		_idc = _this select 2;
		_cursel = lbcursel _ctrlList;
		if (_cursel < 0) exitwith {};
		_index = _ctrlList lbvalue _cursel;

		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_group = (missionnamespace getvariable ["BIS_fnc_arsenal_group",group player]);
		_cfg = configfile >> "dummy";
		//_cfg = configfile >> "cfgvehicles" >> typeof _center;
		_cfgStats = _cfg;
		_checkboxTextures = [
			tolower gettext (configfile >> "RscCheckBox" >> "textureUnchecked"),
			tolower gettext (configfile >> "RscCheckBox" >> "textureChecked")
		];
		_colors = [[1,1,1,1],[1,1,1,0.25]];
		_initVehicle = false;

		switch _idc do {
			case IDC_RSCDISPLAYGARAGE_TAB_CAR;
			case IDC_RSCDISPLAYGARAGE_TAB_ARMOR;
			case IDC_RSCDISPLAYGARAGE_TAB_HELI;
			case IDC_RSCDISPLAYGARAGE_TAB_PLANE;
			case IDC_RSCDISPLAYGARAGE_TAB_NAVAL;
			case IDC_RSCDISPLAYGARAGE_TAB_STATIC: {
				_item = if (ctrltype _ctrlList == 102) then {_ctrlList lnbdata [_cursel,0]} else {_ctrlList lbdata _cursel};
				_target = (missionnamespace getvariable ["BIS_fnc_arsenal_target",player]);
				_centerType = if !(simulationenabled _center) then {""} else {typeof _center}; //--- Accept only previous vehicle, not player during init
				_centerSizeOld = ((boundingboxreal _center select 0) vectordistance (boundingboxreal _center select 1));//sizeof _centerType;
				_data = missionnamespace getvariable "bis_fnc_garage_data";
				_modelData = (_data select _idc) select (_index + 1);
				_cfg = _modelData select 0;
				_cfgStats = _cfg;
				_class = configname _cfg;

				if (_class != _centerType || !alive _center) then {
					_centerPos = position _center;
					_centerPos set [2,0];
					_players = [];
					_crew = [];
					{
						_member = _x select 0;
						_role = _x select 1;
						_index = if (_role == "turret") then {_x select 3} else {_x select 2};
						_crew pushback [typeof _member,_role,_index];
					} foreach fullcrew _center;
					{
						if (isplayer _x) then {
							_players pushback [_x,assignedvehiclerole _x];
							moveout _x;
						} else {
							_center deletevehiclecrew _x;
						};
					} foreach crew _center;
					if (getnumber (configfile >> "cfgvehicles" >> typeof _center >> "isUAV") > 0) then {_crew = [];}; //--- Don't restore UAV crew

					if (_center != player) then {_center setpos [10,10,00];};
					deletevehicle _center;
					_center = _class createvehiclelocal _centerPos;
                                        missionnamespace setvariable ["Hz_econ_vehStore_vehicle",_center];          
					_center setpos _centerPos;
					if ((_center getvariable ["bis_fnc_arsenal_idc",-1]) >= 0) then {_center setpos _centerPos;}; //--- Move vehicle only when previous vehicle was created by Garage
					_center allowdamage false;
					_center setvelocity [0,0,0];
					_center setvariable ["bis_fnc_arsenal_idc",_idc];
					if (_fullVersion) then {_center setvehicletipars [0.5,0.5,0.5];}; //--- Heat vehicle parts so user can preview them
					bis_fnc_garage_centerType = _item;
					missionnamespace setvariable ["BIS_fnc_arsenal_center",_center];
					//_target attachto [_center,BIS_fnc_arsenal_campos select 3,""];

					//--- Restore player seats
					{
						_player = _x select 0;
						_roleArray = _x select 1;
						_role = _roleArray select 0;
						switch (tolower _role) do {
							case "driver": {
								if (_center emptypositions _role > 0) then {_player moveindriver _center;} else {_player moveinany _center;};
							};
							case "gunner";
							case "commander";
							case "turret": {
								if (count (allturrets _center) > 0) then {_player moveinturret [_center,(allturrets _center) select 0];} else {_player moveinany _center;};
							};
							case "cargo": {
								if (_center emptypositions _role > 0) then {_player moveincargo _center;} else {_player moveinany _center;};
							};
						};
					} foreach _players;
					if (getnumber (_cfg >> "isUAV") < 1) then {
						_crewUnits = [_center,_crew,true,nil,true] call bis_fnc_initVehicleCrew;
						{
							//_x disableai "move";
							_x setbehaviour "careless";
							_x call bis_fnc_vrHitpart;
						} foreach _crewUnits;
					};

					//--- Set the same relative distance and position
					_centerSize = ((boundingboxreal _center select 0) vectordistance (boundingboxreal _center select 1));//sizeof typeof _center;
					if (_centerSizeOld != 0) then {
						_dis = BIS_fnc_arsenal_campos select 0;
						_disCoef = _dis / _centerSizeOld;
						BIS_fnc_arsenal_campos set [0,_centerSize * _disCoef];

						_targetPos = BIS_fnc_arsenal_campos select 3;
						_coefX = (_targetPos select 0) / _centerSizeOld;
						_coefY = (_targetPos select 1) / _centerSizeOld;
						_coefZ = (_targetPos select 2) / _centerSizeOld;
						BIS_fnc_arsenal_campos set [3,[_centerSize * _coefX,_centerSize * _coefY,_centerSize * _coefZ]];
					};
				};

				//--- Reset the vehicle state
				_center setdir direction _center;
				_center setvelocity [0,0,0];

				//--- Crew positions
				_ctrlButtonTry = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONTRY;
				_ctrlListCrew = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBCREW);
				lbclear _ctrlListCrew;

				if (getnumber (_cfg >> "isUAV") < 1) then {
					//_lbAdd = _ctrlListCrew lbadd "All crew"; //--- ToDo: Localize
					//_ctrlListCrew lbsetdata [_lbAdd,"Driver"];
					//_lbAdd = _ctrlListCrew lbadd "All passengers"; //--- ToDo: Localize
					//_ctrlListCrew lbsetdata [_lbAdd,"Driver"];
					_colorMe = getarray (configfile >> "CfgInGameUI" >> "IslandMap" >> "colorMe");

					//--- Driver
					if (getnumber (_cfg >> "hasdriver") > 0) then {
						_text = if (_center iskindof "air") then {localize "str_pilot"} else {localize "str_driver"};
						_isPlayer = isplayer driver _center;
						if (_isPlayer) then {_text = format ["%1 (%2)",_text,name player];};
						_lbAdd = _ctrlListCrew lbadd _text;
						_ctrlListCrew lbsetdata [_lbAdd,"Driver"];
						_ctrlListCrew lbsetpicture [_lbAdd,_checkboxTextures select !(isnull driver _center)];
						if (_isPlayer) then {_ctrlListCrew lbsetcolor [_lbAdd,_colorMe];};
					};

					//--- Turrets
					BIS_fnc_garage_turretPaths = [];
					_proxyIndexes = [];
					{
						_value = _foreachindex;
						_value = _value + 1; //--- Index must not be 0 to allow negative values
						_cfgTurret = _cfg;
						{_cfgTurret = (_cfgTurret >> "turrets") select _x;} foreach _x;
						_lbAdd = _ctrlListCrew lbadd gettext (_cfgTurret >> "gunnerName");
						_locked = _center lockedturret _x;
						_ctrlListCrew lbsetdata [_lbAdd,"Turret"];
						_ctrlListCrew lbsetvalue [_lbAdd,if (_locked) then {-_value} else {_value}];
						_ctrlListCrew lbsetpicture [_lbAdd,_checkboxTextures select !(isnull (_center turretunit _x))];
						BIS_fnc_garage_turretPaths pushback _x;

						//--- Count number of cargo turrets
						//if (gettext (_cfgTurret >> "proxyType") == "CPCargo") then {
						if (getnumber (_cfgTurret >> "isPersonTurret") > 0 && getnumber (_cfg >> "hideProxyInCombat") == 0) then { // ToDo: onlyPersonTurret
							//_proxyIndexes pushback (count _proxyIndexes + 1);
							_proxyIndexes pushback getnumber (_cfgTurret >> "proxyIndex");
						};
					} foreach (allturrets [_center,true]);

					//--- Cargo
					_occupiedSeats = [];
					{
						if ((_x select 1) == "cargo") then {_occupiedSeats pushback (_x select 2);};
					} foreach fullcrew _center;
					_getInProxyOrder = getarray (_cfg >> "getInProxyOrder");
					_transportSoldier = getnumber (_cfg >> "transportSoldier");

					_cargoProxyIndexes = [];
					if (count _getInProxyOrder == 0) then {
						for "_i" from 1 to _transportSoldier do {_getInProxyOrder pushback _i;};
						_turretCount = count _proxyIndexes;
						for "_i" from (1 + _turretCount) to (_transportSoldier + _turretCount) do {_cargoProxyIndexes pushback _i;};
					} else {
						{
							if !(_x in _proxyIndexes) then {_cargoProxyIndexes pushback (_foreachindex + 1);};
						} foreach _getInProxyOrder;
					};
					_cargoProxyIndexes resize (_transportSoldier min (count _cargoProxyIndexes)); //--- Do not let cargoProxyIndexes be larger than transportSoldier. Added because of misconfigured HEMTTs
					{
						_locked = _center lockedcargo (_x - 1);
						_lbAdd = _ctrlListCrew lbadd format ["%1 #%2",localize "STR_GETIN_POS_PASSENGER",_foreachindex + 1];
						_ctrlListCrew lbsetdata [_lbAdd,"Cargo"];
						_ctrlListCrew lbsetvalue [_lbAdd,if (_locked) then {-_x} else {_x}];
						_ctrlListCrew lbsetpicture [_lbAdd,_checkboxTextures select ((_x - 1) in _occupiedSeats)];
						_ctrlListCrew lbsetcolor [_lbAdd,_colors select _locked];
						_ctrlListCrew lbsetpicturecolor [_lbAdd,_colors select _locked];
					} foreach _cargoProxyIndexes;

					_ctrlButtonTry ctrlenable _fullVersion;
				} else {
					createvehiclecrew _center;
					if (_fullVersion) then {{_x setbehaviour "careless";} foreach crew _center;};
					_ctrlButtonTry ctrlenable false;
				};
				_ctrlListCrewDisabled = _display displayctrl (IDC_RSCDISPLAYARSENAL_LISTDISABLED + IDC_RSCDISPLAYGARAGE_TAB_SUBCREW);
				_ctrlListCrewDisabled ctrlshow (lbsize _ctrlListCrew == 0);

				//--- Animations
				_ctrlListAnimations = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION);
				lbclear _ctrlListAnimations;
				{
					_configName = configname _x;
					_displayName = gettext (_x >> "displayName");
					if (_displayName != "" && {getnumber (_x >> "scope") > 1 || !isnumber (_x >> "scope")}) then {
						_lbAdd = _ctrlListAnimations lbadd _displayName;
						_ctrlListAnimations lbsetdata [_lbAdd,_configName];
						_ctrlListAnimations lbsetpicture [_lbAdd,_checkboxTextures select ((_center animationphase _configName) max 0)];
					};
				} foreach (configproperties [_cfg >> "animationSources","isclass _x",true]);
				lbsort _ctrlListAnimations;
				_ctrlListAnimationsDisabled = _display displayctrl (IDC_RSCDISPLAYARSENAL_LISTDISABLED + IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION);
				_ctrlListAnimationsDisabled ctrlshow (lbsize _ctrlListAnimations == 0);

				//--- Textures
				_currentTextures = getobjecttextures _center;
				_current = "";
				_ctrlListTextures = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE);
				lbclear _ctrlListTextures;
				{
					_displayName = gettext (_x >> "displayName");
					if (_displayName != "") then {
						_textures = getarray (_x >> "textures");
						_selected = true;
						if (count _textures == count _currentTextures) then {
							{if (tolower _x find (_currentTextures select _foreachindex) < 0) exitwith {_selected = false;};} foreach _textures;
						} else {
							_selected = false;
						};
						_lbAdd = _ctrlListTextures lbadd _displayName;
						_ctrlListTextures lbsetdata [_lbAdd,configname _x];
						_ctrlListTextures lbsetpicture [_lbAdd,_checkboxTextures select 0];
						if (_selected) then {_current = configname _x;};
					};
				} foreach (configproperties [_cfg >> "textureSources","isclass _x",true]);
				lbsort _ctrlListTextures;
				for "_i" from 0 to (lbsize _ctrlListTextures - 1) do {
					if ((_ctrlListTextures lbdata _i) == _current) then {
						_ctrlListTextures lbsetcursel _i;
					};
				};
				_ctrlListTexturesDisabled = _display displayctrl (IDC_RSCDISPLAYARSENAL_LISTDISABLED + IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE);
				_ctrlListTexturesDisabled ctrlshow (lbsize _ctrlListTextures == 0);

				//--- Mark the tab as selected
				_ctrlTab = _display displayctrl (IDC_RSCDISPLAYARSENAL_TAB + _idc);
				_ctrlLineTab = _display displayctrl IDC_RSCDISPLAYARSENAL_LINETABLEFTSELECTED;
				_ctrlLineTabPos = ctrlposition _ctrlLineTab;
				_ctrlLineTabPos set [1,ctrlposition _ctrlTab select 1];
				_ctrlLineTab ctrlsetposition _ctrlLineTabPos;
				_ctrlLineTab ctrlcommit 0;
			};
			case IDC_RSCDISPLAYGARAGE_TAB_SUBCREW: {
				_role = _ctrlList lbdata _cursel;
				_roleIndex = _ctrlList lbvalue _cursel;
				if (_roleIndex < 0) exitwith {};
				_roleIndex = _roleIndex - 1; //--- Value was increased by 1 to allow negative values, revert back

				_checked = false;
				_fnc_createUnit = {
					//_unit = (creategroup (side group player)) createunit ["B_soldier_vr_f",position _center,[],0,"none"];
					_unit = createagent ["B_soldier_vr_f",position _center,[],0,"none"];
          Hz_econ_vehStore_dummyObjects set [count Hz_econ_vehStore_dummyObjects, _unit];
					_unit call bis_fnc_vrHitpart;
					if (_fullVersion) then {_unit setbehaviour "careless";}; //--- Turn out
					_unit
				};
				_fnc_deleteUnit = {
					_group = group _unit;
					_center deletevehiclecrew _unit;
					deletegroup _group;
				};
				switch _role do {
					case "Driver": {
						_unit = driver _center;
						if !(isplayer _unit) then {
							if (isnull _unit) then {
								_unit = call _fnc_createUnit;
								_unit moveindriver _center;
								_checked = true;
							} else {
								call _fnc_deleteUnit;
							};
						} else {
							_checked = true;
						};
					};
					case "Turret": {
						_roleIndexArray = BIS_fnc_garage_turretPaths select _roleIndex;
						_unit = _center turretunit _roleIndexArray;
						if !(isplayer _unit) then {
							if (isnull _unit) then {
								_unit = call _fnc_createUnit;
								_unit moveinturret [_center,_roleIndexArray];
								_checked = true;
							} else {
								call _fnc_deleteUnit;
							};
						} else {
							_checked = true;
						};
					};
					case "Cargo": {
						_unit = objnull;
						{
							if ((_x select 1) == "cargo" && (_x select 2) == _roleIndex) exitwith {_unit = _x select 0;};
						} foreach fullcrew _center;
						if !(isplayer _unit) then {
							if (isnull _unit) then {
								_unit = call _fnc_createUnit;
								_unit moveincargo [_center,_roleIndex];
								_checked = true;
							} else {
								call _fnc_deleteUnit;
							};
						} else {
							_checked = true;
						};
					};
				};
				//_ctrlListCrew = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBCREW);
				_ctrlList lbsetpicture [_cursel,_checkboxTextures select _checked];
			};

			case IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION: {
				_selected = _checkboxTextures find (_ctrlList lbpicture _cursel);
				_ctrlList lbsetpicture [_cursel,_checkboxTextures select ((_selected + 1) % 2)];
				_initVehicle = true;
			};
			case IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE: {
				_selected = _checkboxTextures find (_ctrlList lbpicture _cursel);
				for "_i" from 0 to (lbsize _ctrlList - 1) do {
					_ctrlList lbsetpicture [_i,_checkboxTextures select 0];
				};
				_ctrlList lbsetpicture [_cursel,_checkboxTextures select 1];
				_initVehicle = true;
			};
/*
			case IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION: {
				_animationClass = _ctrlList lbdata _cursel;
				_cfg = configfile >> "cfgvehicles" >> typeof _center >> "animationsources" >> _animationClass;
				_animationPhase = round ((_center animationphase _animationClass) + 1) % 2;
				_center animate [_animationClass,_animationPhase];
				_ctrlList lbsetpicture [_cursel,_checkboxTextures select _animationPhase];
			};
			case IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE: {
				_textureClass = _ctrlList lbdata _cursel;
				_cfg = configfile >> "cfgvehicles" >> typeof _center >> "texturesources" >> _textureClass;
				{
					_center setobjecttexture [_foreachindex,_x];
				} foreach getarray (_cfg >> "textures");
			};
*/
		};
		if (_initVehicle) then {
			_ctrlListTextures = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBTEXTURE);
			_ctrlListAnimations = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBANIMATION);
			_textures = "";
			_animations = [];
			for "_i" from 0 to (lbsize _ctrlListTextures - 1) do {
				if ((_ctrlListTextures lbpicture _i) == (_checkboxTextures select 1)) exitwith {_textures = [_ctrlListTextures lbdata _i,1];};
			};
			for "_i" from 0 to (lbsize _ctrlListAnimations - 1) do {
				_animations pushback (_ctrlListAnimations lbdata _i);
				_animations pushback (_checkboxTextures find (_ctrlListAnimations lbpicture _i));
			};
			[_center,_textures,_animations] call bis_fnc_initVehicle;
		};

		["SetCrewStatus",[_display]] call (uinamespace getvariable "bis_fnc_garage_UI");
		if (isclass _cfg) then {
			["ShowItemInfo",[_cfg]] call (uinamespace getvariable "bis_fnc_arsenal_UI");
			["ShowItemStats",[_cfgStats]] call (uinamespace getvariable "bis_fnc_garage_UI");
		};
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "SetCrewStatus": {
		_display = _this select 0;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_checkboxTextures = [
			tolower gettext (configfile >> "RscCheckBox" >> "textureUnchecked"),
			tolower gettext (configfile >> "RscCheckBox" >> "textureChecked")
		];
		_colors = [[1,1,1,1],[1,1,1,0.25]];

		_ctrlListCrew = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYGARAGE_TAB_SUBCREW);
		_lockedIndexes = [];
		_colorMe = getarray (configfile >> "CfgInGameUI" >> "IslandMap" >> "colorMe");
		_iconPlayer = gettext (configfile >> "CfgInGameUI" >> "IslandMap" >> "iconPlayer");
		_emptyPositions = 0;
		for "_i" from 0 to (lbsize _ctrlListCrew - 1) do {
			_role = _ctrlListCrew lbdata _i;
			_roleIndex = abs (_ctrlListCrew lbvalue _i) - 1;
			_value = abs (_ctrlListCrew lbvalue _i);
			_locked = false;
			_unit = objnull;
			
			//--- ToDo: lockCargoAnimationPhase
			switch (tolower _role) do {
				case "cargo": {
					_unit = objnull;
					{if ((_x select 2) == _roleIndex) exitwith {_unit = _x select 0;};} foreach fullcrew _center;
					_locked = _center lockedcargo _roleIndex;
					if (_locked) then {_lockedIndexes pushback _roleIndex;};
				};
				case "gunner";
				case "commander";
				case "turret": {
					_turretPath = BIS_fnc_garage_turretPaths select _roleIndex; 
					_unit = _center turretunit _turretPath;
					_locked = _center lockedturret _turretPath;
					if (_locked) then {_lockedIndexes pushback _turretPath;};
				};
				case "driver": {
					_unit = driver _center;
					_locked = lockeddriver _center;
				};
			};
			_isPlayer = isplayer _unit;
			if (_locked && !isnull _unit) then {
				moveout _unit;
				_isPlayer = false;
				if (_fullVersion) then {
					if (_unit == player) then {_unit hideobject true;} else {deletevehicle _unit;};
				};
			};
			_ctrlListCrew lbsetcolor [_i,_colors select _locked];
			_ctrlListCrew lbsetvalue [_i,[_value,-_value] select _locked];
			if (_isPlayer) then {
				_ctrlListCrew lbsetpicture [_i,_iconPlayer];
				_ctrlListCrew lbsetpicturecolor [_i,_colorMe];
				_emptyPositions = _emptyPositions + 1;
			} else {
				_isOccupied = !isnull _unit && !_locked;
				_ctrlListCrew lbsetpicturecolor [_i,_colors select _locked];
				_ctrlListCrew lbsetpicture [_i,_checkboxTextures select _isOccupied];
				if !(_isOccupied) then {_emptyPositions = _emptyPositions + 1;};
			};
		};

		//--- Delete crew on locked seats
		{
			_delete = switch (tolower (_x select 1)) do {
				case "cargo": {(_x select 2) in _lockedIndexes};
				case "gunner";
				case "commander";
				case "turret": {(_x select 3) in _lockedIndexes};
				default {false}
			};
			if (_delete) then {
				_center deletevehiclecrew (_x select 0);
			};
		} foreach (fullcrew _center);

		//--- Disable TRY button when there's no space
		_ctrlButtonTry = _display displayctrl IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONTRY;
		_ctrlButtonTry ctrlenable (_emptyPositions > 0);
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "ShowItemStats": {
                   
                    
                 
                            
		_itemCfg = _this select 0;
		if (isclass _itemCfg) then {
			_ctrlStats = _display displayctrl IDC_RSCDISPLAYARSENAL_STATS_STATS;
			_ctrlStatsPos = ctrlposition _ctrlStats;
			_ctrlStatsPos set [0,0];
			_ctrlStatsPos set [1,0];
			_ctrlBackground = _display displayctrl IDC_RSCDISPLAYARSENAL_STATS_STATSBACKGROUND;
			_barMin = 0.01;
			_barMax = 1;

			_statControls = [
				[IDC_RSCDISPLAYARSENAL_STATS_STAT1,IDC_RSCDISPLAYARSENAL_STATS_STATTEXT1],
				[IDC_RSCDISPLAYARSENAL_STATS_STAT2,IDC_RSCDISPLAYARSENAL_STATS_STATTEXT2],
				[IDC_RSCDISPLAYARSENAL_STATS_STAT3,IDC_RSCDISPLAYARSENAL_STATS_STATTEXT3],
				[IDC_RSCDISPLAYARSENAL_STATS_STAT4,IDC_RSCDISPLAYARSENAL_STATS_STATTEXT4],
				[IDC_RSCDISPLAYARSENAL_STATS_STAT5,IDC_RSCDISPLAYARSENAL_STATS_STATTEXT5]
			];
			_rowH = 1 / (count _statControls + 1);
			_fnc_showStats = {
				_h = _rowH;
				{
					_ctrlStat = _display displayctrl ((_statControls select _foreachindex) select 0);
					_ctrlText = _display displayctrl ((_statControls select _foreachindex) select 1);
					if (count _x > 0) then {
						_ctrlStat progresssetposition (_x select 0);
						_ctrlText ctrlsettext toupper (_x select 1);
						_ctrlText ctrlsetfade 0;
						_ctrlText ctrlcommit 0;
						//_ctrlText ctrlshow true;
						_h = _h + _rowH;
					} else {
						_ctrlStat progresssetposition 0;
						_ctrlText ctrlsetfade 1;
						_ctrlText ctrlcommit 0;
						//_ctrlText ctrlshow false;
					};
				} foreach _this;
				_ctrlStatsPos set [1,(_ctrlStatsPos select 3) * (1 - _h)];
				_ctrlStatsPos set [3,(_ctrlStatsPos select 3) * _h];
				_ctrlBackground ctrlsetposition _ctrlStatsPos;
				_ctrlBackground ctrlcommit 0;
			};

			_ctrlStats ctrlsetfade 0;
			_statsExtremes = uinamespace getvariable "BIS_fnc_garage_stats";
			if !(isnil "_statsExtremes") then {
				_statsMin = _statsExtremes select 0;
				_statsMax = _statsExtremes select 1;

				_stats = [
					[_itemCfg],
					STATS,
					_statsMin
				] call bis_fnc_configExtremes;
				_stats = _stats select 1;

				_statMaxSpeed = linearConversion [_statsMin select 0,_statsMax select 0,_stats select 0,_barMin,_barMax];
				_statArmor = linearConversion [_statsMin select 1,_statsMax select 1,_stats select 1,_barMin,_barMax];
				_statFuelCapacity = linearConversion [_statsMin select 2,_statsMax select 2,_stats select 2,_barMin,_barMax];
				_statThreat = linearConversion [_statsMin select 3,_statsMax select 3,_stats select 3,_barMin,_barMax];
                                _vehType = toupper configname _itemCfg;
                                _price = _vehType call Hz_econ_vehStore_fnc_getVehCost;
                                _Pricedisplay = "";
                                if (_price == -1) then {

                                    _Pricedisplay = "Vehicle not available";

                                } else {

                                    if(_price >= 1000000) then {

                                        _Pricedisplay = format ["$%1 million",(_price / 1000000)];

                                    } else {

                                        _Pricedisplay = format ["$%1",_price];   

                                    };

                                };
                                
                                _funds = missionnamespace getvariable "Hz_econ_funds";
                                _fundsDisplay = "";
                                
                                 if(_funds >= 1000000) then {

                                        _fundsDisplay = format ["$%1 million",(_funds / 1000000)];

                                    } else {

                                        _fundsDisplay = format ["$%1",_funds];   

                                    };
                                
                                [
                                [],[],[],
                                [1,format ["Available funds:       %1",_fundsDisplay]],
                                [1,format ["Price:                               %1",_Pricedisplay]]
                                /*
                                [_statFuelCapacity,"Fuel capacity"],
                                [_statThreat,"Threat"]
                                */
                                ] call _fnc_showStats;
			};

			_ctrlStats ctrlcommit FADE_DELAY;
		} else {
			_ctrlStats = _display displayctrl IDC_RSCDISPLAYARSENAL_STATS_STATS;
			_ctrlStats ctrlsetfade 1;
			_ctrlStats ctrlcommit FADE_DELAY;
		};
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "buttonImport": {
	
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "buttonExport": {
	
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "buttonRandom": {
	
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "showTemplates": {
		
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "buttonTemplateOK": {
		_display = _this select 0;
		_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		_hideTemplate = true;

		_ctrlTemplateName = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_EDITNAME;
		if (ctrlenabled _ctrlTemplateName) then {
			//--- Save
			[
				_center,
				[profilenamespace,ctrltext _ctrlTemplateName]
			] call bis_fnc_saveVehicle;
		} else {
			//--- Load
			_ctrlTemplateValue = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_VALUENAME;
			_categoryIndex = _ctrlTemplateValue lbvalue lnbcurselrow _ctrlTemplateValue;

			if (_categoryIndex >= 0) then {
				_savedData = profilenamespace getvariable ["bis_fnc_saveVehicle_data",[]];
				_name = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
				_nameID = _savedData find _name;
				if (_nameID >= 0) then {
					_vehData = _savedData select (_nameID + 1);
					_vehType = _vehData select 0;
					_vehModel = tolower gettext (configfile >> "cfgvehicles" >> _vehType >> "model");
					if (getnumber (configfile >> "cfgvehicles" >> _vehType >> "forceInGarage") > 0) then {_vehModel = _vehModel + ":" + _vehType;};
					_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _categoryIndex);
					for "_i" from 0 to (lbsize _ctrlList - 1) do {
						if (_ctrlList lbdata _i == _vehModel) exitwith {_ctrlList lbsetcursel _i;};
					};

					_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
					[_center,_name,_categoryIndex,_display] spawn { //--- Must be spawned, animations cannot be applied immediately
						disableserialization;
						_center = _this select 0;
						_name = _this select 1;
						_categoryIndex = _this select 2;
						_display = _this select 3;

						[_center,[profilenamespace,_name]] call bis_fnc_loadvehicle;
						if (is3DEN) then {
							['SelectItem',[_display,_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _categoryIndex),_categoryIndex]] call (uinamespace getvariable "bis_fnc_garage_UI");
						} else {

						};
					};
				};
			} else {
				_hideTemplate = false;
			};
		};
		if (_hideTemplate) then {
			_ctrlTemplate = _display displayctrl IDC_RSCDISPLAYARSENAL_TEMPLATE_TEMPLATE;
			_ctrlTemplate ctrlsetfade 1;
			_ctrlTemplate ctrlcommit 0;
			_ctrlTemplate ctrlenable false;

			_ctrlMouseBlock = _display displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
			_ctrlMouseBlock ctrlenable false;
		};
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "buttonTry": {
		_display = _this select 0;
                _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
                _vehType = toupper typeof _center;
                _price = _vehType call Hz_econ_vehStore_fnc_getVehCost;
                _spawnPos = getposatl _center;
                _funds = missionnamespace getvariable "Hz_econ_funds";
                
                if (_price >= 0) then {
                
                    if (_funds >= _price) then {

												_customStuff = [_center] call (missionNamespace getVariable "bis_fnc_getVehicleCustomization");

                        _display closedisplay 2;

                        ["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;

                        [_vehType,_price,_spawnPos,_customStuff] spawn {

                            _vehType = _this select 0;        
                            _price = _this select 1;    
                            _spawnPos = _this select 2;
														_customStuff = _this select 3;

                            with missionnamespace do {

                            sleep 1;

                            hint "Vehicle delivered";

                            Hz_econ_funds = Hz_econ_funds - _price;
                            publicvariable "Hz_econ_funds";                       

                            _veh = _vehType createvehicle _spawnPos;
														
														[_veh] call Hz_econ_vehStore_customInitFnc;

														[_veh,_customStuff select 0,_customStuff select 1] call BIS_fnc_initVehicle;
														
														if (Hz_econ_vehStore_spawnEmpty) then {
														
														    clearMagazineCargoGlobal _veh;
																clearItemCargoGlobal _veh;
																clearWeaponCargoGlobal _veh;
																_veh setfuel 0.05;
																_veh setvehicleammo 0;														
														
														};
														
														if(!isnil "Hz_pers_network_vehicles") then {
														
														Hz_pers_network_vehicles pushback _veh;
														publicvariable "Hz_pers_network_vehicles";
														
														};

                            };

                        };

                } else {

                        [
                        "showMessage",
                        [
                        _display,
                        "Insufficient funds"
                        ]
                        ] call (uinamespace getvariable "bis_fnc_arsenal_UI");

                };   
                    
             } else {
             
                [
                "showMessage",
                [
                _display,
                "Vehicle not available"
                ]
                ] call (uinamespace getvariable "bis_fnc_arsenal_UI");

            };   
                          
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "buttonOK": {
		_display = _this select 0;
		_display closedisplay 2;
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;


		//--- Apply the look on all selected objects
		if (is3DEN) then {
			_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
			_centerType = typeof _center;
			_customization = _center call bis_fnc_getVehicleCustomization;
			_texture = _customization select 0 select 0;
			_anims = _customization select 1;
			_objects = [];
			{
				if (_centerType == typeof _x) then {_objects pushback _x;}; //--- Change only objects of the same type
			} foreach get3DENSelected "object";
			set3DENAttributes [[_objects,"VehicleCustomization",[[],_anims]]];
			set3DENAttributes [[_objects,"ObjectTexture",_texture]];
		};

	};

	///////////////////////////////////////////////////////////////////////////////////////////
	case "loadVehicle": {

	};
};