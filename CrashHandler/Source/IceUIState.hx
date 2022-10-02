package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxBasic;

class IceUIState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return null;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();

		if(!skip) {
			// Legit do nothing
		}
		FlxTransitionableState.skipNextTransOut = false;
	}
	
	#if (VIDEOS_ALLOWED && windows)
	override public function onFocus():Void
	{
		FlxVideo.onFocus();
		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		FlxVideo.onFocusLost();
		super.onFocusLost();
	}
	#end

	override function update(elapsed:Float)
	{
		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	public static function switchState(nextState:FlxState) {
		// No Custom made Trans in
		var curState:Dynamic = FlxG.state;
		var leState:IceUIState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			if(nextState == FlxG.state) {
				FlxG.resetState();
				//trace('resetted');
			} else {
				FlxG.switchState(nextState);
				//trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

	public static function resetState() {
		IceUIState.switchState(FlxG.state);
	}

	public static function getState():IceUIState {
		var curState:Dynamic = FlxG.state;
		var leState:IceUIState = curState;
		return leState;
	}
}
