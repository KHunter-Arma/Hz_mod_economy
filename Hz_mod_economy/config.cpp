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

class CfgMods
{
	class Mod_Base;
	class Hz_mod_economy: Mod_Base
	{
		name = "Hunter'z Economy Module";
		picture = "\x\Hz\Hz_mod_economy\media\Hunterz_logo.paa";
		logo = "\x\Hz\Hz_mod_economy\media\Hunterz_icon.paa";
		logoSmall = "\x\Hz\Hz_mod_economy\media\Hunterz_iconSmall.paa";
		logoOver = "\x\Hz\Hz_mod_economy\media\Hunterz_icon.paa";
		tooltipOwned = "";
		action = "https://github.com/KHunter-Arma";
		dlcColor[] = {1,00,00,0.8};
		overview = "";
		hideName = 0;
		hidePicture = 0;
		dir = "@Hz_mod_economy";
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
    icon = "\x\Hz\Hz_mod_economy\media\Hunterz_icon.paa"; // Map icon. Delete this entry to use the default icon
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
      class PathToPriceFunctions: Edit
      {
				property = "Hz_econ_module_pPathToPriceFunctions";
        displayName = "Path To Price Functions";
        tooltip = "Path to the folder where you have all the files containing the store price code functions which are required by the module.  Equipment or vehicles that have no price defined will not be available in the stores. The input to all functions is the classname (held by the '_this' variable). The functions must return the cost of the equipment/vehicle in question, or -1 if the price is not available. Example files are provided in the Examples folder that you are recommended to use as a template. WARNING: These functions must be defined on all clients, and therefore it is recommended to have these files either in your mission file, or your own custom addon.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """""";
      };
      class Funds: Edit
      {
				property = "Hz_econ_module_pFunds";
        displayName = "Starting Funds";
        tooltip = "The money you have at the start of the mission.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """0""";
      };
      class VehStores: Edit
      {
				property = "Hz_econ_module_pVehStores";
        displayName = "Vehicle Stores";
        tooltip = "Array holding names of references to vehicle store objects. Objects can be anything including vehicles and units. Enter names (references as global variables) given to store objects wrapped in quotes. The default value is an example. It is highly recommended to set a position via a variable called 'Hz_econ_vehStore_spawnPos' on each store object using the 'setVariable' command to define a safe spawn position for vehicles bought from that store.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = "'[""myVehStore1"",""myVehStore2"",""myVehStore3""]'";
      };
			class VehSpawnEmpty: Checkbox
      {
        // Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
        property = "Hz_econ_module_pVehSpawnEmpty";
        displayName = "Enable Vehicle Spawn Empty"; // Argument label
        tooltip = "If enabled, vehicles bought from the store will spawn with no ammo, and will have very little fuel."; // Tooltip description
      };
			class VehCustomInitFunctionName: Edit
      {
				property = "Hz_econ_module_pVehCustomInitFunctionName";
        displayName = "Vehicle Custom Init Function Name";
        tooltip = "OPTIONAL: Leave empty if you don't want to use it. The name of your function to execute when a new vehicle is bought from the store. Parameters passed to function: [vehicle]. WARNING: This function will be executed locally by the client that is using the store. The vehicle will be local to the client when spawned as it's 'createvehicle'd by them.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """""";
      };
			class FuelPrice: Edit
      {
				property = "Hz_econ_module_pFuelPrice";
        displayName = "FuelPrice";
        tooltip = "Cost per liter of fuel. Used with ACE Refuel if ACE is running. Note: For the ACE interface to work at all, ACE Hunter'z (an edited version of ACE configured to interface with Hunter'z Economy Module) must be used.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = """1.5""";
      };
      class CombatStores: Edit
      {
				property = "Hz_econ_module_pCombatStores";
        displayName = "Combat Stores";
        tooltip = "Array holding names of references to combat store objects. Objects can be anything including vehicles and units. Enter names (references as global variables) given to store objects wrapped in quotes. The default value is an example.";
        // Default text filled in the input box
        // Because it's an expression, to return a String one must have a string within a string
        defaultValue = "'[""myStore1"",""myStore2"",""myStore3""]'";
      };
      class Restrictions: Checkbox
      {
        // Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
        property = "Hz_econ_module_pRestrictions";
        displayName = "Enable Restrictions"; // Argument label
        tooltip = "Enable/disable player restrictions system to limit use of different equipment including all gear items and vehicles."; // Tooltip description
      };
			class LimitedStoreAccess: Checkbox
      {
        // Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
        property = "Hz_econ_module_pLimitedStoreAccess";
        displayName = "Limit Store Access"; // Argument label
        tooltip = "Limit access to stores to certain players. If enabled, players will not be able to use the combat store if you locally set ""Hz_econ_combatStore_storeClosed = true"", similarly with the vehicle store, if you locally set ""Hz_econ_vehicleStore_storeClosed = true"" the vehicle store will be inaccessible"; // Tooltip description
      };
			
			class DisableInsignia: Checkbox
      {
        // Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
        property = "Hz_econ_module_pDisableInsignia";
        displayName = "Disable Unit Insignia"; // Argument label
        tooltip = "Makes insignia (arm patches) selection unavailable in the store if enabled."; // Tooltip description
      };			
			
      class RestrictionsSetupFunctionName: Edit
      {
				property = "Hz_econ_module_pRestrictionsSetupFunctionName";
        displayName = "Restrictions Setup Function Name";
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
