package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxSave;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.FlxGraphic;
import lime.utils.Assets;
import haxe.Json;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = [
		'Note Colors',
		'Controls',
		'Adjust Delay and Combo',
		'Graphics',
		'Visuals and UI',
		'Gameplay'
	];
	private var grpOptions:FlxTypedGroup<HitboxText>;

	private var gradientBG:FlxSprite;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String)
	{
		switch (label)
		{
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		gradientBG = FlxGradient.createGradientFlxSprite(Math.floor(FlxG.width * 0.2), FlxG.height, [FlxColor.BLACK, FlxColor.TRANSPARENT], 1, 0);
		gradientBG.updateHitbox();
		gradientBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(gradientBG);

		grpOptions = new FlxTypedGroup<HitboxText>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:HitboxText = new HitboxText(60, 60 + (50 * i), 0, options[i], 36);
			optionText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, LEFT);
			grpOptions.add(optionText);
		}

		for (item in grpOptions.members)
		{
			item.hitbox = {
				x: item.x,
				y: item.y,
				width: grpOptions.members[2].width + 30,
				height: item.height
			}
		}

		changeSelection();
		ClientPrefs.saveSettings();

		FlxG.mouse.visible = true;

		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();

		for (item in grpOptions.members)
		{
			FlxTween.tween(item, {'offset.x': 0.0, alpha: 1.0}, 0.15, {ease: FlxEase.quadOut});
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			allowAction = true;
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (allowAction)
		{
			if (controls.UI_UP_P)
			{
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				changeSelection(1);
			}

			for (item in grpOptions.members)
			{
				if (!FlxG.mouse.justMoved)
					break;
				
				if (curSelected == grpOptions.members.indexOf(item))
					continue;

				var checkX:Bool = (FlxG.mouse.screenX >= item.hitbox.x && FlxG.mouse.screenX <= item.hitbox.x + item.hitbox.width);
				var checkY:Bool = (FlxG.mouse.screenY >= item.hitbox.y && FlxG.mouse.screenY <= item.hitbox.y + item.hitbox.height);

				if (checkX && checkY)
				{
					curSelected = grpOptions.members.indexOf(item);
					changeSelection();
					break;
				}
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT || FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.justPressed)
				{
					var checkX:Bool = (FlxG.mouse.screenX >= grpOptions.members[curSelected].hitbox.x
						&& FlxG.mouse.screenX <= grpOptions.members[curSelected].hitbox.x + grpOptions.members[curSelected].hitbox.width);
					var checkY:Bool = (FlxG.mouse.screenY >= grpOptions.members[curSelected].hitbox.y
						&& FlxG.mouse.screenY <= grpOptions.members[curSelected].hitbox.y + grpOptions.members[curSelected].hitbox.height);

					if (!checkX || !checkY)
						return;
				}

				allowAction = false;

				for (item in grpOptions.members)
				{
					FlxTween.tween(item, {'offset.x': 10, alpha: 0.0}, 0.15, {ease: FlxEase.quadOut});
				}

				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					openSelectedSubstate(options[curSelected]);
				});
			}
		}
	}

	private var allowAction:Bool = true;

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.color = FlxColor.fromRGBFloat(0.75, 0.75, 0.75);
			if (item.targetY == 0)
			{
				item.color = FlxColor.WHITE;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}

class HitboxText extends FlxText
{
	public var hitbox:
		{
			x:Float,
			y:Float,
			width:Float,
			height:Float
		};
	public var targetY:Int = 0;
}
