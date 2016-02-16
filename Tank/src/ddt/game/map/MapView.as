package ddt.game.map
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import phy.maps.Ground;
	import phy.maps.Map;
	import phy.object.PhysicalObj;
	import phy.object.Physics;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.actions.ActionManager;
	import ddt.actions.BaseAction;
	import ddt.data.Config;
	import ddt.data.GameEvent;
	import ddt.data.GameInfo;
	import ddt.data.MapInfo;
	import ddt.data.game.Living;
	import ddt.data.game.SimpleBoss;
	import ddt.data.game.TurnedLiving;
	import ddt.game.GameViewBase;
	import ddt.game.animations.AnimationLevel;
	import ddt.game.animations.AnimationSet;
	import ddt.game.animations.BaseSetCenterAnimation;
	import ddt.game.animations.ShockingSetCenterAnimation;
	import ddt.game.animations.SpellSkillAnimation;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.GamePlayer;
	import ddt.game.objects.SimpleObject;
	import ddt.game.smallmap.SmallMapView;
	import ddt.loader.MapLoader;
	import ddt.manager.ChatManager;
	import ddt.manager.GameManager;
	import ddt.manager.IMEManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;

	/**
	 *  
	 * @author devil
	 * 地图
	 */
	public class MapView extends Map
	{
		public static const ADD_BOX:String = "addBox";
		
		private var _game:GameInfo;
		
		private var _info:MapInfo;

		private var _animateSet:AnimationSet;
		
		private var _minX:Number;
		
		private var _minY:Number;
		
		private var _smallMap:SmallMapView;
		
		private var _actionManager:ActionManager;
		
		public var gameView:GameViewBase;
		
		public var currentFocusedLiving:GameLiving;
		
		private var _currentTurn : int;
		public function set currentTurn(i : int) : void
		{
			_currentTurn = i;
			dispatchEvent(new GameEvent(GameEvent.TURN_CHANGED,_currentTurn));
		}
		public function get currentTurn() : int
		{
			return _currentTurn;
		}
		private var _currentFocusedLiving:GameLiving;
		private var _currentFocusLevel:int;
		public function requestForFocus(target:GameLiving,level:int = AnimationLevel.LOW):void{
			if(GameManager.Instance.Current == null) 
			{
				return;
			}
			var x:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
			if(_currentFocusedLiving){
				if(Math.abs(target.pos.x-x)>Math.abs(_currentFocusedLiving.x - x)){
					return;
				}
			}
			if(level<_currentFocusLevel){
				return;
			}

			_currentFocusedLiving = target;
			_currentFocusLevel = level;
			animateSet.addAnimation(new BaseSetCenterAnimation(_currentFocusedLiving.x,_currentFocusedLiving.y - 150,0,false,AnimationLevel.MIDDLE));
		}
		public function cancelFocus(target:GameLiving = null):void{
			if(target == null){
				_currentFocusedLiving = null;
				_currentFocusLevel = 0;
			}
			if(target == _currentFocusedLiving){
				_currentFocusedLiving = null;
				_currentFocusLevel = 0;
			}
		}
		private var _currentPlayer:TurnedLiving;
		
		public function get currentPlayer():TurnedLiving
		{
			return _currentPlayer;
		}
		
		public function set currentPlayer(value:TurnedLiving):void
		{
			_currentPlayer = value;
		}
		
		public function get game():GameInfo
		{
			return _game;
		}
		
		public function get info():MapInfo
		{
			return _info;
		}
		
		public function get smallMap():SmallMapView
		{
			return _smallMap;
		}
		
		public function get animateSet():AnimationSet
		{
			return _animateSet;
		}
		
		private var _smallObjs:Array;
		private var _skyBitmap:Bitmap;
		public function MapView(game:GameInfo,loader:MapLoader)
		{
			_game = game;
			_skyBitmap = new Bitmap(loader.backBmp.bitmapData);
			var f:Ground = loader.foreBmp ? new Ground(loader.foreBmp.bitmapData,true) : null;
			var s:Ground = loader.deadBmp ? new Ground(loader.deadBmp.bitmapData,false):null;
			var info:MapInfo = loader.info;
			super(_skyBitmap,f,s);
			airResistance = info.DragIndex;
			gravity = info.Weight;
			_info = info;
			_animateSet = new AnimationSet(this,Config.GAME_WIDTH,Config.GAME_HEIGHT);

			_smallMap = new SmallMapView(this);
			_smallMap.update();
			
			_smallObjs = new Array();
			_minX = - bound.width + Config.GAME_WIDTH;
			_minY = - bound.height + Config.GAME_HEIGHT;
			
			_actionManager = new ActionManager();
			
			setCenter(_info.ForegroundWidth/2,_info.ForegroundHeight/2,false);
			addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		private function __mouseClick(event:MouseEvent):void
		{
			stage.focus = this;
		}
		
		/**
		 * 播放必杀技能 
		 */		
		public function spellKill(player:GamePlayer):void
		{
			var skill:SpellSkillAnimation = new SpellSkillAnimation(player.x,player.y,Config.GAME_WIDTH,Config.GAME_HEIGHT,_info.ForegroundWidth,_info.ForegroundHeight,player,gameView);
			animateSet.addAnimation(skill);	
			SoundManager.Instance.play("097");
		}
		
		
		
		public function get isPlayingMovie() : Boolean
		{
			return _animateSet.current is SpellSkillAnimation;
			
		}
		
		override public function set x(value:Number):void
		{
			super.x = value < _minX ? _minX : (value > 0 ? 0 : value);
		}
		
		override public function set y(value:Number):void
		{
			super.y = value < _minY ? _minY : (value > 0 ? 0 : value); 
		}
		
		public function setCenter(px:Number,py:Number,isTween:Boolean):void
		{
			_animateSet.addAnimation(new BaseSetCenterAnimation(px,py,50,!isTween,AnimationLevel.MIDDLE));
		}
		public function scenarioSetCenter(px:Number,py:Number,type:int):void{
			switch(type){
				case 3:
					_animateSet.addAnimation(new ShockingSetCenterAnimation(px,py,50,false,AnimationLevel.HIGHT,9));
					break;
				case 2:
					_animateSet.addAnimation(new ShockingSetCenterAnimation(px,py,165,false,AnimationLevel.HIGHT,9));
					break;
				default:
					_animateSet.addAnimation(new BaseSetCenterAnimation(px,py,100,false,AnimationLevel.HIGHT));
					break;
			}
		}
		public function livingSetCenter(px:Number,py:Number,isTween:Boolean):void
		{
			_animateSet.addAnimation(new BaseSetCenterAnimation(px,py,25,!isTween,AnimationLevel.HIGHT));
		}
		
		public function act(action:BaseAction):void
		{
			_actionManager.act(action);
		}
	
		/**
		 * 地图更新 
		 * 
		 */		
		override protected function update():void
		{
			super.update();
			if(!ChatManager.Instance.input.visible)
			{
				IMEManager.disable();
				if(stage && stage.focus == null)stage.focus = this;
			}
			if(_animateSet.update())
			{
				updateSky();
			}
			_actionManager.execute();
			checkOverFrameRate();
		}
		
		private var _frameRateCounter:int;
		public static const FRAMERATE_OVER_COUNT:int = 25;
		private var _currentFrameRateOverCount:int = 0;
		public static const OVER_FRAME_GAPE:int = 46;
		private var _frameRateAlert:HConfirmDialog;
		private function checkOverFrameRate():void
		{
			if(SharedManager.Instance.hasCheckedOverFrameRate)return;
			if(_game.PlayerCount <= 4) return;
			if(_currentPlayer && _currentPlayer.LivingID == _game.selfGamePlayer.LivingID)return;
			var currentTime:int = getTimer();
			if(currentTime - _frameRateCounter > OVER_FRAME_GAPE && _frameRateCounter != 0)
			{
				_currentFrameRateOverCount++;
				if(_currentFrameRateOverCount > FRAMERATE_OVER_COUNT)
				{
					if(_frameRateAlert == null && SharedManager.Instance.showParticle)
					{
						_frameRateAlert = HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.game.map.smallMapView.slow"),true,overFrameOk,null);
//						_frameRateAlert = HConfirmDialog.show("提示:","系统检测到您的游戏运行不够流畅\n是否关闭游戏特效来加快游戏速度",true,overFrameOk,null);
						SharedManager.Instance.hasCheckedOverFrameRate = true;
						SharedManager.Instance.save();
					}
				}
			}else
			{
				_currentFrameRateOverCount = 0;
			}
			_frameRateCounter = currentTime;
		}
		
		private function overFrameOk():void
		{
			SharedManager.Instance.showParticle = false;
			_frameRateAlert.dispose();
			_frameRateAlert = null;
		}

		/**
		 * 设置背景图相对前景图坐标 
		 * 
		 */		
		private function updateSky():void
		{
			var _skyHScalePercent:Number = (sky.height * scaleY - Config.GAME_HEIGHT) / (bound.height * scaleY - Config.GAME_HEIGHT);
			var _skyWScalePercent:Number = (sky.width * scaleX - Config.GAME_WIDTH) / (bound.width * scaleX - Config.GAME_WIDTH);
			_skyHScalePercent = isNaN(_skyHScalePercent) || _skyHScalePercent == Number.NEGATIVE_INFINITY || _skyHScalePercent == Number.POSITIVE_INFINITY ? 1 : _skyHScalePercent;
			_skyWScalePercent = isNaN(_skyWScalePercent) || _skyWScalePercent == Number.NEGATIVE_INFINITY || _skyWScalePercent == Number.POSITIVE_INFINITY ? 1 : _skyWScalePercent;
			_sky.y = -y + y * _skyHScalePercent;
			_sky.x = -x + x * _skyWScalePercent;
			_smallMap.setScreenPos(x,y);
		}
		//包括living和objects
		private var _objects:Dictionary = new Dictionary();
		public function getPhysical(id:int):PhysicalObj
		{
			return _objects[id];
		}
		
		override public function addPhysical(phy:Physics):void
		{
			super.addPhysical(phy)
			if(phy is PhysicalObj)
			{
				var obj:PhysicalObj = phy as PhysicalObj;
				_objects[obj.Id] = obj;
				if(obj.smallView)
				{
					_smallMap.addObj(obj.smallView);
					_smallMap.updatePos(obj.smallView,obj.pos);
				}
			}
		}
		
		public function bringToFront($info : Living) : void
		{
			if(!$info)return;
			var phy : Physics = _objects[$info.LivingID] as Physics;                                     
			if(phy)super.addPhysical(phy);
		}
		public function phyBringToFront(phy:PhysicalObj):void{
			if(phy)
				super.addChild(phy);
		}
		override public function removePhysical(phy:Physics):void
		{
			super.removePhysical(phy);
			if(phy is PhysicalObj)
			{
				var obj:PhysicalObj = phy as PhysicalObj;
				if(_objects[obj.Id])
				{
					delete _objects[obj.Id];
				}
				if(obj.smallView)
				{
					_smallMap.removeObj(obj.smallView);
				}
			}
		}
		
		override public function addMapThing(phy:Physics):void
		{
			super.addMapThing(phy);
			if(phy is PhysicalObj)
			{
				var obj:PhysicalObj = phy as PhysicalObj;
				_objects[obj.Id] = obj;
				if(obj.smallView)
				{
					_smallMap.addObj(obj.smallView);
					_smallMap.updatePos(obj.smallView,obj.pos);
				}
			}
		}
		
		override public function removeMapThing(phy:Physics):void
		{
			super.removeMapThing(phy);
			if(phy is PhysicalObj)
			{
				var obj:PhysicalObj = phy as PhysicalObj;
				if(_objects[obj.Id])
				{
					delete _objects[obj.Id];
				}
				if(obj.smallView)
				{
					_smallMap.removeObj(obj.smallView);
				}
			}
		}
		
		public function get actionCount ():int
		{
			return _actionManager.actionCount;
		}
		
		public function executeAtOnce():void
		{
			_actionManager.executeAtOnce();
			_animateSet.clear();
		}

		override public function dispose():void
		{
			super.dispose();
			_skyBitmap.bitmapData.dispose();
			_smallMap.dispose();
			_animateSet.dispose();
			_actionManager.clear();
			if(_frameRateAlert)_frameRateAlert.dispose();
			_frameRateAlert = null;
		}
	}
}