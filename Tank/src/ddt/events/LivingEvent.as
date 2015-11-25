package ddt.events
{
	import flash.events.Event;

	public class LivingEvent extends Event
	{
		//////////////////////////////Living//////////////////////////////
		public static const POS_CHANGED:String = "posChanged";
		
		public static const DIR_CHANGED:String = "dirChanged";
		
		public static const FORZEN_CHANGED:String = "forzenChanged";
		
		public static const GEM_DEFENSE_CHANGED : String = "gemDefenseChanged";//珠宝防御
		public static const GEM_GLOW_CHANGED : String = "gemGlowChanged";//珠宝防御
		
		public static const HIDDEN_CHANGED:String = "hiddenChanged";
		
		public static const NOHOLE_CHANGED:String = "noholeChanged";
		
		public static const DIE:String = "die";
		
		public static const ANGLE_CHANGED:String = "angleChanged";
		
		public static const BLOOD_CHANGED:String = "bloodChanged";
		
		public static const BEGIN_NEW_TURN:String = "beginNewTurn";
		
		public static const SHOOT:String = "shoot";
		
		public static const BEAT:String = "beat";
		
		public static const TRANSMIT:String = "transmit";
		
		public static const SHOW_ATTACK_EFFECT:String = "showAttackEffect";
		
		public static const MOVE_TO:String = "moveTo";
		
		public static const FALL:String = "fall";
		
		public static const JUMP:String = "jump";
		
		public static const SAY:String = "say";
		
		public static const START_MOVING:String = "startMoving";
		
		public static const LOCK_STATE:String = "lockState";
		
		
		public static const CHANGE_POS:String = "changePosition";
		/////////////////////////TurnedLiving////////////////////////////
		public static const ATTACKING_CHANGED:String = "attackingChanged";
		
		
		////////////////////////Player///////////////////////////////
		public static const LOADING_PROGRESS:String = "loadingProgress";
		
		public static const BEGIN_SHOOT:String = "beginShoot";
		
		public static const ADD_STATE:String = "addState";
		
		public static const USING_ITEM:String = "usingItem";
		
		public static const USING_SPECIAL_SKILL:String = "usingSpecialSkill";
		
		public static const DANDER_CHANGED:String = "danderChanged";
		
		public static const BOMB_CHANGED:String = "bombChanged";
		
		
		///////////////////////LocalPlayer/////////////////////////
		public static const ENERGY_CHANGED:String = "energyChanged";
		
		public static const GUNANGLE_CHANGED:String = "gunangleChanged";
		
		public static const FORCE_CHANGED:String = "forceChanged";
		
		public static const SKIP:String = "skip";
		
		public static const SEND_SHOOT_ACTION:String = "sendShootAction";
		
		public static const PLAY_MOVIE:String = "playmovie";
		
		public static const MODEL_CHANGED:String = "modelChanged";
		
		public static const DEFAULT_ACTION_CHANGED:String = "defaultActionChanged";
		
		public static const PLAYER_MOVETO:String = "playerMoveto";
		
		public static const CHANGE_STATE:String = "changeState";
		
		public static const ACT_ACTION:String = "actAction";
		
		
		/**
		 * 捡起箱子前发出的事件
		 */		
		public static const BOX_PICK:String = "boxPick";
		
		/**
		 * 宝珠锁定效果
		 */		
		public static const LOCKANGLE_CHANGE:String = "lockAngleChange";
		
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
		
		public function LivingEvent(type:String,value:Number = 0,old:Number = 0,...arg)
		{
			super(type);
			_value = value;
			_old = old;
			_paras = arg;
		}
		
	}
}