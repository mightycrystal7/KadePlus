package objects;

import flixel.FlxG;
import mods.ModuleManager;
import flixel.FlxGame;

class FunkinGame extends FlxGame
{
	override function update():Void
	{
		super.update();
		ModuleManager.update(FlxG.elapsed);
	}
}
