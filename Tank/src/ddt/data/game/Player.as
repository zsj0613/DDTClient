package ddt.data.game
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import road.manager.SoundManager;
	
	import ddt.data.DeputyWeaponInfo;
	import ddt.data.GameEvent;
	import ddt.data.WeaponInfo;
	import ddt.data.WebSpeedInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.player.SelfInfo;
	import ddt.events.LivingEvent;
	import ddt.manager.ItemManager;
	import ddt.view.characterII.GameCharacter;
	
	[Event(name="beginShoot",type="ddt.events.LivingEvent")]
	[Event(name="addState",type="ddt.events.LivingEvent")]
	[Event(name="usingItem",type="ddt.events.LivingEvent")]
	[Event(name="usingSpecialSkill",type="ddt.events.LivingEvent")]
	[Event(name="danderChanged",type="ddt.events.LivingEvent")]
	[Event(name="bombChanged",type="ddt.events.LivingEvent")]
	public class Player extends TurnedLiving
	{
		
		/**
		 * 移动速度，单步移动动的像素
		 */	
		public static var MOVE_SPEED:Number = 2;		
		
		/**
		 * 鬼魂移动速度 
		 */		
		public static var GHOST_MOVE_SPEED:Number = 8;
		
		/**
		 * 下落速度 ，单步下落的像素
		 */		
		public static var FALL_SPEED:Number = 12;
		
//		/**
//		 * 最大能量值,能量值与MOVE_SPEED有关系，移动一像素，能量值减少1
//		 */		
//		public static var ENERGY_MAX:Number = 240;
//		
//		/**
//		 * 鬼魂的最大移动力 
//		 */		
//		public static const ENERGY_GHOST_MAX:Number = 240;
		
		/**
		 * 最大的力度 
		 */		
		public static const FORCE_MAX:int = 2000;
		
		/**
		 * 单步力度 
		 */		
		public static const FORCE_STEP:int = 24;
		
		/**
		 * 最大怒气值 
		 */		
		public static const TOTAL_DANDER:int = 200;
		/**
		 * 炮弹发送间隔 
		 */		
		public static const SHOOT_INTERVAL:uint = 1000;
		
		/**
		 * 总血量 
		 */		
		public static const TOTAL_BLOOD:int = 1000;
		
		public static const TOTAL_LEADER_BLOOD:int = 2000;
		
		public function Player(info:PlayerInfo,id:int,team:int,maxBlood:int)
		{
			super(id,team,maxBlood);
			_info = info;
			setWeaponInfo();
			setDeputyWeaponInfo();
			webSpeedInfo = new WebSpeedInfo(_info.webSpeed);
			initEvent();
		}
		
		private function initEvent():void
		{
			_info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__playerPropChanged);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__playerPropChanged);
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(movie)
				movie.dispose();
			movie = null;
			
			if(_currentWeapInfo)_currentWeapInfo.dispose();
			_currentWeapInfo = null;
			if(_currentDeputyWeaponInfo)_currentDeputyWeaponInfo.dispose();
			_currentDeputyWeaponInfo = null;
			webSpeedInfo = null;
			
			_info = null;
			
			super.dispose();
		}
		
		override public function reset():void
		{
			super.reset();
			_dander = 0;
		}

		private var _info:PlayerInfo
		override public function get playerInfo():PlayerInfo
		{
			return _info;
		}
		override public function get isSelf():Boolean
		{
			return _info is SelfInfo;
		}
		
		private var _movie:GameCharacter;
		
		public function get movie():GameCharacter
		{
			return _movie;
		}
		
		public function set movie(value:GameCharacter):void
		{
			_movie = value;
		}
		
		public var isUpGrade:Boolean;
		public var isWin:Boolean;
		public var CurrentLevel:int;
		public var CurrentGP:int;
		public var TotalKill:int;
		public var TotalHurt:int;
		public var TotalHitTargetCount:int;
		public var TotalShootCount:int;
		public var GetCardCount:int;
		public var BossCardCount:int;
		public var GainOffer:int;
		public var GainGP:int;
		public var MarryGP:int;
		public var zoneName:String;
		/**
		 * 人物移动
		 * 与怪物移动是分开的
		 * 
		 */		
		public function playerMoveTo(type:Number,target:Point,dir:Number,isLiving:Boolean):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.PLAYER_MOVETO,0,0,type,target,dir,isLiving));
		}
		
		
		/**
		 * 开始发射 
		 */		
		public function beginShoot():void
		{
			dispatchEvent(new LivingEvent(LivingEvent.BEGIN_SHOOT));
		}
		
		/**
		 * 使用道具
		 */		
		public function useItem(info:ItemTemplateInfo):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM,0,0,info));
		}
		
		/**
		 * 使用道具，小图标使用dis参数显示
		 * @param dis
		 * 
		 */		
		public function useItemByIcon(dis:DisplayObject):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.USING_ITEM,0,0,dis));
		}
		
		/**
		 * 使用必杀 
		 */		
		private var _isSpecialSkill:Boolean;
		public function get isSpecialSkill():Boolean
		{
			return _isSpecialSkill;
		}
		public function set isSpecialSkill(value:Boolean):void
		{
			if(_isSpecialSkill != value)
			{
				_isSpecialSkill = value;
				if(value)
				{
					dispatchEvent(new LivingEvent(LivingEvent.USING_SPECIAL_SKILL));
				}
			}
		}
		
		
		
		private var _dander:int;
		public function get dander():int
		{
			return _dander;
		}
		public function set dander(value:int):void
		{
			if(_dander == value) return;
			if(_dander > value && value > 0)return;
			_dander = (value > TOTAL_DANDER) ? TOTAL_DANDER : value;
			dispatchEvent(new LivingEvent(LivingEvent.DANDER_CHANGED,_dander));
		}
		
		/**
		 *当前的武器 
		 */		
		private var _currentWeapInfo:WeaponInfo;
		public function get currentWeapInfo():WeaponInfo
		{
			return _currentWeapInfo;
		}
		
		/**
		 * 当前炮弹 
		 */		
		private var _currentBomb:int;
		public function get currentBomb():int
		{
			return _currentBomb;
		}
		public function set currentBomb(value:int):void
		{
			if(value == _currentBomb) return;
			_currentBomb = value;
			dispatchEvent(new LivingEvent(LivingEvent.BOMB_CHANGED,_currentBomb,0));
		}
		public var webSpeedInfo:WebSpeedInfo;
		
		override public function beginNewTurn():void
		{
			super.beginNewTurn();
			_currentBomb = _currentWeapInfo.commonBall;
			_isSpecialSkill = false;
			gemDefense = false;
		}
		
		override public function die(widthAction:Boolean = true):void
		{
			if(isLiving)
			{
				super.die();
				isSpecialSkill = false;
				dander = 0;
				SoundManager.Instance.play("Sound042");
			}
		}
		
		override public function isPlayer():Boolean
		{
			return true;
		}
		
		protected function setWeaponInfo():void
		{
			var iteminfo:InventoryItemInfo = new InventoryItemInfo();
			iteminfo.TemplateID = playerInfo.WeaponID;
			ItemManager.fill(iteminfo);
			if(_currentWeapInfo)
				_currentWeapInfo.dispose();
			_currentWeapInfo = new WeaponInfo(iteminfo);
			currentBomb = _currentWeapInfo.commonBall;
		}
		
		public function setDeputyWeaponInfo():void
		{
			var iteminfo:InventoryItemInfo = new InventoryItemInfo();
			iteminfo.TemplateID = _info.DeputyWeaponID;
			ItemManager.fill(iteminfo);
			_currentDeputyWeaponInfo = new DeputyWeaponInfo(iteminfo);
		}

		private var _currentDeputyWeaponInfo:DeputyWeaponInfo
		public function get currentDeputyWeaponInfo():DeputyWeaponInfo
		{
			return _currentDeputyWeaponInfo;
		}
		
		public function hasDeputyWeapon():Boolean
		{
			return _info.DeputyWeaponID > 0;
		}
				
		private function __playerPropChanged(event:PlayerPropertyEvent):void
		{
			if(event.changedProperties["WeaponID"])
			{
				setWeaponInfo();
			}else if(event.changedProperties["DeputyWeaponID"])
			{
				setDeputyWeaponInfo();
			}
			if(event.changedProperties["Grade"])
			{
				isUpGrade = _info.IsUpdate;
			}
		}
		
		private var _isReady:Boolean;
		public function get isReady():Boolean
		{
			return _isReady;
		}
		public function set isReady(value:Boolean):void
		{
			_isReady = value;
			dispatchEvent(new GameEvent(GameEvent.READY_CHANGED,null));
		}
	}
}