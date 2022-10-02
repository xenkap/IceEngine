package;

import flixel.math.FlxPoint;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class BioSprite extends FlxSprite
{
	// IMPLEMENTATION FOR THIS IS REALLY CRAP AND LAST I CHECKED IT CRASHED SO
	// DONT USE THIS YET UNLESS YOU'RE SMART ENOUGH TO FIX IT!! - Ran
	var alrClick:Bool = false;
	public var bioTag:String = '';

	public function new(x:Float = 0, y:Float = 0, ?tag:String = 'null')
	{
		super(x, y);
		bioTag = tag;
	}

	var mousePos:FlxPoint;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Std.isOfType(FlxG.state, PlayState) && bioTag != 'null' && visible)
		{
			mousePos = FlxG.mouse.getScreenPosition();
			if (!alrClick && FlxG.mouse.justPressedRight
				&& mousePos.x >= x && mousePos.x <= (x + width)
				&& mousePos.y >= y && mousePos.y <= (y + height))
			{
				alrClick = true;
				if (!Bio.isBioUnlocked(bioTag))
				{
					trace('CLICKED!!!!!!');
				}
			} else {
				if (FlxG.mouse.justPressedRight)
				{
					if (alrClick)
						trace('ALREADY CLICKED!!!!!!');
					else 
						trace('TOO FAR OFF!!!!!!');
				}
			}	
		}
	}
}
