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

class cfgPatches {

  class Hz_mod_economy {
    
    name = "Hunter'z Economy Module";
    author = "K.Hunter";
    url = "https://github.com/KHunter-Arma";
    
    requiredVersion = 1.58; 
    requiredAddons[] = {"A3_Ui_F","A3_Modules_F"};
    units[] = {"Hz_mod_economy_module"};
    weapons[] = {};
    
  };

};

class CfgMusic
{
	tracks[]={};

	class Hz_econ_media_showroom
	{
		name = "Callista";
		sound[] = {"\x\Hz\Hz_mod_economy\media\Saki_Kaskas_Callista.ogg", db-10, 1.0};
	};

};

class RscDisplayGarage;
class RscDisplayGarage_Hz : RscDisplayGarage
{
	onLoad="[""onLoad"",_this,""RscDisplayGarage"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayGarage"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplay')";
};


class RscDisplayGarage3DEN;
class RscDisplayGarage3DEN_Hz : RscDisplayGarage3DEN
{
	onLoad="[""onLoad"",_this,""RscDisplayGarage"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayGarage"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplay')";
};


class RscDisplayArsenal;
class RscDisplayArsenal_Hz : RscDisplayArsenal
{
	onLoad="[""onLoad"",_this,""RscDisplayArsenal"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplayArsenal')";
	onUnload="[""onUnload"",_this,""RscDisplayArsenal"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplayArsenal')";
};

class cfgFunctions
{
  class Hz {
      
      class Hz_moduleFunctions {
				
				class econ_init {
					
					file = "\x\Hz\Hz_mod_economy\Hz_econ_init.sqf";					
					
				};           
        
      };
    
  };
  
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class Hz_editorModules: NO_CATEGORY
	{
		displayName = "Hz";
	};
};

class CfgVehicles
{
  class Logic;
  class Module_F: Logic
  {
    class AttributesBase
    {
      class Default;
      class Edit; // Default edit box (i.e., text input field)
      class EditArray;
      class Combo; // Default combo box (i.e., drop-down menu)
      class Checkbox; // Default checkbox (returned value is Bool)
      class CheckboxNumber; // Default checkbox (returned value is Number)
      class ModuleDescription; // Module description
    };
    // Description base classes, for more information see below
    class ModuleDescription
    {
      
    };
  };
  class Hz_mod_economy_module: Module_F
  {
    // Standard object definitions
    scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
    displayName = "Hunter'z Economy"; // Name displayed in the menu
    icon = "\x\Hz\Hz_mod_economy\media\Hunterz_logo.paa"; // Map icon. Delete this entry to use the default icon
    category = "Hz_editorModules";

    // Name of function triggered once conditions are met
    function = "Hz_fnc_econ_init";
    // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
    functionPriority = 0;
    // 0 for server only execution, 1 for global execution, 2 for persistent global execution
    isGlobal = 2;
    // 1 for module waiting until all synced triggers are activated
    isTriggerActivated = 0;
    // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
    isDisposable = 0;
    // 1 to run init function in Eden Editor as well
    is3DEN = 0;

    // Menu displayed when the module is placed or double-clicked on by Zeus
    curatorInfoType = "";

    // Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
    class Attributes: AttributesBase
    {    
      class Funds: Edit
      {
				property = "Hz_econ_module_pFunds";
        displayName = "Starting Funds";
        tooltip = "The money you have at the start of the mission.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = "0";
      };
      class VehStores: EditArray
      {
				property = "Hz_econ_module_pVehStores";
        displayName = "Vehicle Stores";
        tooltip = "Array holding names of references to vehicle store objects. Objects can be anything including vehicles and units. Enter names (references as global variables) given to store objects wrapped in quotes and seperated by commas. The default value is an example. It is highly recommended to set a position via a variable called 'Hz_econ_vehStore_spawnPos' on each store object using the 'setVariable' command to define a safe spawn position for vehicles bought from that store.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """myVehStore1"",""myVehStore2"",""myVehStore3""";
      };
      class CombatStores: EditArray
      {
				property = "Hz_econ_module_pCombatStores";
        displayName = "Combat Stores";
        tooltip = "Array holding names of references to combat store objects. Objects can be anything including vehicles and units. Enter names (references as global variables) given to store objects wrapped in quotes and seperated by commas. The default value is an example.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """myStore1"",""myStore2"",""myStore3""";
      };
      class Restrictions: Combo
      {
        // Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
        property = "Hz_econ_module_pRestrictions";
        displayName = "Enable Restrictions"; // Argument label
        tooltip = "Enable/disable player restrictions system to limit use of different equipment including all gear items and vehicles."; // Tooltip description
        typeName = "BOOL"; // Value type, can be "NUMBER", "STRING" or "BOOL"
        defaultValue = "false"; // Default attribute value. WARNING: This is an expression, and its returned value will be used (50 in this case)
        class Values
        {
					class disabled	{name = "Disable"; value = false;};
          class enabled	{name = "Enable";	value = true;}; // Listbox item
        };
      };
      class RestrictionsSetupFunctionName: Edit
      {
				property = "Hz_econ_module_pRestrictionsSetupFunctionName";
        displayName = "RestrictionsSetupFunctionName";
        tooltip = "Required only if restrictions are enabled. Name of the function that the server will call during module initialisation to set up required restriction config variables.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """someScripter_fnc_setupRestrictionVars""";
      };
      class ModuleDescription: ModuleDescription{}; // Module description should be shown last
    };

    // Module description. Must inherit from base class, otherwise pre-defined entities won't be available
    class ModuleDescription: ModuleDescription
    {
      description = "Hunter'z Economy Module"; // Short description, will be formatted as structured text
      sync[] = {}; // Array of synced entities (can contain base classes)      

    };
  };
};