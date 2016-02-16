package ddt.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.Config;
	import ddt.data.Direction;
	import ddt.data.GameInfo;
	import ddt.data.game.Living;
	import ddt.data.game.Player;
	import ddt.data.game.TurnedLiving;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.game.actions.ViewEachPlayerAction;
	import ddt.game.map.MapView;
	import ddt.game.objects.GameLiving;
	import ddt.game.objects.GameLocalPlayer;
	import ddt.game.objects.GamePlayer;
	import ddt.game.playerThumbnail.PlayerThumbnailController;
	import ddt.manager.ChatManager;
	import ddt.manager.EnthrallManager;
	import ddt.manager.GameManager;
	import ddt.manager.IMEManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SharedManager;
	import ddt.manager.StateManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.characterII.GameCharacter;
	import ddt.view.common.BuggleView;
	import ddt.view.enthrall.EnthrallView;

	/**
	 *　进入游戏界面 
	 * @author SYC
	 * 
	 */
	public class GameViewBase extends BaseStateView
	{
		/**
		 * 上，下，左，右四个箭头  
		 */		
		protected var _arrowLeft:SpringArrowView;
		protected var _arrowRight:SpringArrowView;
		protected var _arrowUp:SpringArrowView;
		protected var _arrowDown:SpringArrowView;
		
		
		
		protected var _arrow:ArrowViewIII;
		protected var _energy:EnergyViewIII;	
		
		protected var _selfPropBar:SelfPropContainBar;
		
		protected var _selfUsedProp:PlayerStateContainer;
		
		protected var _leftCiteII:LeftPlayerCartoonView;
		
		protected var _barrier : DungeonInfoView;//关卡信息
		protected var _mapContainer:Sprite;
		protected var _webSpeed:WebSpeedView;
		protected var _enthrallment:EnthrallView;
		protected var randomArrowOffset:Number = 16;
		protected var currentArrowOffset:Number = 0;
	
		/**
		 * 风向标 
		 */		
		protected var _vane:VaneView;
		/**
		 *  右下角tool工具条
		 */		 
		protected var _tool:ToolStripView;
		protected var _players:Dictionary;
		
		protected var _map:MapView;
		
		protected var _rightPropItem:RightPropView;
		protected var _gameInfo:GameInfo;
		
		protected var pathSprite:Sprite;
//		protected var pathManager:CalcBallPathCreator;
		protected var _selfGamePlayer:GameLocalPlayer;
		
//		private var viewVideoBtn:ViewVideoButton;
		
		protected var _playerThumbnailLController:PlayerThumbnailController;
		
		public function GameViewBase()
		{
			super();
		}
		
		override public function prepare():void
		{
			super.prepare();
			_mapContainer = new Sprite();
			
			//由于有对象无法从内存中删除的问题，所以放在prepare中，只调用一次。
			
		}
		
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev,data);
			
			ChatManager.isInGame = true;
			
			_tool = new ToolStripView();
			_tool.x = Config.GAME_WIDTH;
			_tool.y = Config.GAME_HEIGHT;
			
//			UIManager.clear();
			TipManager.clearNoclearLayer();
			
			addChild(_mapContainer);
			
			BuggleView.instance.hide();
			
			PlayerManager.gotoState = StateType.ROOM;
			PlayerManager.Instance.Self.TempBag.clearnAll();
			
			_gameInfo = GameManager.Instance.Current;
			
			for each(var player:Living in _gameInfo.livings)
			{
				if(player is Player)
				{
					Player(player).isUpGrade = false;
					Player(player).LockState = false;
				}
			}
			
			if(_isTrainer || _gameInfo.roomType == 10)
			{
				_tool.enableExit = false;
			}
			else
			{
				_tool.enableExit = true;
			}
			
			_map = newMap();
			_map.gameView = this;
			_mapContainer.addChild(_map);	
			
			_map.smallMap.x = Config.GAME_WIDTH;
			_map.smallMap.y = 0;
			addChild(_map.smallMap);
			_map.smallMap.hideSpliter();
			
			_arrow = new ArrowViewIII(GameManager.Instance.Current.selfGamePlayer); 
			currentArrowOffset = Math.random()*randomArrowOffset;
