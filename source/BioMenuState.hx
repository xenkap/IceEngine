package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import Bio;

using StringTools;

class BioMenuState extends MusicBeatState
{
	// IMPLEMENTATION FOR THIS IS REALLY CRAP
	// DONT USE THIS YET UNLESS YOU'RE SMART ENOUGH TO FIX IT!! - Ran
	#if ACHIEVEMENTS_ALLOWED
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;

	private var bioArray:Array<AttachedBio> = [];
	private var bioIndex:Array<Int> = [];
	private var descText:FlxText;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("Bio Menu [BETA]", null);
		#end

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		Bio.loadBios();
		for (i in 0...Bio.bioStuff.length)
		{
			options.push(Bio.bioStuff[i]);
			bioIndex.push(i);
		}

		for (i in 0...options.length)
		{
			var achieveName:String = Bio.bioStuff[bioIndex[i]][2];
			trace(achieveName);
			var optionText:Alphabet = new Alphabet(0, (100 * i) + 210,
				Bio.isBioUnlocked(achieveName) ? Bio.bioStuff[bioIndex[i]][0] : '???', false, false);
			optionText.isMenuItem = true;
			optionText.x += 280;
			optionText.xAdd = 200;
			optionText.targetY = i;
			grpOptions.add(optionText);

			var icon:AttachedBio = new AttachedBio(optionText.x - 105, optionText.y, achieveName);
			icon.sprTracker = optionText;
			bioArray.push(icon);
			add(icon);
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
	}

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

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}

		for (i in 0...bioArray.length)
		{
			bioArray[i].alpha = 0.6;
			if (i == curSelected)
			{
				bioArray[i].alpha = 1;
			}
		}
		if (Bio.isBioUnlocked(Bio.bioStuff[bioIndex[curSelected]][2]))
			descText.text = Bio.bioStuff[bioIndex[curSelected]][1];
		else 
			descText.text = '?';
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
	#end
}
