package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import sys.FileSystem;
import sys.io.File;

class LoadingSubState extends MusicBeatSubstate
{
	#if mobile
	addVirtualPad(LEFT_FULL, A_B);
	#end

	//if you want to remove it at some moment use
	#if mobile
	removeVirtualPad();
	#end

	//if you want it to have a camera
	#if mobile
	addPadCamera();
	#end

	//in states, these need to be added before super.create();
	//in substates, in fuction new at the last line add these

	//on Playstate.hx after all of the
	//obj.cameras = [...];
	//things, add
	#if mobile
	addMobileControls();
	#end

	//if you want to remove it at some moment use
	#if mobile
	removeMobileControls();
	#end

	//to make the controls visible the code is
	#if mobile
	mobileControls.visible = true;
	#end

	//to make the controls invisible the code is
	#if mobile
	mobileControls.visible = false;
	#end
	var time = FlxG.random.int(1, 2);
	var unPauseTimer:FlxTimer;

	// public static var songName:String = '';
	var funkay:FlxSprite;

	public function new()
	{
		super();
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d);
		bg.alpha = 0;
		FlxTween.tween(bg, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut, type: ONESHOT, startDelay: 0.1});
		add(bg);

		var imgVer = FlxG.random.int(1, 3);
		funkay = new FlxSprite(0, 0).loadGraphic(Paths.getPath('images/loadingscreens/funkay$imgVer.png', IMAGE));
		funkay.setGraphicSize(0, FlxG.height);
		funkay.alpha = 0;
		FlxTween.tween(funkay, {alpha: 1}, 0.3, {ease: FlxEase.quadInOut, type: ONESHOT, startDelay: 0.1});
		funkay.updateHitbox();
		funkay.antialiasing = ClientPrefs.globalAntialiasing;
		add(funkay);
		funkay.scrollFactor.set();
		funkay.screenCenter();

		trace(time + " seconds");

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			// LoadingState.loadAndSwitchState(new PlayState(), true);
			close();
		});
	}

	override function update(elapsed:Float)
	{
	}
}
