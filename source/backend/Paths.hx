package backend;

import openfl.display.BitmapData;
import openfl.Assets;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;
	public static var localTrackedAssets:Array<String> = [];

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function clearStoredMemory()
	{
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null)
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
				bitmapCache.remove(key);
			}
		}

		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		#if !html5 openfl.Assets.cache.clear("songs"); #end
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function luaImage(key:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline public static function dumpAndRemoveBitmaps()
	{
		for (bitmapKey in bitmapCache.keys())
		{
			@:privateAccess
			if (FlxG.bitmap._cache.exists(bitmapKey))
			{
				var keyGraphic = bitmapCache.get(bitmapKey);
				var keyBitmap = keyGraphic.bitmap;
				Assets.cache.removeBitmapData(bitmapKey);
				keyGraphic.destroy();
				keyGraphic = null;
				FlxG.bitmap._cache.remove(bitmapKey);
			}
		}
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		if (key == "freakyMenu"
			&& (Date.now().getDay() == 1 || Date.now().getDay() == 2)
			&& Date.now().getMonth() == 3) //  0: january 1:february, 2: march, 3: april
			key = "yeahyeahyeah";
		if (key == "freakyMenu"
			&& (Date.now().getDay() == 29 || Date.now().getDay() == 2)
			&& Date.now().getMonth() == 4) //  0: january 1:february, 2: march, 3: april
			key = "birthday";

		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	public static var bitmapCache:Map<String, FlxGraphic> = new Map();

	inline static public function cacheBitmap(key:String, ?library:String)
	{
		var path = img(key, library);
		if (bitmapCache.exists(path))
			return bitmapCache.get(path);
		if (Assets.exists(path))
		{
			var graphic = FlxG.bitmap.add(path);
			graphic.bitmap.disposeImage();

			graphic.destroyOnNoUse = false;
			graphic.persist = true;
			bitmapCache.set(path, graphic);
			return graphic;
		}
		return null; // no image found, haxeflixel logo time
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		var bitmap = cacheBitmap(key, library);

		return bitmap;
	}

	inline static public function img(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
