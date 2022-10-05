package;

import flixel.FlxSubState;

class ButtonRemapSubstate extends FlxSubState
{
	#if mobile
	addVirtualPad(LEFT_FULL, A_B);
	mobileControls.visible = true;
	addMobileControls();
	#end
	public function new()
	{
		super();
	}
}
