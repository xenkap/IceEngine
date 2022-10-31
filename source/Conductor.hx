package;

import Song.SwagSong;
import flixel.FlxG;

/**
 * ...
 * @author
 */
typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor
{
	public static var bpm:Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var songPosition:Float = 0;
	public static var songLength:Float = 0;
	public static var lastSongPos:Float;
	public static var offset:Float = 0;

	// public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (ClientPrefs.safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new()
	{
	}

	public static function judgeNote(note:Note, delay:Float = 0, windowName:String = "")
	{
		// tryna do MS based judgment due to popular demand
		var diff:Float = note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset;
		var timingWindows:Array<Int> = [ClientPrefs.sickWindow, ClientPrefs.goodWindow, ClientPrefs.badWindow];
		var windowNames:Array<String> = ['sick', 'good', 'bad'];
		var delayRate:String = '';
		{
			if (diff > Conductor.safeZoneOffset * 0.1)
			{
				delayRate = "early";
			}
			else if (diff < Conductor.safeZoneOffset * -0.1)
			{
				delayRate = "late";
			}
		}

		var diffAbs = Math.abs(diff);

		for (i in 0...timingWindows.length) // based on 4 timing windows, will break with anything else
		{
			if (diffAbs <= timingWindows[Math.round(Math.min(i, timingWindows.length - 1))])
			{
				return [windowNames[i], delayRate, '' + Math.round(diff * 100) / 100];
			}
		}
		return ['shit', delayRate, '' + Math.round(diff * 100) / 100];
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}
