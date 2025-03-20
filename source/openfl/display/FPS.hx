package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.FlxG;
import flixel.math.FlxMath;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end
#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		if(!FlxG.save.data.nofps)
			defaultTextFormat = new TextFormat('Poterski HND CE Bold', 16, color);	
		else
			defaultTextFormat = new TextFormat('Poterski HND CE Bold', 18, color);	
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}


	var lastUpdate:Float = 0;

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);
    
		// Only update every 16ms (~60 FPS)
		if (currentTime - lastUpdate >= 16) {
			lastUpdate = currentTime;

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount /*&& visible*/)
		{
			if (!FlxG.save.data.nofps) {
				text = "FPS: " + currentFPS;
				
				#if openfl
				var memoryMegas:Float = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
				text += "\nMemory: " + memoryMegas + " MB";
				#end
	
				text += "\nKE v1.4.2c";
				text += "\nKE+ v1.0";
	
				textColor = (memoryMegas > 3000 || currentFPS <= FlxG.save.data.fps / 2) ? 0xFFFF0000 : 0xFFFFFFFF;
	
				#if (gl_stats && !disable_cffi && (!html5 || !canvas))
				text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
				text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
				text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
				#end
	
				text += "\n";
			} else {
				text = "Kade Engine Plus 1.0";
			}

			//textColor = 0xFFFFFFFF;
		}

		cacheCount = currentCount;
	}
}
}
