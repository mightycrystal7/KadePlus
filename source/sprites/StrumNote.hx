package sprites;

import flixel.FlxSprite;

/**
 * Represents a note in the strum line.
 */
class StrumNote extends FlxSprite
{
	public var resetAnim:Float = 0;
	public var defaultY:Float = 50;
	public var defaultX:Float = 50;

	/**
	 * Plays the specified animation and centers the offsets and origin.
	 * 
	 * @param anim The name of the animation to play.
	 * @param force Whether to force the animation to play.
	 */
	public function playAnim(anim:String, force:Bool = false)
	{
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
	}

	override function update(elapsed:Float):Void
	{
		if (resetAnim > 0)
		{
			resetAnim -= elapsed;
			if (resetAnim < 0)
			{
				resetAnim = 0;
				playAnim("static");
			}
		}
		super.update(elapsed);
	}
}
