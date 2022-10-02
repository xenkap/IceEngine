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

class Main extends FlxUIState
{
	var warnText:FlxText;
	public function main():Void
	{
		Lib.current.addChild(new Main());
	}
	public function new()
	{
		super.create();
		print("")
	}
}
