import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Bio
{
	public static var bioStuff:Array<Dynamic> = [
		// Name, Description, Bio save tag, unlocked by default
		// Yes, I am aware that this is a literal copy&paste of achievements.
		// Don't @ me - Ran
		// ALSO, DON'T USE THIS YET UNLESS YOU KNOW WHAT YOU'RE DOING!! IMPLEMENTATION SUCKS AND CRASHES THE GAME - Ran
		[
			"Boyfriend",
			"Just wanting to be with his girlfriend,\nthe two always seem to get in trouble.\n\nBut he doesn't seem to care.",
			'bf', //THESE AREN'T GOING TO BE THE FINAL BIOS!!!!!!!!!!!! I SUCK AT WRITING - ran
			true
		],
		[
			"Girlfriend",
			"Even though she just wants to be with her boyfriend,\nthere always seems to be someone who doesn't want it.\n\nYou might say she's had enough, but in reality she actually doesn't care too much.",
			'gf',
			false
		],
		[
			"Daddy Dearest",
			"A caring and loving father. Albeit, maybe a bit too much.\nLoves to try and murder Boyfriend, apparently.",
			'gf',
			false
		],
		[
			"Skid and Pump",
			"Also known as the Spooky Kids, these kids love to celebrate Halloween.\nEven in the wrong month; but don't say that to them!",
			'spooky',
			false
		],
		[
			"Test",
			"This is a test bio"
			"bf-pixel",
			true
		]
	];

	public static var bioMap:Map<String, Bool> = new Map<String, Bool>();

	public static function unlockBio(name:String):Void
	{
		FlxG.log.add('Got bio "' + name + '"');
		bioMap.set(name, true);
		// FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		// Could be replaced by another sound, but could also disrupt gameplay so...
	}

	public static function isBioUnlocked(name:String)
	{
		if (bioMap.exists(name) && bioMap.get(name)) {
			return true;
		} else if (bioStuff[getBioIndex(name)][3]) {
			return true;
		}
		return false;
	}

	public static function getBioIndex(name:String)
	{
		for (i in 0...bioStuff.length)
		{
			if (bioStuff[i][2] == name)
			{
				return i;
			}
		}
		return -1;
	}

	public static function loadBios():Void
	{
		for (i1 => i2 in bioMap)
		{
			trace('$i1, $i2, MAP');
		}
		for (i in 0...bioStuff.length)
		{
			trace(bioStuff[i] + ', STUFF');
		}
		if (FlxG.save.data != null)
		{
			if (FlxG.save.data.bioMap != null)
			{
				bioMap = FlxG.save.data.bioMap;
			}
			if (FlxG.save.data.biosUnlocked != null)
			{
				FlxG.log.add("Trying to load stuff");
				var savedStuff:Array<String> = FlxG.save.data.biosUnlocked;
				for (i in 0...savedStuff.length)
				{
					bioMap.set(savedStuff[i], true);
				}
			}
		}
	}
}

class AttachedBio extends FlxSprite
{
	public var sprTracker:FlxSprite;

	private var tag:String;

	public function new(x:Float = 0, y:Float = 0, name:String)
	{
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String)
	{
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage()
	{
		if (Bio.isBioUnlocked(tag))
		{
			var name:String = 'icons/' + tag;
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-' + tag; // Older versions of psych engine's support
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-face'; // Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); // Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); // Then load it fr
			var iconOffsets:Array<Float> = [0, 0, 0];
			iconOffsets[0] = (width - 150) / 3;
			iconOffsets[1] = (width - 150) / 3;
			iconOffsets[2] = (width - 150) / 3;
			updateHitbox();

			animation.add('icon', [0, 1, 2], 0, false);
			animation.play('icon');

			antialiasing = ClientPrefs.globalAntialiasing;
			if (tag.endsWith('-pixel'))
			{
				antialiasing = false;
			}
		}
		else
		{
			loadGraphic(Paths.image('lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class BioObject extends FlxSpriteGroup
{
	public var onFinish:Void->Void = null;

	var alphaTween:FlxTween;

	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var bioBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		bioBG.scrollFactor.set();

		var iconName:String = 'icons/' + name;
		if (!Paths.fileExists('images/' + iconName + '.png', IMAGE))
			iconName = 'icons/icon-' + name; // Older versions of psych engine's support
		if (!Paths.fileExists('images/' + iconName + '.png', IMAGE))
			iconName = 'icons/icon-face'; // Prevents crash from missing icon
		var file:Dynamic = Paths.image(name);

		var bioIcon:FlxSprite = new FlxSprite(bioBG.x + 10, bioBG.y + 10);
		bioIcon.loadGraphic(file); // Load stupidly first for getting the file size
		bioIcon.loadGraphic(file, true, Math.floor(bioIcon.width / 3), Math.floor(bioIcon.height)); // Then load it fr

		var iconOffsets:Array<Float> = [0, 0, 0];
		iconOffsets[0] = (bioIcon.width - 150) / 3;
		iconOffsets[1] = (bioIcon.width - 150) / 3;
		iconOffsets[2] = (bioIcon.width - 150) / 3;
		bioIcon.updateHitbox();

		bioIcon.animation.add('icon', [0, 1, 2], 0, false);
		bioIcon.animation.play('icon');

		bioIcon.scrollFactor.set();
		bioIcon.setGraphicSize(Std.int(bioIcon.width * (2 / 3)));
		bioIcon.updateHitbox();

		bioIcon.antialiasing = ClientPrefs.globalAntialiasing;
		if (name.endsWith('-pixel'))
		{
			bioIcon.antialiasing = false;
		}

		add(bioBG);
		add(bioIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if (camera != null)
		{
			cam = [camera];
		}
		alpha = 0;
		bioBG.cameras = cam;
		bioIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {
			onComplete: function(twn:FlxTween)
			{
				alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
					startDelay: 2.5,
					onComplete: function(twn:FlxTween)
					{
						alphaTween = null;
						remove(this);
						if (onFinish != null)
							onFinish();
					}
				});
			}
		});
	}

	override function destroy()
	{
		if (alphaTween != null)
		{
			alphaTween.cancel();
		}
		super.destroy();
	}
}
