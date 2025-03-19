package mods;

import mods.events.*;

class Module
{
	public var name:String;

	public function new(name:String)
	{
		this.name = name;
	}

	public function update(event:UpdateEvent)
	{
	}

	public function onCreate(event:CreateEvent)
	{
	}

	public function onStateDestroy(event:StateDestroyEvent)
	{
	}

	public function onStateSwitch(event:StateSwitchEvent)
	{
	}

	public function onStateSwitchPre(event:StateSwitchPre)
	{
	}

	public function onStateSwitchPost(event:StateSwitchPostEvent)
	{
	}

	public function onBeatHit(event:BeatHitEvent)
	{
	}

	public function onStepHit(event:StepHitEvent)
	{
	}

	public function NoteHit(event:NoteHitEvent)
	{
	}

	public function toString():String
		return 'Module($name)';
}
