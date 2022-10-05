package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class LatencyState extends FlxState
{
	#if mobile
	addVirtualPad(LEFT_FULL, A_B);
	#end

	//if you want to remove it at some moment use
	#if mobile
	removeVirtualPad();
	#end

	//if you want it to have a camera
	#if mobile
	addPadCamera();
	#end

	//in states, these need to be added before super.create();
	//in substates, in fuction new at the last line add these

	//on Playstate.hx after all of the
	//obj.cameras = [...];
	//things, add
	#if mobile
	addMobileControls();
	#end

	//if you want to remove it at some moment use
	#if mobile
	removeMobileControls();
	#end

	//to make the controls visible the code is
	#if mobile
	mobileControls.visible = true;
	#end

	//to make the controls invisible the code is
	#if mobile
	mobileControls.visible = false;
	#end
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;

	override function create()
	{
		FlxG.sound.playMusic(Paths.sound('soundTest'));

		noteGrp = new FlxTypedGroup<Note>();
		add(noteGrp);

		for (i in 0...32)
		{
			var note:Note = new Note(Conductor.crochet * i, 1);
			noteGrp.add(note);
		}

		offsetText = new FlxText();
		offsetText.screenCenter();
		add(offsetText);

		strumLine = new FlxSprite(FlxG.width / 2, 100).makeGraphic(FlxG.width, 5);
		add(strumLine);

		Conductor.changeBPM(120);

		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + Conductor.offset + "ms";

		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			Conductor.offset += 1 * multiply;
		if (FlxG.keys.justPressed.LEFT)
			Conductor.offset -= 1 * multiply;

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();

			FlxG.resetState();
		}

		noteGrp.forEach(function(daNote:Note)
		{
			daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = strumLine.x + 30;

			if (daNote.y < strumLine.y)
				daNote.kill();
		});

		super.update(elapsed);
	}
}
