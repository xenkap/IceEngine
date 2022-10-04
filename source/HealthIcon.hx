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

	public function new(char:String = 'bf', winIcon:Bool, isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char, winIcon);
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
			changeIcon('bf-old', usingWinIcon);
		else
			changeIcon('bf', usingWinIcon);
	}

	var iconVerPath:String;
	private var iconOffsets:Array<Float> = [0, 0];

	public function changeIcon(char:String, hasWinIcon:Bool)
	{
		if (this.char != char)
		{
			usingWinIcon = hasWinIcon;

			var iconDivision:Int = 2;
			if (hasWinIcon)
			{
				iconDivision = 3;
			}

			var name:String = 'icons/' + char;
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-' + char; // Older versions of psych engine's support
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-face'; // Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); // Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / iconDivision), Math.floor(height)); // Then load it fr

			iconOffsets[0] = (width - 150) / iconDivision;
			iconOffsets[1] = (width - 150) / iconDivision;
			updateHitbox();

			if (hasWinIcon)
				animation.add(char, [0, 1, 2], 0, false, isPlayer);
			else
				animation.add(char, [0, 1], 0, false, isPlayer);
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
