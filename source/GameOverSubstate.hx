package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'bf-mii':
				daBf = 'bf-mii';
			case 'bf-austin':
				daBf = 'bf-austin';
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);
		if (daBf == 'bf-austin')
			bf.flipX = false;
		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	var startVibin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix), 0.2);
			startVibin = true;
			switch (PlayState.SONG.player2) {
				case 'eteled1':
					var random = FlxG.random.int(1, 15);
					FlxG.sound.play(Paths.sound("EteledLineFailDOP" + random, 'eteled'));
				case 'eteled2':
					var random = FlxG.random.int(1, 12);
					FlxG.sound.play(Paths.sound("EteledLineFailMAD" + random, 'eteled'));
				case 'eteled3':
					var random = FlxG.random.int(1, 12);
					FlxG.sound.play(Paths.sound("EteledLineFailMAD" + random, 'eteled'));
				case 'austin':
					var random = FlxG.random.int(1, 34);
					FlxG.sound.play(Paths.sound("AuD" + random, 'eteled'));
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (startVibin && !isEnding)
		{
			bf.playAnim('deathLoop', true);
		}
		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			PlayState.startTime = 0;
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
#if android
	addVirtualPad(FULL, A_B);
        #end

	//if you want it to have a camera
        #if android
	addPadCamera();
        #end

	//in states, those needs to be added before super.create();
	//in substates, in fuction new at the last line add those

	//on Playstate.hx after all
	//obj.camera = ...
	//add
        #if android
	addAndroidControls();
        #end

	//to make the controls visible the code is
	#if android
	androidc.visible = true;
	#end

	//to make the controls invisible the code is
	#if android
	androidc.visible = false;
	#end
