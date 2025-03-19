package mods;

import mods.scripted.ScriptedCharacter;
import polymod.Polymod;
import polymod.format.ParseRules.TextFileFormat;

class PolymodHandler
{
	static final MOD_FOLDER:String =
		#if (REDIRECT_ASSETS_FOLDER && macos)
		'../../../../../../../example_mods'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../example_mods'
		#else
		'mods'
		#end;

	static final CORE_FOLDER:Null<String> =
		#if (REDIRECT_ASSETS_FOLDER && macos)
		'../../../../../../../assets'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../assets'
		#else
		null
		#end;

	public static var loadedMods:Array<ModMetadata> = [];

	public static function init(?framework:Null<Framework>)
	{
		#if sys // fix for crash on sys platforms
		if (!sys.FileSystem.exists('./mods'))
			sys.FileSystem.createDirectory('./mods');
		#end
		var dirs:Array<String> = [];
		var polyMods = Polymod.scan({modRoot: './mods/'});
		for (i in 0...polyMods.length)
		{
			var value = polyMods[i];
			dirs.push(value.modPath.split("./mods/")[1]);
			loadedMods.push(value);
		}
		framework ??= OPENFL;

		Polymod.init({
			framework: framework,
			modRoot: "./mods/",
			dirs: dirs,
			parseRules: buildParseRules(),
			errorCallback: PolymodErrorHandler.error,
			frameworkParams: {
				assetLibraryPaths: [
					'default' => 'preload',
					'shared' => 'shared',
					'songs' => 'songs',
					'tutorial' => 'tutorial',
					'week1' => 'week1',
					'week2' => 'week2',
					'week3' => 'week3',
					'week4' => 'week4',
					'week5' => 'week5',
					'week6' => 'week6',
					'week7' => 'week7',

				],
				coreAssetRedirect: CORE_FOLDER,
			},
			useScriptedClasses: true,
			loadScriptsAsync: #if html5 true #else false #end
		});

		// forceReloadAssets();
		ModuleManager.reloadOrInitModules();
	}

	public static function createModRoot():Void
	{
		#if sys
		if (sys.FileSystem.exists(MOD_FOLDER))
			sys.FileSystem.createDirectory(MOD_FOLDER);
		#end
	}

	static function buildParseRules():polymod.format.ParseRules
	{
		var output:polymod.format.ParseRules = polymod.format.ParseRules.getDefault();
		// Ensure TXT files have merge support.
		output.addType('txt', TextFileFormat.LINES);
		output.addType('json', TextFileFormat.JSON);
		// Ensure script files have merge support.
		output.addType('hscript', TextFileFormat.PLAINTEXT);
		output.addType('hxs', TextFileFormat.PLAINTEXT);
		output.addType('hxc', TextFileFormat.PLAINTEXT);
		output.addType('hx', TextFileFormat.PLAINTEXT);

		return output;
	}

	public static function forceReloadAssets():Void
	{
		for (i in 0...loadedMods.length)
		{
			var mod = loadedMods[i];
			mod = null;
			loadedMods.remove(mod);
		}
		loadedMods = [];

		Polymod.clearScripts();
		init(OPENFL);
		Polymod.registerAllScriptClasses();
		ModuleManager.reloadOrInitModules();

	
	}
}
