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

class SubCharacter extends FlxSprite
{
	// BETA IMPLEMENTATION, DO NOT USE
	// having a lot of trouble with layering with this ;w; - Ran
	public var charParent:Character;

	public override function new(x:Float, y:Float, parent:Character, animName:String, animPrefix:String, animImage:String)
	{
		super(x, y);

		charParent = parent;

		antialiasing = ClientPrefs.globalAntialiasing;
		var library:String = null;

		var spriteType = "sparrow";

		#if MODS_ALLOWED
		var modTxtToFind:String = Paths.modsTxt(animImage);
		var txtToFind:String = Paths.getPath('images/' + animImage + '.txt', TEXT);

		if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
		#else
		if (Assets.exists(Paths.getPath('images/' + animImage + '.txt', TEXT)))
		#end
		{
			spriteType = "packer";
		}

		#if MODS_ALLOWED
		var modAnimToFind:String = Paths.modFolders('images/' + animImage + '/Animation.json');
		var animToFind:String = Paths.getPath('images/' + animImage + '/Animation.json', TEXT);

		if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
		#else
		if (Assets.exists(Paths.getPath('images/' + animImage + '/Animation.json', TEXT)))
		#end
		{
			spriteType = "texture";
		}

		switch (spriteType)
		{
			case "packer":
				frames = Paths.getPackerAtlas(animImage);

			case "sparrow":
				frames = Paths.getSparrowAtlas(animImage);

			case "texture":
				frames = AtlasFrameMaker.construct(animImage);
		}

		setGraphicSize(Std.int(width * charParent.jsonScale));
		updateHitbox();

		flipX = charParent.flipX;

		antialiasing = !charParent.noAntialiasing;
		if (!ClientPrefs.globalAntialiasing)
			antialiasing = false;

		animation.addByPrefix(animName, animPrefix, 24, false);

		FlxG.state.add(this);
	}

	public function playAnim(AnimName:String, Force:Bool = false, ?Reversed:Bool = false, ?Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);
	}

	public var parentOrder:Int = 0;
	public var thisOrder:Int = 0;

	override function update(elapsed:Float)
	{
		parentOrder = FlxG.state.members.indexOf(charParent);
		thisOrder = FlxG.state.members.indexOf(this);
		if (thisOrder != parentOrder - 1)
			FlxG.state.insert(parentOrder, this);
		super.update(elapsed);
	}
}