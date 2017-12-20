class cfgPatches
{
	class Hz_mod_economy
	{
		name="Hunter'z Economy Module";
		author="K.Hunter";
		url="https://github.com/KHunter-Arma";
		requiredVersion=1.58;
		requiredAddons[]=
		{
			"A3_Ui_F",
			"A3_Modules_F"
		};
		units[]=
		{
			"Hz_mod_economy_module"
		};
		weapons[]={};
	};
};
class CfgMods
{
	class Mod_Base;
	class Hz_mod_economy: Mod_Base
	{
		name="Hunter'z Economy Module";
		picture="\x\Hz\Hz_mod_economy\media\Hunterz_logo.paa";
		logo="\x\Hz\Hz_mod_economy\media\Hunterz_icon.paa";
		logoSmall="\x\Hz\Hz_mod_economy\media\Hunterz_iconSmall.paa";
		logoOver="\x\Hz\Hz_mod_economy\media\Hunterz_icon.paa";
		tooltipOwned="";
		action="https://github.com/KHunter-Arma";
		dlcColor[]={1,0,0,0.80000001};
		overview="";
		hideName=0;
		hidePicture=0;
		dir="@Hz_mod_economy";
	};
};
class CfgMusic
{
	tracks[]={};
	class Hz_econ_media_showroom
	{
		name="Callista";
		sound[]=
		{
			"\x\Hz\Hz_mod_economy\media\Saki_Kaskas_Callista.ogg",
			0.31622776,
			1
		};
	};
};
class RscDisplayGarage;
class RscDisplayGarage_Hz: RscDisplayGarage
{
	onLoad="[""onLoad"",_this,""RscDisplayGarage"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayGarage"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplay')";
};
class RscDisplayArsenal;
class RscDisplayArsenal_Hz: RscDisplayArsenal
{
	onLoad="[""onLoad"",_this,""RscDisplayArsenal"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplayArsenal')";
	onUnload="[""onUnload"",_this,""RscDisplayArsenal"",'GUI'] call 	(uinamespace getvariable 'Hz_BIS_fnc_initDisplayArsenal')";
};
class cfgFunctions
{
	class Hz
	{
		class Hz_moduleFunctions
		{
			class econ_init
			{
				file="\x\Hz\Hz_mod_economy\Hz_econ_init.sqf";
			};
		};
	};
};
class CfgFactionClasses
{
	class NO_CATEGORY;
	class Hz_editorModules: NO_CATEGORY
	{
		displayName="Hz";
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
			class Edit;
			class Combo;
			class Checkbox;
			class CheckboxNumber;
			class ModuleDescription;
		};
		class ModuleDescription
		{
		};
	};
	class Hz_mod_economy_module: Module_F
	{
		scope=2;
		displayName="Hunter'z Economy";
		icon="\x\Hz\Hz_mod_economy\media\Hunterz_icon.paa";
		category="Hz_editorModules";
		function="Hz_fnc_econ_init";
		functionPriority=0;
		isGlobal=2;
		isTriggerActivated=0;
		isDisposable=0;
		is3DEN=0;
		curatorInfoType="";
		class Attributes: AttributesBase
		{
			class PathToPriceFunctions: Edit
			{
				property="Hz_econ_module_pPathToPriceFunctions";
				displayName="Path To Price Functions";
				tooltip="Path to the folder where you have all the files containing the store price code functions which are required by the module.  Equipment or vehicles that have no price defined will not be available in the stores. The input to all functions is the classname (held by the '_this' variable). The functions must return the cost of the equipment/vehicle in question, or -1 if the price is not available. Example files are provided in the Examples folder that you are recommended to use as a template. WARNING: These functions must be defined on all clients, and therefore it is recommended to have these files either in your mission file, or your own custom addon.";
				defaultValue="""""";
			};
			class Funds: Edit
			{
				property="Hz_econ_module_pFunds";
				displayName="Starting Funds";
				tooltip="The money you have at the start of the mission.";
				defaultValue="""0""";
			};
			class VehStores: Edit
			{
				property="Hz_econ_module_pVehStores";
				displayName="Vehicle Stores";
				tooltip="Array holding names of references to vehicle store objects. Objects can be anything including vehicles and units. Enter names (references as global variables) given to store objects wrapped in quotes. The default value is an example. It is highly recommended to set a position via a variable called 'Hz_econ_vehStore_spawnPos' on each store object using the 'setVariable' command to define a safe spawn position for vehicles bought from that store.";
				defaultValue="'[""myVehStore1"",""myVehStore2"",""myVehStore3""]'";
			};
			class VehSpawnEmpty: Checkbox
			{
				property="Hz_econ_module_pVehSpawnEmpty";
				displayName="Enable Vehicle Spawn Empty";
				tooltip="If enabled, vehicles bought from the store will spawn with no ammo, and will have very little fuel.";
			};
			class VehCustomInitFunctionName: Edit
			{
				property="Hz_econ_module_pVehCustomInitFunctionName";
				displayName="Vehicle Custom Init Function Name";
				tooltip="OPTIONAL: Leave empty if you don't want to use it. The name of your function to execute when a new vehicle is bought from the store. Parameters passed to function: [vehicle]. WARNING: This function will be executed locally by the client that used the store. The vehicle will be local to the client when spawned as it's 'createvehicle'd by them. If you use this option, you must make sure the function is defined, or the module will get stuck waiting for it to be defined and the store won't be available.";
				defaultValue="""""";
			};
			class FuelPrice: Edit
			{
				property="Hz_econ_module_pFuelPrice";
				displayName="FuelPrice";
				tooltip="Cost per liter of fuel. Used with ACE Refuel if ACE is running. Note: For the ACE interface to work at all, ACE Hunter'z (an edited version of ACE configured to interface with Hunter'z Economy Module) must be used.";
				defaultValue="""1.5""";
			};
			class CombatStores: Edit
			{
				property="Hz_econ_module_pCombatStores";
				displayName="Combat Stores";
				tooltip="Array holding names of references to combat store objects. Objects can be anything including vehicles and units. Enter names (references as global variables) given to store objects wrapped in quotes. The default value is an example.";
				defaultValue="'[""myStore1"",""myStore2"",""myStore3""]'";
			};
			class Restrictions: Checkbox
			{
				property="Hz_econ_module_pRestrictions";
				displayName="Enable Restrictions";
				tooltip="Enable/disable player restrictions system to limit use of different equipment including all gear items and vehicles.";
			};
			class LimitedStoreAccess: Checkbox
			{
				property="Hz_econ_module_pLimitedStoreAccess";
				displayName="Limit Store Access by Default";
				tooltip="Limit access to stores by default, to allow whitelisting. If enabled, a player won't be able to use the combat store unless you locally set ""Hz_econ_combatStore_storeClosed = false"", similarly with the vehicle store, unless you locally set ""Hz_econ_vehicleStore_storeClosed = false"" the vehicle store will be inaccessible. If this option is left disabled, the system works in reverse; the stores will be open to everyone by default, but you can still disable access to some players by locally setting those variables to ""true"".";
			};
			class DisableInsignia: Checkbox
			{
				property="Hz_econ_module_pDisableInsignia";
				displayName="Disable Unit Insignia";
				tooltip="Makes insignia (arm patches) selection unavailable in the store if enabled.";
			};
			class CombatStoreExitFunctionName: Edit
			{
				property="Hz_econ_module_pCombatStoreExitFunctionName";
				displayName="Combat Store Exit Function Name";
				tooltip="OPTIONAL: Leave empty if you don't want to use it. The name of your function to execute when a player exits the store. Parameters passed to function: [money spent, items bought], where money spent is a number that holds how much money the player spent at the store, and items bought is an array holding 2D arrays formed up of classnames and quantities of all new items bought by the player in the format [[newWeaponsArray,countArray],[newAttachmentsArray,countArray],[newItemsArray,countArray],[newMagazinesArray,countArray],[newAmmoArray,countArray]]. WARNING: This function will be executed locally by the client that used the store, so the user object can be accessed using the ""player"" command. If you use this option, you must make sure the function is defined, or the module will get stuck waiting for it to be defined and the store won't be available.";
				defaultValue="""""";
			};
			class RestrictionsSetupFunctionName: Edit
			{
				property="Hz_econ_module_pRestrictionsSetupFunctionName";
				displayName="Restrictions Setup Function Name";
				tooltip="Required only if restrictions are enabled. Name of the function that the server will call during module initialisation to set up required restriction config variables.";
				defaultValue="""someScripter_fnc_setupRestrictionVars""";
			};
			class ModuleDescription: ModuleDescription
			{
			};
		};
		class ModuleDescription: ModuleDescription
		{
			description="Hunter'z Economy Module";
			sync[]={};
		};
	};
};
