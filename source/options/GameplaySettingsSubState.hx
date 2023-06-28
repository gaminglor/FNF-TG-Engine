package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;
#if android
import android.Hardware;
#end

using StringTools;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	var language:String = ClientPrefs.language;
	
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence
		
		if (ClientPrefs.language == 'Chinese') {
		var option:Option = new Option('Controller Mode',
			'打开它\n如果你想使用操控器',
			'controllerMode',
			'bool',
			#if android true #else false #end);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'下落, 够简单了', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'按键移动到屏幕中心',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'如果不打开\n对手的按键将会隐藏',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			'如果打开\n在没有可击中按键时按下按键不会算作Miss',
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			'打开后按下“重置”按键不会发生任何事',
			'noReset',
			'bool',
			false);
		addOption(option);

		#if android
		var option:Option = new Option('Vibrations',
			'打开后手机会震动',
			'vibration',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeVibration;
		#end

		var option:Option = new Option('Hitsound Volume',
			'你们喜欢的打击音效',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'改变击中按键获得“Sick!”的早/晚\n更大的值以为着你需要更晚的点击',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'sick打击范围',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'good打击范围',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'bad打击范围',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'打击偏移',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);
		}
		else
		{
		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard.',
			'controllerMode',
			'bool',
			#if android true #else false #end);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool',
			false);
		addOption(option);

		#if android
		var option:Option = new Option('Vibrations',
			"If unchecked, your phone will not vibrate.",
			'vibration',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeVibration;
		#end

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them."',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);
		}

		super();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}

	#if android
	function onChangeVibration()
	{
		if(ClientPrefs.vibration)
		{
			Hardware.vibrate(500);
		}
	}
	#end
}