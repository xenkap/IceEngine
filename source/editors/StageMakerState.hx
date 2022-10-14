package editors;

#if desktop
import Discord.DiscordClient;
#end
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.Json;
import Character;
import flixel.system.debug.interaction.tools.Pointer.GraphicCursorCross;
import lime.system.Clipboard;
import flixel.animation.FlxAnimation;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

/**
	*DEBUG MODE
 */
class StageMakerState extends MusicBeatState
{
	var bgLayer:FlxTypedGroup<BGSprite>;
	var bgMap:Map<String, BGSprite>;
	var charLayer:FlxTypedGroup<Character>;

	public function new()
	{
		super();
	}

	var UI_box:FlxUITabMenu;

	private var camEditor:FlxCamera;
	private var camHUD:FlxCamera;
	private var camMenu:FlxCamera;

	var cameraFollowPointer:FlxSprite;
	var camFollow:FlxObject;

	var imageName:FlxUIInputText;
	var imagePath:FlxUIInputText;

	override function create()
	{
		// FlxG.sound.playMusic(Paths.music('breakfast'), 0.5);

		camEditor = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camMenu = new FlxCamera();
		camMenu.bgColor.alpha = 0;

		FlxG.cameras.reset(camEditor);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camMenu);
		FlxCamera.defaultCameras = [camEditor];

		var tabs = [
			{name: 'Main Tab', label: 'Main Tab'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.cameras = [camMenu];

		UI_box.resize(250, 120);
		UI_box.x = FlxG.width - 275;
		UI_box.y = 25;
		UI_box.scrollFactor.set();

		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Main Tab";

		imageName = new FlxUIInputText(15, 30, 200, 'stageFront', 8);
		imagePath = new FlxUIInputText(imageName.x, imageName.x + 50, 200, 'stageFront', 8);
		var addImage:FlxButton = new FlxButton(imageName.x, imagePath.y + 50, "Add Image", function()
		{
			trace(imagePath.text + ' ' + imageName.text);
			var bgFunny:BGSprite = new BGSprite(imagePath.text);
			bgLayer.add(bgFunny);
			bgMap.set(imageName.text, bgFunny);
		});

		tab_group.add(new FlxText(imageName.x, imageName.y - 18, 0, 'Image Name:'));
		tab_group.add(imageName);
		tab_group.add(new FlxText(imageName.x, imagePath.y - 18, 0, 'Image Path:'));
		tab_group.add(imagePath);
		tab_group.add(addImage);
		UI_box.addGroup(tab_group);

		bgLayer = new FlxTypedGroup<BGSprite>();
		add(bgLayer);
		charLayer = new FlxTypedGroup<Character>();
		add(charLayer);
		add(UI_box);

		// var pointer:FlxGraphic = FlxGraphic.fromClass(GraphicCursorCross);
		// cameraFollowPointer = new FlxSprite().loadGraphic(pointer);
		// cameraFollowPointer.setGraphicSize(40, 40);
		// cameraFollowPointer.updateHitbox();
		// cameraFollowPointer.color = FlxColor.WHITE;
		// add(cameraFollowPointer);

		// var tipTextArray:Array<String> = "E/Q - Camera Zoom In/Out
		// \nR - Reset Camera Zoom
		// \nJKLI - Move Camera
		// \nT - Reset Current Offset
		// \nHold Shift to Move 10x faster\n".split('\n');

		// for (i in 0...tipTextArray.length - 1)
		// {
		// 	var tipText:FlxText = new FlxText(FlxG.width - 320, FlxG.height - 15 - 16 * (tipTextArray.length - i), 300, tipTextArray[i], 12);
		// 	tipText.cameras = [camHUD];
		// 	tipText.setFormat(null, 12, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
		// 	tipText.scrollFactor.set();
		// 	tipText.borderSize = 1;
		// 	add(tipText);
		// }

		FlxG.camera.follow(camFollow);

		FlxG.mouse.visible = true;

		super.create();
	}
}