//			_arrow.x = currentArrowOffset + 7;
			_arrow.x = 15;
			_arrow.y = Config.GAME_HEIGHT - _arrow.height + 13;
			_arrow.closeFly = _isTrainer;
			addChild(_arrow);
			
			_energy = new EnergyViewIII(GameManager.Instance.Current.selfGamePlayer,_map);
//			_energy.x = currentArrowOffset + 67;
			_energy.x = 70;
			_energy.y = Config.GAME_HEIGHT - _energy.height + 27;
			addChild(_energy);
			
			addChild(_tool);
			
			_rightPropItem = new RightPropView(_gameInfo.selfGamePlayer);
			_rightPropItem.x = Config.GAME_WIDTH - 50;
			_rightPropItem.y = 117;
			_rightPropItem.setClickEnabled(false,false);
			_rightPropItem.visible = !_isTrainer;
/*			if(_gameInfo.roomType == 10)
			{
				_rightPropItem.visible = false;
			}
*/			addChild(_rightPropItem);
			
			if(_gameInfo.roomType >= 2 && !_isTrainer && _gameInfo.roomType != 5)
			{
				_barrier = new DungeonInfoView();
				addChild(_barrier);
				_barrier.x = Config.GAME_WIDTH - 205;
				_barrier.y = 150;
			}
			
			_selfPropBar = new SelfPropContainBar(_gameInfo.selfGamePlayer);
			_selfPropBar.x = 664;
			_selfPropBar.y = Config.GAME_HEIGHT - 98;
			_selfPropBar.setClickEnabled(false,false);
			addChild(_selfPropBar);
			
			_selfUsedProp = new PlayerStateContainer(12);
			_selfUsedProp.setSize(600,90);
