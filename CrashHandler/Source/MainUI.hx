package;

import flixel.addons.ui.FlxUIState;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import openfl.events.UncaughtErrorEvent;

class MainUI extends FlxUIState
{
	var warnText:FlxText;
	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Sup bro, looks like the game crashed. \n Press ENTER to restart the game.",
		32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}
    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
