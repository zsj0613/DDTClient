package ddt.events
{
	import flash.events.Event;

	public class PlayerEvent extends Event
	{
		public static const BLOOD_CHANGED:String = "bloodChanged";
		
		public static const TEAM_CHANGED:String = "teamChanged";
		
		public static const HOST_CHANGED:String = "hostChanged";
		
		public static const READY_CHANGED:String = "readyChanged";
		
		public static const ROOMPOS_CHANGED:String = "roomposChanged";
		
		public static const POS_CHANGED:String = "posChanged";
		
		/**
		 * 人物刚死后，调整位置上升70象素　（死亡声音） 
		 */		
		public static const POS_DEAD_PLAYER:String = "posDeadPlayer";
		
		public static const INVIOLABLE_CHANGED:String = "inviolableChanged";
		
		public static const SHOOT:String = "shoot";
		
		public static const BEGIN_SHOOT:String = "beginShoot";
		
		public static const DANDER_CHANGED:String = "danderChanged";
		
		public static const FORZEN_CHANGED:String = "forzenChanged";
		
		public static const ATTACKING_CHANGED:String = "attackingChanged";
		
		public static const USING_PROP:String = "usingProp";
		
		public static const DIR_CHANGED:String = "dirChanged";
		
		public static const ADD_STATE:String = "addState";
		
		public static const HIDDEN_CHANGED:String = "hiddenChanged";
		
		public static const NONOLE_CHANGED : String 	= "noNoleChanged";/**免坑*/
		
		public static const TRANSMIT:String = "transmit";
		
		public static const START_MOVING:String = "startMoving";
		
		public static const STOP_MOVING:String = "stopMoving";
		
		public static const ENERGY_CHANGED:String = "energyChanged";
		
		public static const GUNANGLE_CHANGED:String = "gunangleChanged";
		
		public static const PLAYERANGLE_CHANGED:String = "playerangleChanged";
		
		public static const FORCE_CHANGED:String = "forceChanged";
		
		public static const BOMB_CHANGED:String = "bombChanged";
		
		public static const DIE:String = "die";
		
		public static const TARGETPOS_CHANGED:String = "targetposChanged";
		
		public static const BEGIN_NEW_TURN:String = "beginNewTurn";
		
		public static const USING_SPECIAL_SKILL:String = "usingSpecialSkill";
		
		public static const TROPHY_EVENT:String = "trophyEvent";
		
		/**
		 * 改变队长
		 */		
		public static const LEADER_CHANGE:String = "leaderchange";
		
		/**
		 * 玩家开始发射子弹 
		 */		
		public static  const PLAYER_OUT_SHOOT:String = "playerOutShoot";
		
		/**
		 * 隐藏头上的攻击提示条及下面的移动力条 
		 */		
		//public static const PLAYER_HIDE_CITE:String = "playerHideCite";
		
		public static const PLAYER_SHOOT_TAG:String = "playerShootTag";
		
		public static const LOADING_PROGRESS:String = "loadingprogress";
		
		/**
		 * 等级更新 
		 */		
		public static const UPDATE_GRADE:String = "updateGrade";
		
		/**
		 * 体力不足动画 
		 */		
		public static const NOENTERGY_CARTOON:String = "noEnergyCartoon";
		
		public static const UPDATE_BLOOD_BYFLYOUTMAO:String= "updateBloodByFlyoutmap";
		
		public static const SKIP:String = "skip";
		
		/**
		 * 打击 
		 */		
		public static const BEAT:String = "beat";
		
		/**
		 * 上线 
		 */		
		public static const ONLINE:String = "online";  
		
		
		private var _value:Number;
		
		private var _old:Number;
		
		private var _paras:Array;
		
		public function get value():Number
		{
			return _value;
		}
		
		public function get old():Number
		{
			return _old;
		}
		
		public function get paras():Array
		{
			return _paras;
		}
		
		public function PlayerEvent(type:String,value:Number = 0,old:Number = 0,...arg)
		{
			super(type);
			_value = value;
			_old = old;
			_paras = arg;
		}
		
	}
}