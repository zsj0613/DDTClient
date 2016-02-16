package ddt.game
{
	import com.hurlant.util.Memory;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.GetPropBackAsset;
	import game.crazyTank.view.GetPropCiteAsset;
	
	import phy.object.PhysicalObj;
	
	import road.comm.PackageIn;
	import road.data.DictionaryEvent;
	import road.display.AutoDisappear;
	import road.display.MovieClipWrapper;
	import road.manager.SoundManager;
	import road.utils.ClassUtils;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.data.EquipType;
	import ddt.data.GameEvent;
	import ddt.data.GameNeedMovieInfo;
	import ddt.data.game.Bomb;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.game.SimpleBoss;
	import ddt.data.game.SmallEnemy;
	import ddt.data.game.TurnedLiving;
	import ddt.data.game.mirarieffecticon.BaseMirariEffectIcon;
	import ddt.data.game.mirarieffecticon.MirariEffectIconManager;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.PropInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.PhyobjEvent;
	import tank.game.GameView.PassStortBtnAsset;
	import ddt.game.actions.ChangeBallAction;
	import ddt.game.actions.ChangeNpcAction;
	import ddt.game.actions.ChangePlayerAction;
	import ddt.game.actions.GameOverAction;
	import ddt.game.actions.MissionOverAction;
	import ddt.game.actions.ViewEachObjectAction;
	import ddt.game.objects.BombAction;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.GamePlayer;
	import ddt.game.objects.GameSamllEnemy;
	import ddt.game.objects.GameSimpleBoss;
	import ddt.game.objects.SimpleBox;
	import ddt.game.objects.SimpleObject;
	import ddt.manager.BallManager;
	import ddt.manager.EnthrallManager;
	import ddt.manager.GameManager;
	import ddt.manager.ItemManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StageFocusManager;
	import ddt.manager.StateManager;
	import ddt.manager.StatisticManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;
	import ddt.socket.GameInSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.background.BgView;
	import ddt.view.bagII.BagEvent;
	import ddt.view.items.PropItemView;

	/**
	 *　进入游戏界面 
	 * @author SYC
	 * 
	 */
	public class GameView extends GameViewBase//implements IGameView
	{
		
		protected var _msg:String = "";
		protected var _tipItems : Dictionary;
		protected var _tipLayers : Sprite;
		private var _passStoryBtn:HBaseButton;
		
		public function GameView()
		{
			super();
		}
		
		override public function prepare():void
		{
			super.prepare();
			
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			Memory.gc();
			BgView.Instance.showGameBack(true);
			StageFocusManager.Instance().setActiveFocus(_map);
			_gameInfo.resetResultCard();
			_gameInfo.livings.addEventListener(DictionaryEvent.REMOVE,__removePlayer);
			PlayerManager.Instance.Self.FightBag.addEventListener(BagEvent.UPDATE,__selfObtainItem);
			PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,__updateProp);
			PlayerManager.Instance.Self.TempBag.addEventListener(BagEvent.UPDATE,__getTempItem);
			PlayerManager.Instance.Self.buffInfo.addEventListener(DictionaryEvent.ADD,__updateBuff);
			PlayerManager.Instance.Self.buffInfo.addEventListener(DictionaryEvent.ADD,__updateBuff);
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,__shoot);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,__startMove);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,__playerChange);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_BLOOD,__playerBlood);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_VANE,__changWind);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_HIDE,__playerHide);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,__playerNoNole);/**免坑**/
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOCK_STATE,__playerLockStateChange);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROP,__playerUsingItem);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_DANDER,__dander);	
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,__changeShootCount);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SUICIDE,__suicide);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,__beginShoot);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_BALL,__changeBall);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_FROST,__forstPlayer);	
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_OVE,__missionOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_OVER,__gameOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_MOVIE,__playMovie);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_SOUND,__playSound);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD_RESOURCE,__loadResource);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_LIVING,__addLiving);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_MOVETO,__livingMoveto);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_FALLING,__livingFalling);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_JUMP,__livingJump);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BEAT,__livingBeat);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SAY,__livingSay);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,__livingRangeAttacking);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,__livingDirChanged);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,__focusOnObject);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_STATE,__changeState);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BARRIER_INFO,  __barrierInfoHandler);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS,   __addMapThing);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE,   __updatePhysicObject);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,__removePhysicObject);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_PICTURE,  __mirariEffectShowHandler);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,  __addTipLayer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FORBID_DRAG,__forbidDragFocus);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOP_LAYER,__topLayer);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONTROL_BGM,__controlBGM);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,__onLivingBoltmove);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHANGE_TARGET,__onChangePlayerTarget);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,__showPassStoryBtn);
			GameManager.Instance.Current.addEventListener(GameEvent.WIND_CHANGED,__windChanged);
			StatisticManager.Instance().startAction(StatisticManager.GAME,"yes");
			_tipItems = new Dictionary(true);
			if(!UserGuideManager.Instance.getIsFinishTutorial(30)){
				userGuide();
			}
		}
		private function userGuide():void{
			addEventListener(PhyobjEvent.CHANGE,__onUserGuide);
		}
		private function __onUserGuide(evt:PhyobjEvent):void{
			switch(evt.action){
				case "tip1":
					UserGuideManager.Instance.showBattle(1);
					break;
			}
		}
		private function __windChanged(e:GameEvent):void
		{
			_map.wind = e.data.wind;
			_vane.update(_map.wind,e.data.isSelfTurn);
		}
	
		override public function getType():String
		{
			return StateType.FIGHTING;
		}

		override public function leaving(next:BaseStateView):void
		{
			Memory.gc();
			BgView.Instance.showGameBack(false);
			SoundManager.Instance.stopMusic();
			TipManager.clearTipLayer();
			TipManager.clearNoclearLayer();
			UIManager.clear();
			super.leaving(next);
			EnthrallManager.getInstance().outGame();//防沉迷 状态灯
			_gameInfo.livings.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
			_gameInfo.removeAllMonsters();
			StageFocusManager.Instance().setActiveFocus(null);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT,__shoot);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_START_MOVE,__startMove);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,__playerChange);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_BLOOD,__playerBlood);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_VANE,__changWind);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_HIDE,__playerHide);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_NONOLE,__playerNoNole);/**免坑**/
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOCK_STATE,__playerLockStateChange);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_PROP,__playerUsingItem);	
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_DANDER,__dander);				
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_ADDATTACK,__changeShootCount);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SUICIDE,__suicide);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,__beginShoot);		
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_BALL,__changeBall);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_FROST,__forstPlayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MISSION_OVE,__missionOver);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_OVER,__gameOver);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_MOVIE,__playMovie);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAY_SOUND,__playSound);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOAD_RESOURCE,__loadResource);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_LIVING,__addLiving);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_MOVETO,__livingMoveto);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_FALLING,__livingFalling);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_JUMP,__livingJump);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BEAT,__livingBeat);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_SAY,__livingSay);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_RANGEATTACKING,__livingRangeAttacking);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DIRECTION_CHANGED,__livingDirChanged);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FOCUS_ON_OBJECT,__focusOnObject);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CHANGE_STATE,__changeState);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BARRIER_INFO,  __barrierInfoHandler);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS,  __addMapThing);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE,   __updatePhysicObject);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOX_DISAPPEAR,__removePhysicObject);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SEND_PICTURE,  __mirariEffectShowHandler);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_TIP_LAYER,  __addTipLayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FORBID_DRAG,__forbidDragFocus);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOP_LAYER,__topLayer);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONTROL_BGM,__controlBGM);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LIVING_BOLTMOVE,__onLivingBoltmove);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,__showPassStoryBtn);
			
			PlayerManager.Instance.Self.FightBag.removeEventListener(BagEvent.UPDATE,__selfObtainItem);	
			PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,__updateProp);
			PlayerManager.Instance.Self.TempBag.removeEventListener(BagEvent.UPDATE,__getTempItem);
			PlayerManager.Instance.Self.buffInfo.removeEventListener(DictionaryEvent.ADD,__updateBuff);
			PlayerManager.Instance.Self.buffInfo.removeEventListener(DictionaryEvent.ADD,__updateBuff);
			
			if(GameManager.Instance.Current)
				GameManager.Instance.Current.removeEventListener(GameEvent.WIND_CHANGED,__windChanged);
			
			for each(var obj : SimpleObject in _tipItems)
			{
				delete _tipLayers[obj.Id]
				obj.dispose();
				obj = null;
			}
			_tipItems = null;
			if(_tipLayers)
			{
				if(_tipLayers.parent)_tipLayers.parent.removeChild(_tipLayers);
			}
			_tipLayers = null;
			if(RoomManager.isRemovePlayerInRoomAndGame(next.getType()))
			{
				RoomManager.Instance.removeAndDisposeAllPlayer();
				RoomManager.Instance.current = null;
			}
			
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				GameInSocketOut.sendPlayerState(2);
			}else
			{
				GameInSocketOut.sendPlayerState(0);
			}
			
			if(_passStoryBtn)
			{
				_passStoryBtn.removeEventListener(MouseEvent.CLICK,__passStory);
				_passStoryBtn.dispose();
				_passStoryBtn = null;
			}
		}
		
		override public function addedToStage():void
		{
			super.addedToStage();
			stage.focus = _map;
			UIManager.clear();
		}
		
		override public function getBackType():String
		{
			return StateType.FIGHTING_RESULT;
		}
		
		private function __showPassStoryBtn(evt:CrazyTankSocketEvent):void
		{
			if(evt.pkg.readBoolean() && PlayerManager.selfRoomPlayerInfo && PlayerManager.selfRoomPlayerInfo.isHost)
			{
				_passStoryBtn = new HBaseButton(new PassStortBtnAsset());
				_passStoryBtn.x = 40;
				_passStoryBtn.y = 3;
				addChild(_passStoryBtn);
				_passStoryBtn.addEventListener(MouseEvent.CLICK,__passStory);
			}else
			{
				if(_passStoryBtn && _passStoryBtn.parent)
				{
					_passStoryBtn.parent.removeChild(_passStoryBtn);
				}
			}
		}
		
		private function __passStory(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_passStoryBtn.visible = false;
			GameInSocketOut.sendPassStory();
		}
		
		/**
		 * 更换玩家 
		 * @param event
		 * 
		 */	
		 private var _soundPlayFlag:Boolean;
		 private var _ignoreSmallEnemy:Boolean;
		protected function __playerChange(event:CrazyTankSocketEvent):void
		{
			_map.currentFocusedLiving = null;
			var info:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info is TurnedLiving)
			{
				_ignoreSmallEnemy = false;
				/**
				* 这里这样的操作可能会导致其中的某一个changeplayer没有执行
				* 但是既然已经死了就不会有turn
				*/				
				if(!info.isLiving)
				{
					setCurrentPlayer(null);
					return;
				}
				event.executed = false;
				_soundPlayFlag = true;
				_map.act(new ChangePlayerAction(_map,info as TurnedLiving,event,event.pkg));
			}
			else
			{
				_map.act(new ChangeNpcAction(this,_map,info as Living,event,event.pkg,_ignoreSmallEnemy));
				if(!_ignoreSmallEnemy)
				{
					_ignoreSmallEnemy = true;
				}
			}
		}
		
		private function __playMovie(event:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(living)
			{
				var type:String = event.pkg.readUTF();
				living.playMovie(type);
				_map.bringToFront(living);
			}
		}
		
		protected function __addLiving(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var livingType:int = pkg.readByte();
			var ID:int = pkg.readInt();
			var Name:String = pkg.readUTF();
			var ActionMovie:String = pkg.readUTF();
			var specificAction:String = pkg.readUTF();
			var Pos:Point = new Point(pkg.readInt(),pkg.readInt());
			var currentHP:int = pkg.readInt();
			var MaxBoold:int = pkg.readInt();
			var team:int = pkg.readInt();
			var direction: int =  pkg.readByte();
			var living:Living;
			var gameLiving:GameLiving;
		
			if(_map.getPhysical(ID)){
				_map.getPhysical(ID).dispose();
			}
			if(livingType != 4 && livingType != 5 && livingType != 6)
			{
				living = new SmallEnemy(ID,team,MaxBoold);
				living.typeLiving = livingType;
				living.actionMovieName = ActionMovie;
				living.direction = direction;
				living.pos = Pos;
				living.name = Name;
				_gameInfo.addGamePlayer(living);
				gameLiving = new GameSamllEnemy(living as SmallEnemy);
				
				
				if(currentHP != living.maxBlood){
					living.initBlood(currentHP);
				}
			}
			else
			{
				living = new SimpleBoss(ID,team,MaxBoold);
				living.typeLiving = livingType;
				living.actionMovieName = ActionMovie;
				living.direction = direction;
				living.pos = Pos;
				living.name = Name;
				_gameInfo.addGamePlayer(living);
				gameLiving = new GameSimpleBoss(living as SimpleBoss);
				
				if(currentHP != living.maxBlood){
					living.initBlood(currentHP);
				}
			}
			
			gameLiving.name = Name;
			_map.addPhysical(gameLiving);
			if(specificAction.length>0){
				gameLiving.doAction(specificAction);
			}else{
				gameLiving.doAction(Living.BORN_ACTION);
			}
			_playerThumbnailLController.addLiving(gameLiving);
			addChild(_playerThumbnailLController);
			if(living is SimpleBoss)
			{
				_map.setCenter(gameLiving.x,gameLiving.y - 150,false);
			}else
			{
				_map.setCenter(gameLiving.x,gameLiving.y - 150,true);
			}
		}
		
		
		private function __addTipLayer(evt : CrazyTankSocketEvent) : void
		{
			var id:int = evt.pkg.readInt();
			var type:int =  evt.pkg.readInt();
			var px:int = evt.pkg.readInt();
			var py:int = evt.pkg.readInt();
			var model:String = evt.pkg.readUTF();
			var action:String = evt.pkg.readUTF();
			var pscale:int = evt.pkg.readInt();
			var protation:int = evt.pkg.readInt();
			if(type == 10)
			{
				var tipMovie:MovieClip;
				if(ClassUtils.hasDefinition(model))
				{
					tipMovie = ClassUtils.CreatInstance(model) as MovieClip;
					var mcw:MovieClipWrapper = new MovieClipWrapper(tipMovie,false,true);
					addTipSprite(mcw)
					mcw.gotoAndPlay(1);
				}
			}
			else
			{
				var obj:SimpleObject;
				if(_tipItems[id])
				{
					obj = _tipItems[id] as SimpleObject;
				}
				
				else
				{
					obj = new SimpleObject(id,type,model,action);
					addTipSprite(obj);
				}
				obj.playAction(action);
				_tipItems[id] = obj;
			}
			
		}
		
		private function addTipSprite(obj : Sprite) : void
		{
			if(!_tipLayers)
			{
				_tipLayers = new Sprite();
				addChild(_tipLayers);
			}
			_tipLayers.addChild(obj);
			
		}
		
		private function __addMapThing(evt : CrazyTankSocketEvent) : void
		{
			var id:int = evt.pkg.readInt();
			var type:int =  evt.pkg.readInt();
			var px:int = evt.pkg.readInt();
			var py:int = evt.pkg.readInt();
			var model:String = evt.pkg.readUTF();
			var action:String = evt.pkg.readUTF();
			var pscaleX:int = evt.pkg.readInt();
			var pscaleY:int = evt.pkg.readInt();
			var protation:int = evt.pkg.readInt();
			var layer:int = evt.pkg.readInt();
			var obj:SimpleObject = null;
			switch(type)
			{
				case 1:
					obj = new SimpleBox(id,model);
					break;
				case 2:
				    obj = new SimpleObject(id,1,model,action);
					break;
				default:
					obj = new SimpleObject(id,0,model,action);
					break;
			}
			obj.x = px;
			obj.y = py;
			obj.scaleX = pscaleX;
			obj.scaleY = pscaleY;
			obj.rotation = protation;
			_map.addPhysical(obj);
			if(layer>0){
				_map.phyBringToFront(obj);
			}
		}
		
		
		private function __updatePhysicObject(evt : CrazyTankSocketEvent) :  void
		{
			var id : int = evt.pkg.readInt();
			var obj:SimpleObject = _map.getPhysical(id) as SimpleObject;
			if(!obj)obj = _tipItems[id] as SimpleObject;
			if(obj)
			{
				var action:String = evt.pkg.readUTF()
				obj.playAction(action);
			}
			var evtObj:PhyobjEvent = new PhyobjEvent(action);
			dispatchEvent(evtObj);
		}
		private function __mirariEffectShowHandler(e : CrazyTankSocketEvent) : void
		{
			var pkg:PackageIn = e.pkg;
			var livingid:int = pkg.extend1;
			var type:int = pkg.readInt();
			var enable:Boolean = pkg.readBoolean();
			var live:Living = _gameInfo.findLiving(livingid);
			if(live.playerInfo)
			{
				if(live.playerInfo.ID == _gameInfo.selfGamePlayer.playerInfo.ID)
				{
					live = _gameInfo.selfGamePlayer;
				}
			}
			
			var baseEffect:BaseMirariEffectIcon = MirariEffectIconManager.getInstance().createEffectIcon(type);
			
			if(baseEffect == null)
			{
				return;
			}
			
			if(enable)
			{
				live.handleMirariEffect(baseEffect);
			}
			else
			{
				live.removeMirariEffect(baseEffect);
			}
		}
		
		
		
		private function __removePhysicObject(event:CrazyTankSocketEvent):void
		{
			var objID:int = event.pkg.readInt();
			var obj:PhysicalObj = _map.getPhysical(objID);
			//TODO 是否需要dispose，先默认需要，以后有问题再在协议上加参数
			var needDispose:Boolean = true;
			if(obj)
			{
				_map.removePhysical(obj);
			}
			if(needDispose && obj) obj.dispose();
		}
		/**游戏画面焦点，协议为
		 * type:int
		 * x,y
		 */
		private function __focusOnObject(event:CrazyTankSocketEvent):void
		{
			var type:int = event.pkg.readInt();
			var list:Array = [];
				var obj:Object = new Object();
				obj.x = event.pkg.readInt();
				obj.y = event.pkg.readInt();
				list.push(obj);
			_map.act(new ViewEachObjectAction(_map,list,type));	
		}		
		
		private function __barrierInfoHandler(evt : CrazyTankSocketEvent) : void
		{
			barrierInfo = evt;
		}
		
		private function __livingMoveto(event:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(living)
			{
				var from:Point = new Point(event.pkg.readInt(),event.pkg.readInt());
				var pt:Point = new Point(event.pkg.readInt(),event.pkg.readInt());
				var speed:int = event.pkg.readInt();
				var actionType:String = event.pkg.readUTF();
				living.pos = from;
				living.moveTo(0,pt,0,true,actionType,speed);
				_map.bringToFront(living);
			}
		}
		
		
		private function __livingFalling(event:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(event.pkg.extend1);
			var pt:Point = new Point(event.pkg.readInt(),event.pkg.readInt());
			var speed:int = event.pkg.readInt();
			var actionType:String = event.pkg.readUTF();
			var fallType : int = event.pkg.readInt();
			living.fallTo(pt,speed,actionType,fallType);
			if(pt.y - living.pos.y >50){
				_map.setCenter(pt.x,pt.y - 150,false);//把true改为false by wicki 0407，因为波古国王下落的过程中设置焦点不断被覆盖，所以没有被成功设置到屏幕中间
			}
			_map.bringToFront(living);
			
		}
		
		private function __livingJump(event:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(event.pkg.extend1);
			var pt:Point = new Point(event.pkg.readInt(),event.pkg.readInt());
			var speed:int = event.pkg.readInt();
			var actionType:String = event.pkg.readUTF();
			var jumpType : int = event.pkg.readInt();
			living.jumpTo(pt,speed,actionType,jumpType);
			_map.bringToFront(living);
		}
		
		private function __livingBeat(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var info:Living = _gameInfo.findLiving(pkg.extend1);
			var target:Living = _gameInfo.findLiving(pkg.readInt());
			var damage:int = pkg.readInt();
			var targetBlood : int = pkg.readInt();
			var dander:int = pkg.readInt();
			var action:String = pkg.readUTF();
			var attackEffect:int = pkg.readInt();
			if(info)info.beat(action,targetBlood,target,damage,attackEffect);
			if(target.isPlayer())
			{
				(target as Player).dander = dander;
			}
		}
		
		private function __livingSay(event:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(!living.isLiving)return;
			var msg:String = event.pkg.readUTF();
			var type:int = event.pkg.readInt();
			_map.bringToFront(living);
			living.say(msg,type);
		}
		
		private function __livingRangeAttacking(e:CrazyTankSocketEvent):void
		{
			var count:int = e.pkg.readInt();
			for(var i:int = 0;i<count;i++)
			{
				var livingID:int = e.pkg.readInt();
				var demage:int = e.pkg.readInt();
				var blood : int = e.pkg.readInt();
				var dander:int = e.pkg.readInt();
				var attackEffect : int = e.pkg.readInt();
				var living:Living = _gameInfo.findLiving(livingID);
				living.updateBload(blood,attackEffect);
				living.showAttackEffect(1);
				_map.bringToFront(living);
				if(living.isSelf)
				{
					_map.setCenter(living.pos.x,living.pos.y,false);
				}
				if(living.isPlayer())
				{
					(living as Player).dander = dander;
				}
			}
		}
		
		private function __livingDirChanged(event:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(event.pkg.extend1);
			var dir:int;
			if(living)
			{
				dir = event.pkg.readInt();
				living.direction = dir;
				_map.bringToFront(living);
			}
		}
		/**
		 *玩家退出游戏 
		 * @param event
		 * 
		 */		
		private function __removePlayer(event:DictionaryEvent):void
		{
			_msg = RoomManager.Instance._removeRoomMsg;
			var info:Player = event.data as Player;
			var player:GamePlayer = _players[info];
			if(player && info)
			{
				if(_map.currentPlayer == info)
				{
					setCurrentPlayer(null);
				}	
				if(info.isSelf)
				{
					PlayerManager.gotoState = RoomManager.Instance.current.backRoomListType;
					StateManager.setState(RoomManager.Instance.current.backRoomListType);
			 	}
			 	player.dispose();
				delete _players[info];
			}
		}
		
		/**
		 * 准备开炮
		 */		
		private function __beginShoot(event:CrazyTankSocketEvent):void
		{
			if(_map.currentPlayer && _map.currentPlayer.isPlayer() && event.pkg.clientId != _map.currentPlayer.playerInfo.ID)
			{
				_map.executeAtOnce();
				_map.setCenter(_map.currentPlayer.pos.x,_map.currentPlayer.pos.y - 150,false);
			}
			setPropBarClickEnable(false,false);
		}
		
		/**
		 * 发射炮弹  
		 */	
		private function __shoot(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn =  event.pkg;
			var info:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info)
			{
				var list:Array = new Array();
				var count:Number = pkg.readInt();
				for(var i:uint = 0; i < count; i ++)
				{
					var b:Bomb = new Bomb();
					b.IsHole = pkg.readBoolean();
					b.Id = pkg.readInt();
					b.X = pkg.readInt();
					b.Y = pkg.readInt();
					b.VX = pkg.readInt();
					b.VY = pkg.readInt();
					b.Template = BallManager.findBall(pkg.readInt());
					b.Actions = new Array();
					var flyingPartical : String = pkg.readUTF();
					b.changedPartical = flyingPartical.split(",");
					var len:int = pkg.readInt();
					for(var j:int = 0; j < len; j ++)
					{
						b.Actions.push(new BombAction(pkg.readInt(),pkg.readInt(),pkg.readInt(),pkg.readInt(),pkg.readInt(),pkg.readInt()));						
					}
					list.push(b);
				}
				info.shoot(list,event);
			}
		}
		
		/**
		 * 自杀 
		 * 
		 */		
		private function __suicide(event:CrazyTankSocketEvent):void
		{
			var info : Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info)
			{
				info.die();
			}
		}
		
		/**
		 * 更换炮弹 
		 */		
		private function __changeBall(event:CrazyTankSocketEvent):void
		{
			var info: Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info && info is Player)
			{
				var player:Player = info as Player;
				var isSpecialSkill:Boolean = event.pkg.readBoolean();
				var currentBomb:int = event.pkg.readInt();
				_map.act(new ChangeBallAction(player,isSpecialSkill,currentBomb));
			}
		}
		
		/**
		 * 玩家使用道具 
		 * @param event
		 * 
		 */		
		private function __playerUsingItem(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var type:int = pkg.readByte();
			var place:int = pkg.readInt();
			var item:ItemTemplateInfo = ItemManager.Instance.getTemplateById(pkg.readInt());
            var info : Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info && item)
			{
				if(info.isPlayer())
				{
					if(!(info as Player).isSelf)
					{
						if(item.CategoryID == EquipType.OFFHAND)
						{
							var dis:DisplayObject = (info as Player).currentDeputyWeaponInfo.getDeputyWeaponIcon();
							dis.x += 7;
							(info as Player).useItemByIcon(dis);
						}else
						{
							(info as Player).useItem(item);
						}
					}
				}
				if(_map.currentPlayer && info.team == _map.currentPlayer.team)
				{
					_map.currentPlayer.addState(item.TemplateID);
				}
				if(!info.isLiving)
				{
					if(info.isPlayer())
					{
						(info as Player).addState(item.TemplateID);
					}

				}
			}
		}
		
		private function __updateProp(event:BagEvent):void
		{
			if(_rightPropItem)
			{
				_rightPropItem.setItem();
			}
		}
		
		private function __updateBuff(evt:DictionaryEvent):void
		{
			if(_rightPropItem)
			{
				_rightPropItem.setItem();
			}
		}
		
		/**
		 * 开始移动 
		 */		
		private function __startMove(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var info : Player = _gameInfo.findPlayer(event.pkg.extend1);
			if(info)info.playerMoveTo(pkg.readByte(),new Point(pkg.readInt(),pkg.readInt()),pkg.readByte(),pkg.readBoolean());
		}
		private function __onLivingBoltmove(event:CrazyTankSocketEvent):void{
			var pkg:PackageIn = event.pkg;
			var info:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info)info.pos = new Point(pkg.readInt(),pkg.readInt());
		}

		private function __playerBlood(event:CrazyTankSocketEvent):void
		{		
			var pkg:PackageIn = event.pkg;
			var type:int = pkg.readByte();
			var blood:int = pkg.readInt();
			var addValue : int = pkg.readInt();
			var info:Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info)
			{
				info.updateBload(blood,type,addValue);
			}
		}
	
		private function __changWind(event:CrazyTankSocketEvent):void
		{
			_map.wind = event.pkg.readInt()/ 10;
			_vane.update(_map.wind);
		}
		private function __playerNoNole(evt : CrazyTankSocketEvent) : void
		{
			var info : Living = _gameInfo.findLiving(evt.pkg.extend1);
			if(info)
			{
				info.isNoNole = evt.pkg.readBoolean();
			}
		}
		private function __onChangePlayerTarget(evt:CrazyTankSocketEvent):void{
			var info:Living = _gameInfo.findLiving(evt.pkg.readInt());
			_playerThumbnailLController.currentBoss = info;
		}
		private function __playerLockStateChange(evt:CrazyTankSocketEvent):void
		{
			var info:Living = _gameInfo.findLiving(evt.pkg.extend1);
			var type:int = evt.pkg.readByte();
			var lockState:Boolean = evt.pkg.readBoolean();
			if(info)
			{
				info.LockType = type;
				info.LockState = lockState;
			}
			if(info.isSelf)
			{
				if(lockState)
				{
					setPropBarClickEnable(true,true);
					arrowHammerEnable = false;
					blockHammer();
					if(info.LockType == 0)
					{
						_tool.specialEnabled = false;
					}
				}else
				{
					setPropBarClickEnable(false,false);
					_tool.specialEnabled = true;
					allowHammer();
				}
			}
			if(lockState)
			{
				_map.setCenter(info.pos.x,info.pos.y,true);
			}
		}
				
		private function __playerHide(event:CrazyTankSocketEvent):void
		{
			var info : Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info)
			{
				info.isHidden = event.pkg.readBoolean();
			}
		}
	
		private function __gameOver(event:CrazyTankSocketEvent):void
		{
			event.executed = false;
			if(_tool)_tool.enableExit = false;
			_map.act(new GameOverAction(_map,event));
			
		}
		
		private function __missionOver(event:CrazyTankSocketEvent):void
		{
			event.executed = false;
			if(_tool)_tool.enableExit = false;
			_map.act(new MissionOverAction(_map,event));
		}
		
		private function  __dander(event:CrazyTankSocketEvent):void
		{
			var info : Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info && info is Player)
			{
				var d:int = event.pkg.readInt();
				(info as Player).dander = d;
			}
		}
		
		private function __changeState(evt:CrazyTankSocketEvent):void
		{
			var info:Living = _gameInfo.findLiving(evt.pkg.extend1);
			if(info)
			{
				info.State = evt.pkg.readInt();
				_map.setCenter(info.pos.x,info.pos.y,true);
			} 
		}
		
		private function __selfObtainItem(event:BagEvent):void
		{
			for each(var info:InventoryItemInfo in event.changedSlots)
			{
				var item:PropInfo = new PropInfo(info);
				item.Place = info.Place;
				if(PlayerManager.Instance.Self.FightBag.getItemAt(info.Place))
				{
					var propback:AutoDisappear = new AutoDisappear(new GetPropBackAsset(),3);
					propback.x = _vane.x - propback.width / 2;
					propback.y = _vane.y + _vane.height + 10;
					TipManager.AddTippanel(propback);
					
					var prop:AutoDisappear = new AutoDisappear(PropItemView.createView(item.Template.Pic,62,62),3);
					prop.x = _vane.x - prop.width / 2 - 1;
					prop.y = _vane.y + _vane.height + 10;
					TipManager.AddTippanel(prop);
					
					var propcite:AutoDisappear = new AutoDisappear(new GetPropCiteAsset(),3);
					propcite.x = _vane.x - propcite.width / 2 - 3;
					propcite.y = _vane.y + _vane.height + 10;
					TipManager.AddTippanel(propcite);
				}
			}
		}
		/**
		 * 战斗中获取战利品
		 * 在聊天中显示
		 */ 
		private function __getTempItem(evt:BagEvent):void{
			
			var playSound:Boolean = GameManager.Instance.selfGetItemShowAndSound(evt.changedSlots);
			
			if(playSound && _soundPlayFlag)
			{
				_soundPlayFlag = false;
				SoundManager.Instance.play("1001");
			}
		}
		private function __forstPlayer(event:CrazyTankSocketEvent):void
		{
			var info : Living = _gameInfo.findLiving(event.pkg.extend1);
			if(info)
			{
				info.isFrozen = event.pkg.readBoolean();
			}
		}		
		
		private function __changeShootCount(event:CrazyTankSocketEvent):void
		{
			_gameInfo.selfGamePlayer.shootCount = event.pkg.readByte();
		}
		
		private function __playSound(event:CrazyTankSocketEvent):void
		{
			var soundID:String = event.pkg.readUTF();
//			SoundManager.instance.initSound(soundID);
			SoundManager.Instance.play(soundID);
		}
		
		private function __controlBGM(evt:CrazyTankSocketEvent):void
		{
			if(evt.pkg.readBoolean())
			{
				SoundManager.Instance.resumeMusic();
			}else
			{
				SoundManager.Instance.pauseMusic();
			}
		}
		
		private function __forbidDragFocus(evt:CrazyTankSocketEvent):void
		{
			var _allowDrag:Boolean = evt.pkg.readBoolean();
			_map.smallMap.allowDrag = _allowDrag;
			_arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = _allowDrag;
		}
		override protected function defaultForbidDragFocus() : void
		{
			_map.smallMap.allowDrag = true;
			_arrowLeft.allowDrag = _arrowDown.allowDrag = _arrowRight.allowDrag = _arrowUp.allowDrag = true;
		}
		private function __topLayer(evt:CrazyTankSocketEvent):void
		{
			var living:Living = _gameInfo.findLiving(evt.pkg.readInt());
			if(living) _map.bringToFront(living);
		}
		
		private function __loadResource(event:CrazyTankSocketEvent):void
		{
			var count:int = event.pkg.readInt();
			for(var i:int = 0;i<count;i++)
			{
				var needMovie:GameNeedMovieInfo = new GameNeedMovieInfo();
			 	needMovie.type = event.pkg.readInt();
			 	needMovie.path = event.pkg.readUTF();
			 	needMovie.classPath = event.pkg.readUTF();
			 	needMovie.startLoad();
			}
		}
		
	}
}