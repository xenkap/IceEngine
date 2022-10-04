package;

import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CharacterFile =
{
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;
	var win_icons:Bool;
	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;
	var kapi_held:Bool;
	var trail_color:Array<Int>;
}

typedef AnimArray =
{
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
	var unique:String;
}

class Character extends BioSprite
{
	var foePlay:Bool = ClientPrefs.getGameplaySetting('foeplay', false);

	public var curAnimation:String = '';
	public var animFinished:Bool = false;

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = DEFAULT_CHARACTER;

	public var colorTween:FlxTween;
	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; // Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; // Character use "danceLeft" and "danceRight" instead of "idle"

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];

	public var hasWinIcons:Bool = true;
	public var kapiHeld:Bool = false;
	public var trailColor:Array<Int> = [0, 0, 0];

	public var hasMissAnimations:Bool = false;

	// Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];

	public var uniqueAnims:Map<String, SubCharacter> = new Map<String, SubCharacter>();
	public var hasUnique:Bool = false;

	public static var DEFAULT_CHARACTER:String = 'bf'; // In case a character is missing, it will use BF on its place

	public var playAnimFrame:Int = 0;
	public var playAnimName:String = '';

	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false, ?isOpponent:Bool = false)
	{
		super(x, y/*, character*/);

		#if (haxe >= "4.0.0")
		animOffsets = new Map();
		#else
		animOffsets = new Map<String, Array<Dynamic>>();
		#end

		curCharacter = character;

		this.isPlayer = isPlayer;
		antialiasing = ClientPrefs.globalAntialiasing;
		var library:String = null;
		switch (curCharacter)
		{
			// case 'your character name in case you want to hardcode them instead':

			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path))
				{
					path = Paths.getPreloadPath(characterPath);
				}

				if (!FileSystem.exists(path))
				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path))
				#end
				{
					path = Paths.getPreloadPath('characters/' + DEFAULT_CHARACTER + '.json');
					// If a character couldn't be found, change him to BF just to prevent a crash
				}

				#if MODS_ALLOWED
				var rawJson = File.getContent(path);
				#else
				var rawJson = Assets.getText(path);
				#end

				var json:CharacterFile = cast Json.parse(rawJson);
				var spriteType = "sparrow";
				// sparrow
				// packer
				// texture
				#if MODS_ALLOWED
				var modTxtToFind:String = Paths.modsTxt(json.image);
				var txtToFind:String = Paths.getPath('images/' + json.image + '.txt', TEXT);

				// var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				// var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();

				if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '.txt', TEXT)))
				#end
				{
					spriteType = "packer";
				}

				#if MODS_ALLOWED
				var modAnimToFind:String = Paths.modFolders('images/' + json.image + '/Animation.json');
				var animToFind:String = Paths.getPath('images/' + json.image + '/Animation.json', TEXT);

				// var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				// var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();

				if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '/Animation.json', TEXT)))
				#end
				{
					spriteType = "texture";
				}

				switch (spriteType)
				{
					case "packer":
						frames = Paths.getPackerAtlas(json.image);

					case "sparrow":
						frames = Paths.getSparrowAtlas(json.image);

					case "texture":
						frames = AtlasFrameMaker.construct(json.image);
				}
				imageFile = json.image;

				if (json.scale != 1)
				{
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				hasWinIcons = json.win_icons;
				kapiHeld = json.kapi_held;
				trailColor = json.trail_color;

				flipX = !!json.flip_x;
				originalFlipX = flipX;
				if (!foePlay)
				{
					if (isPlayer)
						flipX = !flipX;
				}
				else if (isOpponent)
				{
					flipX = !flipX;
				}

				if (json.no_antialiasing)
				{
					antialiasing = false;
					noAntialiasing = true;
				}

				if (json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				antialiasing = !noAntialiasing;
				if (!ClientPrefs.globalAntialiasing)
					antialiasing = false;

				animationsArray = json.animations;
				if (animationsArray != null && animationsArray.length > 0)
				{
					for (anim in animationsArray)
					{
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; // Bruh
						var animIndices:Array<Int> = anim.indices;
						var animUnique:String = anim.unique;
						if (animUnique == null || animUnique == '')
						{
							if (animIndices != null && animIndices.length > 0)
							{
								animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
							}
							else
							{
								animation.addByPrefix(animAnim, animName, animFps, animLoop);
							}
	
							if (anim.offsets != null && anim.offsets.length > 1)
							{
								addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
							}
						}
						else
						{
							// BETA IMPLEMENTATION, DO NOT USE
							// having a lot of trouble with layering with this ;w; - Ran
							hasUnique = true;
							var uniqueAnim:SubCharacter;
							if (anim.offsets != null && anim.offsets.length > 1)
								uniqueAnim = new SubCharacter(x + anim.offsets[0], y + anim.offsets[1], this, animAnim, animName, animUnique);
							else
								uniqueAnim = new SubCharacter(x, y, this, animAnim, animName, animUnique);
							uniqueAnims.set(animAnim, uniqueAnim);
						}
					}
				}
				else
				{
					quickAnimAdd('idle', 'BF idle dance');
				}
				// trace('Loaded file to character ' + curCharacter);
		}

		if (animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') || animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss'))
			hasMissAnimations = true;
		recalculateDanceIdle();
		dance();
	}
	
	var animationList:Array<String> = ['cheer', 'hairFall', 'hairFall-right', 'scared'];

	override function update(elapsed:Float)
	{
		if (Std.isOfType(FlxG.state, PlayState)) {
			if (animation.curAnim.finished)
				animFinished = true;
			else
				animFinished = false;

			if (hasUnique == true)
			{
				for (animID => animChar in uniqueAnims)
				{
					if (animChar.animation.curAnim != null && !animChar.animation.curAnim.finished)
						animFinished = false;
				}
			}
		}
		
		if (!debugMode && animation.curAnim != null)
		{
			if (heyTimer > 0)
			{
				heyTimer -= elapsed;
				if (heyTimer <= 0)
				{
					if (specialAnim
						&& animationList.indexOf(playAnimName) != -1)
					{
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			}
			else if (specialAnim && animFinished)
			{
				specialAnim = false;
				dance();
			}

			if (!isPlayer)
			{
				if (playAnimName.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * 0.001 * singDuration)
				{
					dance();
					holdTimer = 0;
				}
			}
		}

		if(animFinished)
		{
			if (animation.getByName(animation.curAnim.name + '-loop') != null || uniqueAnims.exists(playAnimName + '-loop'))
			{
				playAnim(animation.curAnim.name + '-loop');
			}
		}
		super.update(elapsed);
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false)
	{
		// if (animation.getByName(animation.curAnim.name + '-end') != null || uniqueAnims.exists(playAnimName + '-end'))
		// {
		// 	playAnim(animation.curAnim.name + '-end');
		// }
		// else {
		if (forced || !debugMode && !specialAnim)
		{
			if (danceIdle)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight' + idleSuffix);
				else
					playAnim('danceLeft' + idleSuffix);
				if (PlayState.hairBlowedLast == true)
				{
					idleSuffix = '';
					recalculateDanceIdle();
					PlayState.hairBlowedLast = false;
				}
			}
			else if (animation.getByName('idle' + idleSuffix) != null)
			{
				playAnim('idle' + idleSuffix);
			}
		}
		// }
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animFinished = false;
		specialAnim = false;
		playAnimFrame = Frame;
		playAnimName = AnimName;

		//trace('$playAnimName $playAnimFrame $animFinished');

		if (!uniqueAnims.exists(AnimName))
		{
			for (animChar => subChar in uniqueAnims)
			{
				subChar.visible = false;
			}
			if (hasUnique)
				visible = true;
			animation.paused = false;
			animation.play(AnimName, Force, Reversed, playAnimFrame);
		} else {
			for (animChar => subChar in uniqueAnims)
			{
				if (animChar == AnimName)
					subChar.visible = true;
				else
					subChar.visible = false;
			}
			animation.play(AnimName, true, Reversed, playAnimFrame);
			animation.paused = true;
			visible = false;
			uniqueAnims.get(AnimName).animation.play(AnimName, Force, Reversed, playAnimFrame);
		}

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter.startsWith('gf'))
		{
			if (AnimName == 'singLEFT' || AnimName == 'hairBlow')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT' || AnimName == 'hairBlow-right')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public var danceEveryNumBeats:Int = 2;

	private var settingCharacterUp:Bool = true;

	public function recalculateDanceIdle()
	{
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = (animation.getByName('danceLeft' + idleSuffix) != null && animation.getByName('danceRight' + idleSuffix) != null);

		if (settingCharacterUp)
		{
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		}
		else if (lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if (danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
		settingCharacterUp = false;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
	{
		animation.addByPrefix(name, anim, 24, false);
	}
}
