package ddt.data.game
{
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import road.data.DictionaryData;
	
	import ddt.actions.ActionManager;
	import ddt.actions.BaseAction;
	import ddt.data.game.mirarieffecticon.BaseMirariEffectIcon;
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.LivingEvent;
	import ddt.view.characterII.ShowCharacter;
	
	[Event(name="posChanged",type="ddt.events.LivingEvent")]
	[Event(name="dirChanged",type="ddt.events.LivingEvent")]
	[Event(name="forzenChanged",type="ddt.events.LivingEvent")]
	[Event(name="hiddenChanged",type="ddt.events.LivingEvent")]
	[Event(name="noholeChanged",type="ddt.events.LivingEvent")]
	[Event(name="die",type="ddt.events.LivingEvent")]
	[Event(name="angleChanged",type="ddt.events.LivingEvent")]
	[Event(name="bloodChanged",type="ddt.events.LivingEvent")]
	[Event(name="beginNewTurn",type="ddt.events.LivingEvent")]
	[Event(name="shoot",type="ddt.events.LivingEvent")]
	[Event(name="beat",type="ddt.events.LivingEvent")]
	[Event(name="transmit",type="ddt.events.LivingEvent")]
	[Event(name="moveTo",type="ddt.events.LivingEvent")]
	[Event(name="fall",type="ddt.events.LivingEvent")]
	[Event(name="jump",type="ddt.events.LivingEvent")]
	[Event(name="say",type="ddt.events.LivingEvent")]
	public class Living extends EventDispatcher
	{
		public static const CRY_ACTION:String = "cry";
		public static const STAND_ACTION:String = "stand";
		public static const DIE_ACTION:String = "die";
		public static const SHOOT_ACTION:String = "beat2";
		public static const BORN_ACTION:String = "born";
		public static const RENEW:String = "renew";
		public static const ANGRY_ACTION:String = "angry";
		public static const WALK_ACTION:String = "walk";
		
		public static const DEFENCE_ACTION:String = "shield";//防御
		
		public var character:ShowCharacter;
		
		public var typeLiving : int;//怪类型，2要留残骸的小怪，1不要留残骸的小怪,3,不要残骸的BOSS，4要残骸的BOSS,5,打死后做特定动作（除die外的动作）的BOSS
		
		private var _state:int = 0;//状态，0为普通状态，1为发怒状态
		
		/**
		 * 宝珠效果列表
		 */		
		private var _mirariEffects:DictionaryData;
		public function get MirariEffects():DictionaryData
		{
			return _mirariEffects;
		}
		
		public var maxEnergy:int;// 最大体力
		
		public var isExist:Boolean = true;
		public function Living(id:int,team:int,maxBlood:int)
		{
			_livingID = id;
			_team = team;
			_maxBlood = maxBlood;
			_actionManager = new ActionManager();
			_mirariEffects = new DictionaryData();
			reset();
		}
		
		public function reset():void
		{
			_blood = _maxBlood;
			_isLiving = true;
			
			_isFrozen = false;
			_gemDefense = false;
			_isHidden = false;
			_isNoNole = false;
			isLockAngle = false;
			
			_mirariEffects.clear();
		}
		
		/**
		 * 添加或自动更新宝珠效果列表
		 * @param effecicon
		 * 
		 */		
		public function handleMirariEffect(effecicon:BaseMirariEffectIcon):void
		{
			_mirariEffects.add(effecicon.MirariType,effecicon);
		}
		
		public function removeMirariEffect(effecicon:BaseMirariEffectIcon):void
		{
			_mirariEffects.remove(effecicon.MirariType);
		}
		
		public function clearEffectIcon():void
		{
			_mirariEffects.clear();
		}
		
		private var _isLockAngle:Boolean;
		public function get isLockAngle():Boolean
		{
			return _isLockAngle;
		}
		public function set isLockAngle(val:Boolean):void
		{
			if(_isLockAngle == val) return;
			var oldValue:int = 0;
			var newValue:int = 0;
			if(_isLockAngle)
				oldValue = 1;
			if(val)
				newValue = 1;
			_isLockAngle = val;
			dispatchEvent(new LivingEvent(LivingEvent.LOCKANGLE_CHANGE,newValue,oldValue));
		}
		
		public function dispose():void
		{
			isExist = false;
			if(_actionMovie && _actionMovie.parent)
				_actionMovie.parent.removeChild(_actionMovie);
			_actionMovie = null;
			
			if(_thumbnail && _thumbnail.parent)
				_thumbnail.parent.removeChild(_thumbnail);
			_thumbnail = null;
			/**
			* 这里不能调用character.dispose();
			 * 原因是这个对象在RoomPlayerInfo里面也有引用。
			 * 这个的dispose交给RoomPlayerInfo来dispose就可以了
			*/			
//			if(character)character.dispose();
			character = null;
			
			if(_mirariEffects)
				_mirariEffects.clear();
			_mirariEffects = null;
			if(_actionManager)_actionManager.clear();
			_actionManager = null;
		}
		
		private var _name:String = "";
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		private var _livingID:int;
		public function get LivingID():int
		{
			return _livingID;
		}
			
		private var _team:int;
		public function get team():int
		{
			return _team;
		}
		
		/**
		 * 0 平常 掉落
		 * 1 攻击 掉落
		 */
		private var _fallingType : int = 0;
		public function set fallingType(i : int) : void
		{
			_fallingType = 0;
		}
		public function get fallingType() : int
		{
			return _fallingType;
		}
		
		/**
		 * 人物的位置 
		 */		
		protected var _pos:Point = new Point(0,0);
		public function get pos():Point
		{
			return _pos;
		}
		public function set pos(value:Point):void
		{
			if(_pos.equals(value) == false)
			{
				_pos = value;
				dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));	
			}		
		}
		
		/**
		 * 人物方向 
		 */		
		private var _direction:int = 1;
		public function get direction():int
		{
			return _direction;
		}
		public function set direction(value:int):void
		{
			if(_direction == value) return;
			_direction = value;
			dispatchEvent(new LivingEvent(LivingEvent.DIR_CHANGED));
		}
		
		/**
		 * 血量 
		 */
		private var _maxBlood:int;		
		public function get maxBlood():int
		{
			return _maxBlood;
		}
		
		public function set maxBlood(value:int):void
		{
			_maxBlood = value;
		}
		
		private var _blood:int;
		public function get blood():int
		{
			return _blood;
		}
		public function set blood(value:int):void
		{
//			trace("当前血量： " + _blood + " 变更后血量："+ value);
			_blood = value;
		}
		public function initBlood(value:int):void{
			blood = value;
			dispatchEvent(
				new LivingEvent(LivingEvent.BLOOD_CHANGED,value,0,5)
			)
		}
		/**
		 * 是否被冰冻 
		 */		
		private var _isFrozen:Boolean;
		public function get isFrozen():Boolean
		{
			return _isFrozen;
		}
		public function set isFrozen(value:Boolean):void
		{
			if(_isFrozen == value) return;
			_isFrozen = value;
			dispatchEvent(new LivingEvent(LivingEvent.FORZEN_CHANGED));
		}
		
		private var _isGemGlow : Boolean;
		public function get isGemGlow() : Boolean
		{
			return _isGemGlow;
		}
		public function set isGemGlow(i : Boolean) : void
		{
			if(_isGemGlow != i)
			{
				_isGemGlow = i;
				dispatchEvent(new LivingEvent(LivingEvent.GEM_GLOW_CHANGED));
			}
		}
		
		/***
		 * 珠宝防御
		 */
		 private var _gemDefense : Boolean;
		 public function get gemDefense() : Boolean
		 {
		 	return _gemDefense;
		 }
		 public function set gemDefense(value : Boolean) : void
		 {
		 	if(_gemDefense == value)return;
		 	_gemDefense = value;
		 	dispatchEvent(new LivingEvent(LivingEvent.GEM_DEFENSE_CHANGED));
		 }
		
		
		/**
		 * 是否隐身 
		 */		
		private var _isHidden:Boolean;
		public function get isHidden():Boolean
		{
			return _isHidden;
		}
		public function set isHidden(value:Boolean):void
		{
			if(value == _isHidden) return;
			_isHidden = value;
			dispatchEvent(new LivingEvent(LivingEvent.HIDDEN_CHANGED));
		}
		
		/**
		 * 是否免坑 
		 */		
		private var _isNoNole : Boolean;
		public function get isNoNole() : Boolean
		{
			return _isNoNole;
		}
		public function set isNoNole(b : Boolean) : void
		{
			if(_isNoNole == b) return;
			_isNoNole = b;
			dispatchEvent(new LivingEvent(LivingEvent.NOHOLE_CHANGED));
		}
		
		/**
		 * 封印
		 * */
		private var _lockState:Boolean;
		public function set LockState(value:Boolean):void
		{
			if(_lockState == value) return;
			_lockState = value;
			if(LockType == 1 || LockType == 2) dispatchEvent(new LivingEvent(LivingEvent.LOCK_STATE,0,0,LockType));
		}
		
		public function get LockState():Boolean
		{
			return _lockState;
		}
		
		/**
		 * 封印类型 1正常封印、0不要显示锁状态的封印
		 * */
		private var _lockType:int = 1;
		public function set LockType(value:int):void
		{
			_lockType = value;
		}
		public function get LockType():int
		{
			return _lockType;
		}
		
		
		/**
		 * 人物状态 
		 */		
		private var _isLiving:Boolean;
		public function get isLiving():Boolean
		{
			return _isLiving;
		}
		
		public function die(withAction:Boolean = true):void
		{
			if(_isLiving)
			{
				_isLiving = false;
				dispatchEvent(new LivingEvent(LivingEvent.DIE,0,0,withAction));
			}
		}
		
		/**
		 * 人的角度 
		 */		
		private var _playerAngle:Number = 0;
		public function  get playerAngle():Number
		{
			return _playerAngle;
		}
		public function set playerAngle(value:Number):void
		{
			_playerAngle = value;
			dispatchEvent(new LivingEvent(LivingEvent.ANGLE_CHANGED));
		}
		
		private var _actionMovieName:String;
		public function get actionMovieName():String
		{
			return _actionMovieName;
		}
		
		public function set actionMovieName(value:String):void
		{
			_actionMovieName = value;
		}
		
		public var isMoving:Boolean;
		
		/***
		 * @type == 6自杀时掉血
		 */
		public function updateBload(value:int,type:int,addVlaue:int =0):void
		{
			if(!isLiving) return;
			if(type == 3)//beat时候掉血，不管有没有真的更新血量，都需要显示一个掉血的数值 by wicki 01/27/2010
			{
				_blood = value;
				dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,_blood,type,addVlaue));
			}else
			{
				if(_blood != value)
				{
					var old:int = _blood;
					_blood = value;
					if(type != 6 && _isLiving)dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,old,type,addVlaue));
				}else if(type == 0 && value >= _blood){
					dispatchEvent(new LivingEvent(LivingEvent.BLOOD_CHANGED,value,_blood,type,addVlaue));
				}
			}
			
			if(_blood <= 0)
			{
				_blood = 0;
				die(type != 6);
			}
		}
		
		private var _actionManager:ActionManager;
		
		public function get actionCount():int
		{
			if(_actionManager)
				return _actionManager.actionCount;
			return 0;
		}
		
		public function traceCurrentAction():void
		{
			_actionManager.traceAllRemainAction();
		}
		
		public function act(action:BaseAction):void
		{
			_actionManager.act(action);
		}
		
		public function update():void
		{
			_actionManager.execute();
		}
		
		private var _actionMovie:Bitmap;
		private var _thumbnail:Bitmap;
		
		public function set actionMovieBitmap(value:Bitmap):void
		{
			_actionMovie = value;
		}
		
		public function get actionMovieBitmap():Bitmap
		{
			return _actionMovie;
		}
		public function set thumbnail(value:Bitmap):void
		{
			_thumbnail = value;
		}
		
		public function get thumbnail():Bitmap
		{
			var result:Bitmap = new Bitmap(_thumbnail.bitmapData.clone())
			return result;
		}
		public function isPlayer():Boolean
		{
			return false;
		}
		
		public function get isSelf():Boolean
		{
			return false;
		}
		
		public function get playerInfo():PlayerInfo
		{
			return null;
		}
		
		public function startMoving():void
		{
			dispatchEvent(new LivingEvent(LivingEvent.START_MOVING));
		}
		
		public function beginNewTurn():void
		{
			dispatchEvent(new LivingEvent(LivingEvent.BEGIN_NEW_TURN));
		}
		
		public function shoot(list:Array,event:CrazyTankSocketEvent):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.SHOOT,0,0,list,event));
		}
		
		public function beat(action:String,blood:int,target:Living,damage:int,attackEffect:int = 0):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.BEAT,blood,0,action,target,damage,attackEffect));
		}
		
		public function transmit(pos:Point):void
		{
//			dispatchEvent(new LivingEvent(LivingEvent.TRANSMIT,0,0,pos));
			if(_pos.equals(pos) == false)
			{
				_pos = pos;
				dispatchEvent(new LivingEvent(LivingEvent.POS_CHANGED));	
			}
		}
		
		public function showAttackEffect(effectID:int):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.SHOW_ATTACK_EFFECT,0,0,effectID));
		}
		
		public function moveTo(type:Number,target:Point,dir:Number,isLiving:Boolean,action:String = "",speed:int=3):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.MOVE_TO,0,0,type,target,dir,isLiving,action,speed));
		}
		public function changePos(target:Point,action:String = ""):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.CHANGE_POS,0,0,target));
		}
		
		
		
		public function fallTo(pos:Point,speed:int,action:String = "",fallType:int=0):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.FALL,0,0,pos,speed,action,fallType));
		}
		
		public function jumpTo(pos:Point,speed:int,action:String = "",type:int=0):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.JUMP,0,0,pos,speed,action,type));
		}
		
		public function set State(state:int):void
		{
			if(_state == state) return;
			_state = state;
			dispatchEvent(new LivingEvent(LivingEvent.CHANGE_STATE));
		}
		
		public function get State():int
		{
			return _state;
		}
		
		public function say(msg:String,type:int = 0):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.SAY,0,0,msg,type));
		}
		
		public function playMovie(type:String,fun:Function = null,args:Array = null):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.PLAY_MOVIE,0,0,type,fun,args));
		}
		
		private var _defaultAction:String = "";
		public function set defaultAction (action:String):void
		{
			_defaultAction = action;
			dispatchEvent(new LivingEvent(LivingEvent.DEFAULT_ACTION_CHANGED));
		}
		
		public function get defaultAction():String
		{
			return _defaultAction
		}
		
		public function doDefaultAction():void
		{
			playMovie(_defaultAction);
		}
		
		public function pick(box:int):void
		{
			dispatchEvent(new LivingEvent(LivingEvent.BOX_PICK));
		}
	}
}