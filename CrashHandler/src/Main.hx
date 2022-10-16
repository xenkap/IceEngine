package;

import haxe.ui.HaxeUIApp;
import haxe.ui.components.Button;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.ComponentBuilder;
import sys.io.File;
import sys.io.Process;

class Main
{
	/** 
	 * "Borrowed" from Izzy Engine :troll:
	 * and "Borrowed" from Indie Cross :troll:
	 */
	static final quotes:Array<String> = [
		"Well Shit.",
		"//Broken Function Please fix",
		"You can no longer play as boyfriend.",
		"[PLAY WII CRASH SOUND]",
		"Oh fiddle sticks what now.",
		"Haxe is the worst :D",
		"Ice flooring nice.",
		"Hello is this the imposter from among us?",
		"Oops my bad",
		"Unable to find Imposter.png.",
		"//Memory Leak?",
		"Lets try that again.",
		"*click* noice",
		"NOW'S YOUR CHANCE TO BE A [BIG SHOT]",
		"Booo...",
		"FNF: Now with more crashes!",
		"line 101: invalid crash (Imposter.hx)",
		"oh shit here we go again.",
		"                                                   sus"
	];

	public static function main()
	{
		var args:Array<String> = Sys.args();

		if (args[0] == null)
			Sys.exit(1);
		else
		{
			var path:String = args[0];
			var contents:String = File.getContent(path);
			var split:Array<String> = contents.split("\n");

			var app = new HaxeUIApp();

			app.ready(function()
			{
				var mainView:Component = ComponentBuilder.fromFile("assets/main-view.xml");
				app.addComponent(mainView);

				var messageLabel:Label = mainView.findComponent("message-label", Label);
				messageLabel.text = '"' + quotes[Std.random(quotes.length)] + '"' + "\nUnfortunately, Ice Engine has crashed.";
				messageLabel.percentWidth = 100;
				messageLabel.textAlign = "center";

				var callStackLabel:Label = mainView.findComponent("call-stack-label", Label);
				callStackLabel.text = "";
				for (i in 0...split.length - 4)
				{
					if (i == split.length - 5)
						callStackLabel.text += split[i];
					else
						callStackLabel.text += split[i] + "\n";
				}

				var crashReasonLabel:Label = mainView.findComponent("crash-reason-label", Label);
				crashReasonLabel.text = "";
				for (i in split.length - 3...split.length - 1)
				{
					if (i == split.length - 2)
						crashReasonLabel.text += split[i];
					else
						crashReasonLabel.text += split[i] + "\n";
				}

				mainView.findComponent("view-crash-dump-button", Button).onClick = function(_)
				{
					#if windows
					Sys.command("start", [path]);
					#elseif linux
					Sys.command("xdg-open", [path]);
					#end
				};

				mainView.findComponent("restart-button", Button).onClick = function(_)
				{
					#if windows
					new Process("IceEngine.exe", []);
					#elseif linux
					new Process("./IceEngine.exe", []);
					#end

					Sys.exit(0);
				};

				mainView.findComponent("close-button", Button).onClick = function(_)
				{
					Sys.exit(0);
				};

				app.start();
			});
		}
	}
}