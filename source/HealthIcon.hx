package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	
	public var usingWinIcon:Bool = false;

	public function new(char:String = 'bf',/* winIcon:Bool,*/ isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char/*, winIcon*/);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon()
	{
		if (isOldIcon = !isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon('bf');
	}

	var iconVerPath:String;
	private var iconOffsets:Array<Float> = [0, 0];
	public var hasWinIcon:Bool = false;
	public var iconDivision:Int = 2;

	public function changeIcon(char:String/*, hasWinIcon:Bool*/)
	{
		if (this.char != char)
		{
			// usingWinIcon = hasWinIcon;

			// var iconDivision:Int = 2;
			// if (hasWinIcon)
			// {
			// 	iconDivision = 3;
			// }

			var name:String = 'icons/' + char;
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-' + char; // Older versions of psych engine's support
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-face'; // Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file, false); // Load stupidly first for getting the file size

			var winCheck1 = (width / 2) - height;
			if (winCheck1 < 0) winCheck1 = winCheck1 * -1;
			var winCheck2 = (width / 3) - height;
			if (winCheck2 < 0) winCheck2 = winCheck2 * -1;

			if (winCheck2 < winCheck1) {
				hasWinIcon = true;
				iconDivision = 3;
			}

			loadGraphic(file, true, Math.floor(width / iconDivision), Math.floor(height)); // Then load it fr

			iconOffsets[0] = (width - 150) / iconDivision;
			iconOffsets[1] = (width - 150) / iconDivision;
			updateHitbox();

			animation.add(char, [0, 1, iconDivision - 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if (char.endsWith('-pixel'))
			{
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String
	{
		return char;
	}
}
