package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	import game.crazyTank.view.common.LevelTipAsset;
	import game.crazyTank.view.common.Level_Tip_0;
	import game.crazyTank.view.common.Level_Tip_1;
	import game.crazyTank.view.common.Level_Tip_2;
	import game.crazyTank.view.common.Level_Tip_3;
	import game.crazyTank.view.common.Level_Tip_4;
	import game.crazyTank.view.common.Level_Tip_5;
	import game.crazyTank.view.common.Level_Tip_6;
	import game.crazyTank.view.common.Level_Tip_7;
	import game.crazyTank.view.common.Level_Tip_8;
	import game.crazyTank.view.common.Level_Tip_9;
	import game.crazyTank.view.common.Level_Tip_10;
	import tank.view.common.*;
	
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.utils.Helpers;

	public class LevelIcon extends Sprite
	{
		private static var SCALE_NUM:Number = 0.75;
		private static var NORMAL_NUM:Number = 0.85;
		private static var IconClasses:Array = [LevelIcon_1,LevelIcon_2,LevelIcon_3,LevelIcon_4,LevelIcon_5,LevelIcon_6,LevelIcon_7,LevelIcon_8,LevelIcon_9,LevelIcon_10,
			                                      LevelIcon_11,LevelIcon_12,LevelIcon_13,LevelIcon_14,LevelIcon_15,LevelIcon_16,LevelIcon_17,LevelIcon_18,LevelIcon_19,LevelIcon_20,
												  LevelIcon_21,LevelIcon_22,LevelIcon_23,LevelIcon_24,LevelIcon_25,LevelIcon_26,LevelIcon_27,LevelIcon_28,LevelIcon_29,LevelIcon_30,	
												  LevelIcon_31,LevelIcon_32,LevelIcon_33,LevelIcon_34,LevelIcon_35,LevelIcon_36,LevelIcon_37,LevelIcon_38,LevelIcon_39,LevelIcon_40,	
												  LevelIcon_41,LevelIcon_42,LevelIcon_43,LevelIcon_44,LevelIcon_45,LevelIcon_46,LevelIcon_47,LevelIcon_48,LevelIcon_49,LevelIcon_50,		
												  LevelIcon_51,LevelIcon_52,LevelIcon_53,LevelIcon_54,LevelIcon_55,LevelIcon_56,LevelIcon_57,LevelIcon_58,LevelIcon_59,LevelIcon_60,		
												  LevelIcon_61,LevelIcon_62,LevelIcon_63,LevelIcon_64,LevelIcon_65,LevelIcon_66,LevelIcon_67,LevelIcon_68,LevelIcon_69,LevelIcon_70,		
												  LevelIcon_71,LevelIcon_72,LevelIcon_73,LevelIcon_74,LevelIcon_75,LevelIcon_76,LevelIcon_77,LevelIcon_78,LevelIcon_79,LevelIcon_80,		
												  LevelIcon_81,LevelIcon_82,LevelIcon_83,LevelIcon_84,LevelIcon_85,LevelIcon_86,LevelIcon_87,LevelIcon_88,LevelIcon_89,LevelIcon_90,		
												  LevelIcon_91,LevelIcon_92,LevelIcon_93,LevelIcon_94,LevelIcon_95,LevelIcon_96,LevelIcon_97,LevelIcon_98,LevelIcon_99,LevelIcon_100]

		public static var LevelTipClasses:Array = [Level_Tip_0,Level_Tip_1,Level_Tip_2,
													Level_Tip_3,Level_Tip_4,Level_Tip_5,
													Level_Tip_6,Level_Tip_7,Level_Tip_8,
													Level_Tip_9,Level_Tip_10];
		private var _type:String;
		private var _level:int;
		private var _icon:MovieClip;
		private var _tip:LevelTipAsset;
		private var _tipConatiner:Sprite;
		private var _repute:Repute;
		private var _reputeCount:int;
		private var _winRate:WinRate;
		private var _battle:Battle;
		private var _win:int;
		private var _total:int;
		private var _enableTip:Boolean;
		private var _battleNum:int;
		
		public function LevelIcon(type:String,level:int,repute:int,win:int,total:int,battle:int,enableTip:Boolean = true)
		{
			_type = type;
			_level = level<=0 ? 1 : (level>=IconClasses.length ? IconClasses.length : level);
			_reputeCount = repute;
			_win = win;
			_total = total;
			_battleNum = battle;
			_enableTip = enableTip;
			super();
			init();
		}
		
		private function init():void
		{
			_icon = createIcon();
			//if(_icon.hasOwnProperty("level_effect_mc"))
			//{
			//	_icon.level_effect_mc.mouseEnabled = false;
			//	_icon.level_effect_mc.mouseChildren = false;
			//}
			addChild(_icon);
			createLevelTip(); // jsion create at 二○○九年十月二十二日
		}
		
		public function stop():void
		{
			//if(_icon.hasOwnProperty("level_effect_mc"))
			//{
			//	stopMovieClip(_icon.level_effect_mc as MovieClip);
			//	_icon.level_effect_mc.visible = false;
			//}
		}
		
		public function play():void
		{
			//if(_icon.hasOwnProperty("level_effect_mc"))
			//{
			//	playMovieClip(_icon.level_effect_mc as MovieClip);
			//	_icon.level_effect_mc.visible = true;
			//}
		}
		
		private function stopMovieClip(mc:MovieClip):void
		{
			if(mc)
			{
				mc.gotoAndStop(1);
				if(mc.numChildren>0)
				{
					for(var i:int=0; i< mc.numChildren; i++)
					{
						stopMovieClip(mc.getChildAt(i) as MovieClip);
					}
				}
			}
		}
		
		private function playMovieClip(mc:MovieClip):void
		{
			if(mc)
			{
				mc.gotoAndPlay(1);
				if(mc.numChildren>0)
				{
					for(var i:int=0; i< mc.numChildren; i++)
					{
						playMovieClip(mc.getChildAt(i) as MovieClip);
					}
				}
			}
		}
		
		private var _topLayer:Boolean = false;
		public function set topLayer(b:Boolean):void
		{
			_topLayer = b;
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			if(_topLayer)
			{
				setTOPTipPos();
				stage.addChild(_tipConatiner);
			}else
			{
				TipManager.setCurrentTarget(_icon,_tipConatiner,3,3);
			}
		}
		
		private function setTOPTipPos():void
		{
			var pos:Point = localToGlobal(new Point(48,35)); // jsion edit at 二○○九年十月二十一日
			pos.x = ((pos.x + _tipConatiner.width) > 1000 ? (1000-_tipConatiner.width) : pos.x);
			pos.y = (pos.y + (_tipConatiner.height)> 600 ? (600 - _tipConatiner.height) : pos.y);
			_tipConatiner.x = pos.x;
			_tipConatiner.y = pos.y;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			if(_topLayer)
			{
				_tipConatiner.parent.removeChild(_tipConatiner);
			}else
			{
				TipManager.setCurrentTarget(null,_tipConatiner);
			}
		}
		
		public function set level(value:int):void
		{
			_level = value;
			_repute.level = value;
			refreshIcon();
			createLevelTip();
		}
		
		public function set Battle(battleNum:int):void
		{
			_battle.BattleNum = battleNum;
		}
		/**
		 * 重新生成提示框
		 */
		public function resetLevelTip(lv:int,repute:int,win:int,total:int,enableTip:Boolean = true):void
		{
			//global.traceStr("OnResetLevelTip");
			_level = lv;
			_reputeCount = repute;
			_win = win;
			_total = total;
			_enableTip = enableTip;
			refreshIcon();
			createLevelTip();
		}
		
		private  function createIcon():MovieClip
		{
			removeCurrentIcon();
			//global.traceStr("OnCreateIcon"+_level);
			var tempIcon:MovieClip = new IconClasses[_level-1]();
			if(tempIcon == null)
				throw new Error("could not create correct LevelIcon");
			if(_type == "s")
			{
				tempIcon.scaleX = tempIcon.scaleY = SCALE_NUM;
			}
			else
			{
				tempIcon.scaleX = tempIcon.scaleY = NORMAL_NUM;
			}
			
			if(_enableTip)
			{
				tempIcon.addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
				tempIcon.addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			}
			tempIcon.addEventListener(Event.ADDED_TO_STAGE,__onIconShow);
			tempIcon.addEventListener(Event.REMOVED_FROM_STAGE,__onIconRemoveSatge);
			return tempIcon;
		}
		
		private function removeCurrentIcon():void
		{
			if(_icon)
			{
				_icon.addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
				_icon.addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
				_icon.addEventListener(Event.ADDED_TO_STAGE,__onIconShow);
				_icon.addEventListener(Event.REMOVED_FROM_STAGE,__onIconRemoveSatge);
				if(_icon.parent)_icon.parent.removeChild(_icon);
			}
		}
				
		private function __onIconShow(event:Event):void
		{
			MovieClip(event.currentTarget).play();
		}
		
		private function __onIconRemoveSatge(event:Event):void
		{
			MovieClip(event.currentTarget).stop();
		}
		/**
		 * 等级图标提示框 // jsion create at 二○○九年十月二十二日
		 */
		private function createLevelTip():void
		{
			if(_tip)
			{
				if(_tip.parent)
				{
					_tip.parent.removeChild(_tip);
				}
				_tip = null;
			}
			
			if(_icon == null)
			{
				_icon = createIcon();
				addChild(_icon);
			}
			
			_tip = new LevelTipAsset();
			Helpers.hidePosMc(_tip);
			ComponentHelper.replaceChild(_tip,_tip.bg_pos,new GoodsTipBgAsset());
			
			var _tmp:uint;
			var _lt1:MovieClip;
			var _lt2:MovieClip;
			
			if(_level > 9)
			{
				_tmp = Math.floor(_level / 10); // 计算十位数部分
				_lt1 = new LevelTipClasses[_tmp]();
				_lt1.x = _tip.level_tip_pos_mc.x - 4;
				_lt1.y = _tip.level_tip_pos_mc.y;
				_tip.addChild(_lt1);
				
				_tmp = _level % 10;
				_lt2 = new LevelTipClasses[_tmp]();
				_lt2.x = _lt1.x + _lt1.width - 3;
				_lt2.y = _lt1.y;
				_tip.addChild(_lt2);
			}
			else
			{
				_tmp = 0; // 计算十位数部分
				_lt1 = new LevelTipClasses[_tmp]();
				_lt1.x = _tip.level_tip_pos_mc.x - 4;
				_lt1.y = _tip.level_tip_pos_mc.y;
				_tip.addChild(_lt1);
				
				_tmp = _level;
				_lt2 = new LevelTipClasses[_tmp]();
				_lt2.x = _lt1.x + _lt1.width - 3;
				_lt2.y = _lt1.y;
				_tip.addChild(_lt2);
			}
			
			_tip.level_tip_pos_mc.parent.removeChild(_tip.level_tip_pos_mc);
			
			_tipConatiner = new Sprite();
			
			_repute = new Repute(_reputeCount,_level);
			_repute.align = Repute.LEFT;
			_winRate = new WinRate(_win,_total);
			_battle = new Battle(_battleNum);
			
			_repute.x = _winRate.x = _battle.x = 10;
			_repute.y = 27;
			_winRate.y = 52;
			_battle.y = 77;
			_tipConatiner.addChild(_tip);
			_tipConatiner.addChild(_repute);
			_tipConatiner.addChild(_winRate);
			_tipConatiner.addChild(_battle);
		}
		
		private function refreshIcon():void
		{
			if(_level <= 0 || _level > IconClasses.length)
				return;
			_icon = createIcon();
			_icon.gotoAndStop(1);
			if(_icon.hasOwnProperty("level_effect_mc"))
			{
				_icon.level_effect_mc.mouseEnabled = false;
				_icon.level_effect_mc.mouseChildren = false;
			}
			addChild(_icon);
		}
		
		public function setRepute(reputeCount:int):void
		{
			_repute.setRepute(reputeCount);
		}
		
		public function setRate($win:int,$total:int):void
		{
			_winRate.setRate($win,$total);
		}
		
		public function dispose():void
		{
			removeCurrentIcon();
			if(_tip)
			{
				if(_tip.parent)_tip.parent.removeChild(_tip);
			}
			_tip = null;
			if(_tipConatiner)
			{
				if(_tipConatiner.parent)_tipConatiner.parent.removeChild(_tipConatiner);
			}
			_tipConatiner = null;
			if(_repute)
			{
				if(_repute.parent)_repute.parent.removeChild(_repute);
			}
			_repute = null;
			if(_winRate)
			{
				if(_winRate.parent)_winRate.parent.removeChild(_winRate);
			}
			_winRate = null;
			if(_battle)
			{
				if(_battle.parent)_battle.parent.removeChild(_battle);
			}
			_battle = null;
			if(_icon && _icon.parent)_icon.parent.removeChild(_icon);
			//if(_icon && _icon.hasOwnProperty("level_effect_mc"))
			//{
			//	_icon["level_effect_mc"].graphics.clear();
			//}
			_icon = null;
			if(parent)parent.removeChild(this);
		}
	}
}