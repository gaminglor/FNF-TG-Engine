package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	
	var languageList:Array<String> = ['English', 'Chinese'];
	var languageChoose:Int = 0;

	var warnText:FlxText;
	var languageText:FlxText;
	var velocityBG:FlxBackdrop;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.ORANGE);
		add(bg);

		velocityBG = new FlxBackdrop(Paths.image('velocity_background'));
		velocityBG.velocity.set(50, 50);
		add(velocityBG);

		#if android
			warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			Use Left/Right to choose a language.\n
			Android ver need instal mod in .TG Engine Files/mods.\n
			This Mod contains some flashing lights!\n
			Press A to disable them now or go to Options Menu.\n
			Press B to ignore this message.\n
			You've been warned!",
			32);
		#else
			warnText = new FlxText(0, 150, FlxG.width,
			"Hey, watch out!\n
			Use Left/Right to choose a language\n
			This Mod contains some flashing lights!\n
			Press ENTER to disable them now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!",
			32);
		#end
		warnText.setFormat(Paths.font('syht.ttf'), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.borderSize = 2.4;
		warnText.screenCenter(X);
		warnText.y = 0;
		add(warnText);
		
		languageText = new FlxText(0, 690, FlxG.width, 'Language: ' + ClientPrefs.language, 32);
		languageText.setFormat(Paths.font('vcr.ttf'), 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		languageText.borderSize = 2.4;
		languageText.screenCenter(X);
		languageText.y = 650;
		add(languageText);
		
                #if android
                addVirtualPad(LEFT_RIGHT, A_B);
                #end
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_LEFT_P)
			languageChoose += 1;
		if (controls.UI_RIGHT_P)
			languageChoose += -1;
			
		if (languageChoose < 0)
			languageChoose = languageList.length - 1;
		if (languageChoose >= languageList.length)
			languageChoose = 0;
			
		if(ClientPrefs.language == 'Chinese') {
			warnText.text = "嘿，看这里\n当然，这里有闪光特效\n点击A来关闭闪光特效.\n按下B忽略此信息.\n我已经警告过你了!";
		} else {
			warnText.text = "Hey, watch out!\nThis Mod contains some flashing lights!\nPress A to disable them now or go to Options Menu.\nPress B to ignore this message.\nYou've been warned!";
		}
		
		warnText.text += "按下左/右键来切换语言\nPress Left/Right to change language";
			
		ClientPrefs.language = languageList[languageChoose];
		ClientPrefs.saveSettings();
		languageText.text = 'Language: ' + ClientPrefs.language;
			
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
