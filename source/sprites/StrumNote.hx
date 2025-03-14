package sprites;

import flixel.FlxSprite;

/**
 * Represents a note in the strum line.
 */
class StrumNote extends FlxSprite
{
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
}