//			_selfUsedProp.y = Config.GAME_HEIGHT - 90;
			_selfUsedProp.y = Config.GAME_HEIGHT - 110;
			_selfUsedProp.x = 210;//665;
			_selfUsedProp.visible = false;
			_selfUsedProp.info = GameManager.Instance.Current.selfGamePlayer;
			addChild(_selfUsedProp);
			
			_leftCiteII = new LeftPlayerCartoonView();
			_leftCiteII.x = 0;
			_leftCiteII.y = 0;
			_leftCiteII.isClose = _isTrainer;
			
			_vane = new VaneView();
			var vaneX:Number = (Config.GAME_WIDTH - _vane.width) / 2 + 80;
			var vaneY:Number = 30;
			_vane.setUpCenter(vaneX,vaneY);
			addChild(_vane);
			
			
			//防沉迷状态灯
			EnthrallManager.getInstance().gameState(vaneX-VaneView.RandomVaneOffset/2);
			
			SoundManager.Instance.playGameBackMusic(_map.info.BackMusic);
			
			_arrowUp = new SpringArrowView(Direction.UP,_map);
			_arrowDown = new SpringArrowView(Direction.DOWN,_map);
			_arrowLeft = new SpringArrowView(Direction.RIGHT,_map);
			_arrowRight = new SpringArrowView(Direction.LEFT,_map);			
			addChild(_arrowUp);
			addChild(_arrowDown);
			addChild(_arrowLeft);
			addChild(_arrowRight);	
			
			_webSpeed = new WebSpeedView();
			_webSpeed.x = 924;
			_webSpeed.y = Config.GAME_HEIGHT - 39;
			addChild(_webSpeed);			

			_players = new Dictionary();
			
			_tool.init();
			_tool.chat = ChatManager.Instance.view;
			_tool.setLocalPlayer(GameManager.Instance.Current.selfGamePlayer);
			RoomManager.Instance.current.resultCard = new Array();
			
			/**
			 * 玩家状态缩略图
			 * */
			_playerThumbnailLController = new PlayerThumbnailController(_gameInfo);
			_playerThumbnailLController.x = 200;
			_playerThumbnailLController.y = 5;
			addChild(_playerThumbnailLController);
			_arrow.hideBtn.addEventListener(MouseEvent.CLICK,__hide); //bret 09.6.4
			_arrow.addEventListener(ArrowViewIII.HIDE_BAR,hideBar);
			SharedManager.Instance.addEventListener(Event.CHANGE, __soundChange);
			__soundChange(null);
			setupGameData();
			
			
			ChatManager.Instance.state = ChatManager.CHAT_GAME_STATE;
			addChild(ChatManager.Instance.view);
			
			defaultForbidDragFocus();
			initEvent();
		}
		protected function initEvent():void{
		}
		
		protected function newMap() : MapView
		{
			if(_map)
			{
				throw new Error(LanguageMgr.GetTranslation("ddt.game.mapGenerated"));
			}
			else
			{
				return new MapView(_gameInfo,_gameInfo.loaderMap);
			}
		}
		private var _isTrainer : Boolean= false;
		public function set isTrainer(b : Boolean) : void
		{
			_isTrainer = b;
		}
		private function __soundChange(evt : Event) : void
		{
			var mapSound : SoundTransform = new SoundTransform();
			if(SharedManager.Instance.allowSound)
			{
				mapSound.volume = (SharedManager.Instance.soundVolumn / 100);
				this.soundTransform = mapSound;
			}
			else
			{
				mapSound.volume = 0;
				this.soundTransform = mapSound;
			}
		}
		
		public function restoreSmallMap():void
		{
			_map.smallMap.restore();
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			_arrow.hideBtn.removeEventListener(MouseEvent.CLICK,__hide); //bret 09.6.4
			_arrow.removeEventListener(ArrowViewIII.HIDE_BAR,__hide);
			_arrow.removeEventListener(ArrowViewIII.HIDE_BAR,hideBar);
			SharedManager.Instance.removeEventListener(Event.CHANGE, __soundChange);
			_gameInfo.loaderMap = null;
			
//			_tool.setLocalPlayer(null);
			_tool.chat = null;
			_tool.dispose();
			_tool = null;
			
			_arrowDown.dispose();
			_arrowUp.dispose();
			_arrowLeft.dispose();
			_arrowRight.dispose();
			_arrowDown = null;
			_arrowLeft = null;
			_arrowRight = null;
			_arrowUp = null;

			_mapContainer.removeChild(_map);
			_map.dispose();
			_map = null;
			
			_players = null;
			
			_playerThumbnailLController.dispose();
			_playerThumbnailLController = null;
			
			_energy.dispose();
			_energy = null;
			
			_arrow.dispose();
			_arrow = null;
			
			_selfPropBar.setLocalPlayer(null);
			_selfPropBar.dispose();
			_selfPropBar = null;
			
			_selfUsedProp.setVisible(false);
			_selfUsedProp.dispose();
			_selfUsedProp = null;			

			_leftCiteII.dispose();
			_leftCiteII = null;
			
			_rightPropItem.dispose();
			_rightPropItem = null;
			
			if(_barrier)_barrier.dispose();
			_barrier = null;
			
			if(_vane.parent)
			{
				removeChild(_vane);
				_vane = null;
			}
			
			if(_webSpeed.parent)
			{
				removeChild(_webSpeed);
			}
			_webSpeed.dispose();
			_webSpeed = null;
			
			IMEManager.enable();
			
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			removeGameData();
		}
		
		/**
		 * 游戏启动 
		 * 
		 */		
		protected function setupGameData():void
		{	
			var list:Array = new Array();	
			for each(var info:Living in _gameInfo.livings)
			{
				var view:GameLiving;
				if(info is Player)
				{
					var p:Player = info as Player;
					if(p.isSelf)
					{
						view = new GameLocalPlayer(_gameInfo.selfGamePlayer,p.character,p.movie);
						_selfGamePlayer = view as GameLocalPlayer;
					}
					else 
					{
						view = new GamePlayer(p,p.character,p.movie);
					}
					if(p.movie)
					{
						p.movie.setDefaultAction(GameCharacter.STAND);
						p.movie.doAction(GameCharacter.STAND);
					}
					list.push(view);
				}
				_map.addPhysical(view);
				_players[info] = view;
			}
			_map.wind =  GameManager.Instance.Current.wind;
			_map.currentTurn = 1;
			_vane.initialize();	
			_vane.update(_map.wind);
			_map.act(new ViewEachPlayerAction(_map,list));
		}
		
		private function removeGameData():void
		{
			for each(var view:GameLiving in _players)
			{
				view.dispose();
				delete _players[view.info]
			}
			_players = null;
		}
		public function addLiving($living : Living):void
		{
			
		}
		public function setCurrentPlayer(info:Living):void
		{
			_leftCiteII.info = info;
			_map.bringToFront(info);
			if(_map.currentPlayer && !(info is TurnedLiving))
			{
				_map.currentPlayer.isAttacking = false;
				_map.currentPlayer = null;
			}else
			{
				_map.currentPlayer = info as TurnedLiving;
			}
			_selfUsedProp.clearItems();
			addChildAt(_leftCiteII,this.numChildren-3);
		}
		
		public function updateControlBarState(info:Living):void
		{
			if(GameManager.Instance.Current == null)
			{
				return;//因为有时候在退出游戏的时候会先吧current设为Null，才会执行到这里来，所以这里判断一下
			}
			if(GameManager.Instance.Current.selfGamePlayer.LockState)
			{
				setPropBarClickEnable(false,true);
				return;
			}
			if((info is TurnedLiving) && info.isLiving && GameManager.Instance.Current.selfGamePlayer.canUseProp(info as TurnedLiving))
			{
				setPropBarClickEnable(true,false);
			}
			else
			{
				if(!GameManager.Instance.Current.selfGamePlayer.isLiving && info.isSelf)
				{
					setPropBarClickEnable(false,true);
				}
				else if(!GameManager.Instance.Current.selfGamePlayer.isLiving && GameManager.Instance.Current.selfGamePlayer.team != info.team)
				{
					setPropBarClickEnable(false,true);
				}else
				{
					setPropBarClickEnable(true,false);
				}
			}
		}
		protected function setPropBarClickEnable(clickAble:Boolean,isGray:Boolean):void
		{
			if(_selfPropBar)
				_selfPropBar.setClickEnabled(clickAble,isGray);
			if(_rightPropItem)
				_rightPropItem.setClickEnabled(clickAble,isGray);
			
		}
		public function gameOver():void
		{
			_tool.gameOver();
			SoundManager.Instance.stopMusic();
			setPropBarClickEnable(false,false);
			_selfUsedProp.clearItems();
			_leftCiteII.gameOver();
			_leftCiteII.visible = false;
		}
		
		public function gotoGameOverState():void
		{
			_tool.mouseChildren = false;
			if(StateManager.nextState == null)
			{
				StateManager.setState(StateType.FIGHTING_RESULT,_gameInfo);
			}
		}
		
		public function gotoMissionOverState():void
		{
			_tool.mouseChildren = false;
			if(StateManager.nextState == null)
			{
				StateManager.setState(StateType.MISSION_RESULT,_gameInfo);
			}
		}
		
		private function hideBar(event:Event):void
		{
			__hide(null);
		}
		
		/* 隐藏工具条 Freeman 10.7.16 */
		private function __hide(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!_arrow.hideState)
			{
				_arrow.alpha = _tool.alpha = _energy.alpha = _selfPropBar.alpha = _rightPropItem.alpha =   .5;
			}
			else
			{
				_arrow.alpha = _tool.alpha = _energy.alpha = _selfPropBar.alpha = _rightPropItem.alpha = 1;
			}
			_arrow.hideState =! _arrow.hideState;
		}
//		protected function set enableArrow(b : Boolean) : void
//		{
//			_arrow.enableArrow = b;
//		}
		protected function set barrierInfo(evt : CrazyTankSocketEvent) : void
		{
			if(_barrier)_barrier.barrierInfoHandler(evt);
		}
		
		protected function set arrowHammerEnable(b : Boolean) : void
		{
			_arrow.hammerEnable = b;
		}
		public function blockHammer():void{
			_arrow.blockHammer();
		}
		public function allowHammer():void{
			_arrow.allowHammer();
		}
		public function gotoAndPlayAsset(i : int,$visible : Boolean = true) : void
		{
			
		}
		public function gotoAndStopAsset(i : int,$visible : Boolean = true) : void
		{
			
		}
		
		protected function defaultForbidDragFocus() : void
		{
			
		}

	}
}