package mods;

import flixel.FlxG;

class ModuleManager
{
	static var modules:Array<ScriptedModule> = [];
	static var scriptedClasses:Array<Dynamic> = [];

	public static function reloadOrInitModules()
	{
		for (module in modules)
		{
			module = null;
			modules.remove(module);
		}
		for (className in ScriptedModule.listScriptClasses())
		{
			var module:ScriptedModule = ScriptedModule.init(className, className.toLowerCase() + '-' + modules.length);
			if (module != null)
				trace('Loaded Module ${module.name} as "ScriptedModule($className)" successfully.');
			else
			{
				trace('Failed Loaded Module ${module.name} as "ScriptedModule($className)", Null Object Reference. Please check if your script has any errors or missing semicolons or brackets or shit.');
				continue;
			}

			modules.push(module);
		}
		trace('Loaded ${modules.length} Modules.');
	}

	public static function update(elapsed:Float)
	{
		for (moduleIt in modules.keyValueIterator())
			moduleIt.value.update({elapsed: elapsed, stateName: Type.getClassName(Type.getClass(FlxG.state))});
	}

	public static function forEach(func:ScriptedModule->Void)
	{
		for (moduleIt in modules.keyValueIterator())
			func(moduleIt.value);
	}
}
