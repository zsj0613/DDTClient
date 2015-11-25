package ddt.gameLoad
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.crazyTank.view.roomloading.RoomLoadingBGAsset;
	import road.data.DictionaryEvent;
	import road.loader.LoaderManager;
	import road.utils.ClassUtils;
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	import tank.assets.ScaleBMP_15;
	import tank.assets.ScaleBMP_7;
	import tank.assets.ScaleBMP_8;
	import ddt.data.GameInfo;
	import ddt.data.RoomInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.game.map.MapShowIcon;
	import ddt.loader.MapLoader;
	import road.loader.BaseLoader;
	import ddt.manager.BallManager;
	import ddt.manager.ChatManager;
	import ddt.manager.MapManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.UserGuideManager;
	import ddt.socket.GameInSocketOut;
	import ddt.states.StateType;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.GameCharacter;
	public class RoomLoading extends RoomLoadingBGAsset
	{
		private var _list:SimpleGrid;
		//单元格
		private var _items:Array;
		private var _leaveTimer:Timer;
		private var _currentLeftTime:int;
		private var _countSecond:int;
		
		private var _selfFinish:Boolean;
		private var _game:GameInfo;
		private var _chat:Sprite;
		
		private var _mapShowIcon:MapShowIcon;
		private var _room:RoomInfo;
		
		private var _bottomBMP1:ScaleBMP_7;
		private var _bottomBMP2:ScaleBMP_8;
		private var _bottomBMP3:ScaleBMP_15;
		
		public  var sendData : Boolean = true;
		/**
		 * list["players"][team][1]:player
		 * list["weapons"]:weapons
		 * list["map"]:mapinfo
		 */	
		public function RoomLoading(info:GameInfo,chat:Sprite)
		{
			super();
			_game = info;
			_chat = chat;
			_room = RoomManager.Instance.current;
			init();
			initEvent();
		}
		
		override public function get width():Number
		{
			return 600;
		}
		override public function get height():Number
		{
			return 500;
		}
		 
		private function init():void
		{
			mapMask.visible = false;
			initMsgBoard();//初始化随即小贴士
			TipManager.clearTipLayer();
			addChild(_chat);
			
			_bottomBMP1 = new ScaleBMP_7();
			addChildAt(_bottomBMP1 , 0);
			_bottomBMP1.x = pos_1.x;
			_bottomBMP1.y = pos_1.y;
			removeChild(pos_1);
			
			_bottomBMP2 = new ScaleBMP_8();
			addChildAt(_bottomBMP2 , 0);
			_bottomBMP2.x = pos_2.x;
			_bottomBMP2.y = pos_2.y;
			removeChild(pos_2);
			
			_bottomBMP3 = new ScaleBMP_15();
			addChildAt(_bottomBMP3 , 0);
			_bottomBMP3.x = pos_3.x;
			_bottomBMP3.y = pos_3.y;
			removeChild(pos_3);
			
			_countSecond = 60;
			_currentLeftTime = _countSecond;
			_items = [];
			_list = new SimpleGrid(251,89,2);
			ComponentHelper.replaceChild(this,list_pos,_list);
			_selfFinish = false;
			initLoadingItems();
			for each(var roomPlayer:RoomPlayerInfo in _game.roomPlayers)
			{
				roomPlayer.setWeaponInfo();
				roomPlayer.setDeputyWeaponInfo();
				for(var i:int = ((roomPlayer.team + 1) % 2); i < _items.length; i += 2)
				{
					if(_items[i].info == null)
					{
						_items[i].info = roomPlayer;
						break;
					}
				}
				
				LoaderManager.Instance.creatAndStartLoad(PathManager.solveBombSwf(roomPlayer.currentWeapInfo.commonBall),BaseLoader.MODULE_LOADER);
				LoaderManager.Instance.creatAndStartLoad(PathManager.solveBombSwf(roomPlayer.currentWeapInfo.skillBall),BaseLoader.MODULE_LOADER);
				
				if(roomPlayer.hasDeputyWeapon())
				{
					if(roomPlayer.currentDeputyWeaponInfo.ballId != 0)
						LoaderManager.Instance.creatAndStartLoad(PathManager.solveBombSwf(roomPlayer.currentDeputyWeaponInfo.ballId),BaseLoader.MODULE_LOADER);
				}
				
				if(roomPlayer.shouldReloadGameCharacter())
				{
					if(roomPlayer.movie != null)
					{
						roomPlayer.movie.dispose();
					}
					roomPlayer.movie = CharactoryFactory.createCharacter(roomPlayer.info,CharactoryFactory.GAME) as GameCharacter;
					roomPlayer.movie.show(true,-1);
				}
			}
//			加载怪物动画		
			for(var j:int = 0;j<_game.neededMovies.length;j++)
			{
				_game.neededMovies[j].startLoad();
			}
			
			//要使用LoadMapId,不能使用MapId
			_game.loaderMap = new MapLoader(MapManager.getMapInfo(_game.mapIndex));
			_game.loaderMap.load();
			//特殊子弹
			if(!ClassUtils.hasDefinition(BallManager.solveBallWeaponMovieName(1)))
			{
				LoaderManager.Instance.creatAndStartLoad(PathManager.solveBombSwf(1),BaseLoader.MODULE_LOADER);
			}
			
			_leaveTimer = new Timer(1000,64);
			_leaveTimer.addEventListener(TimerEvent.TIMER,__leaveTimer);
			_leaveTimer.start();
			time_txt.selectable = false;
			time_txt.mouseEnabled = false;
			time_txt.text = _currentLeftTime.toString();
		
			/* 房间模式、战斗模式 bret chocolate 2009.11.4 E:JL/*/
			if(_game.gameType == 1)//公会战
			{
				fireMode.gotoAndStop(3);
			}
			else if((_game.gameType == 5)||(_game.gameType == 6)||(_game.gameType == 7)){//PVE，5探险6boss7副本
				fireMode.gotoAndStop(_game.gameType);
			}else
			{
				fireMode.gotoAndStop(2);//组对战
			}
		}
		
		private function initLoadingItems():void
		{
			for(var k:int = 0; k < 8; k++)
			{
				var item:RoomLoadingItem = new RoomLoadingItem();
				_list.appendItem(item);
				_items.push(item);
			}
		}
		
		/*获取随即小贴士
		  wicki 09.07.06
		*/
		private function initMsgBoard():void
		{
			/** PVE房间信息 @welly
			 * 10-1-7 取消.
			*/
			msgTxt.visible = true;
			msgTxt.gotoAndStop(Math.ceil(Math.random()*25));
		}
		
		private function __mapIconLoaded(evt:Event):void{
			_mapShowIcon.x = 610;
			_mapShowIcon.y = 420-_mapShowIcon.height;
			_mapShowIcon.mask = mapMask;
		}
		private function initEvent():void
		{
			_game.livings.addEventListener(DictionaryEvent.REMOVE,__removePlayer);
		}
		private function checkGameLoad():Boolean{
			if(PlayerManager.selfRoomPlayerInfo.loadingProgress > 0.99){
				return true;
			}
			return false;
		}
		private function __leaveTimer(evt:TimerEvent):void
		{	
			_selfFinish = checkProgress();
			if(_selfFinish)this.dispatchEvent(new Event(Event.COMPLETE));
			_currentLeftTime--;
			if(_currentLeftTime <= 0)
			{
				time_txt.text = "0";
				if(!_selfFinish)
				{
					if(_room)
					{
						StateManager.setState(_room.backRoomListType);
					}
					else
					{
						StateManager.setState(StateType.ROOM_LIST);
					}
				}
			}
			else 
			{
				time_txt.text = _currentLeftTime.toString();
			}
		}
		
		private function checkProgress():Boolean
		{
			var total:int = 0;
			var finished:int =0;
			for each(var info:RoomPlayerInfo in _game.roomPlayers)
			{
				if(info.character)
				{
					if(info.character.completed)
					{
						//global.traceStr("info.character.completed");
						finished ++;
					}
					total ++;
				}
				if(info.movie)
				{
					if(info.movie.completed)
					{
						//global.traceStr("info.movie.completed");
						finished ++;
					}
					total ++;
				}
				
				if(ClassUtils.hasDefinition(BallManager.solveBallWeaponMovieName(info.currentWeapInfo.commonBall)))
				{
					//global.traceStr("MainWeapon.completed");
					finished ++;
				}
				total ++;
				
				if(info.hasDeputyWeapon())
				{
					if(info.currentDeputyWeaponInfo.ballId != 0)
					{
						if(ClassUtils.hasDefinition(BallManager.solveBallWeaponMovieName(info.currentDeputyWeaponInfo.ballId)))
						{
							//global.traceStr("DeputyWeapon.completed");
							finished ++;
						}
						total ++;
					}
					
				}
				
				if(ClassUtils.hasDefinition(BallManager.solveBallWeaponMovieName(info.currentWeapInfo.skillBall)))
				{
					//global.traceStr("MainWeaponSkill.completed");
					finished ++;
				}
				total ++;
			}
			
			for(var i:int = 0;i<_game.neededMovies.length;i++)
			{
				if(ClassUtils.hasDefinition(_game.neededMovies[i].classPath))
				{
					//global.traceStr("neededMovies.completed"+i.toString());
					finished ++;
				}//else{
					//trace(_game.neededMovies[i].classPath);
				//}
				total ++;
			}
			
			if(_game.loaderMap.completed)
			{
				//global.traceStr("loaderMap.completed");
				finished ++;
			}
			total ++;
			
			if(ClassUtils.hasDefinition(BallManager.solveBallWeaponMovieName(1)))
			{
				//global.traceStr("solveBallWeapon1.completed");
				finished ++;
			}
			total ++;
			
			var pro:Number = int((finished / total) * 100);
//			
			if(sendData)
			{
				GameInSocketOut.sendLoadingProgress(pro);
			}
			PlayerManager.selfRoomPlayerInfo.loadingProgress = pro;
			if(total == finished)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function __removePlayer(evt:DictionaryEvent):void
		{
			for(var i:int = 0; i < _items.length; i++)
			{
				if(_items[i].info  == evt.data )
				{
					_items[i].info = null;
					break;
				}
			}
		}
		
		public function dispose():void
		{
			if(_mapShowIcon)
			{
				_mapShowIcon.dispose();
			}
			_mapShowIcon = null;
			
			_leaveTimer.removeEventListener(TimerEvent.TIMER,__leaveTimer);
			_leaveTimer.stop();
			_leaveTimer = null;
			
			_game.livings.removeEventListener(DictionaryEvent.REMOVE,__removePlayer);
			_game = null;
			
			for(var i:int = 0; i < _items.length; i++)
			{
				_items[i].dispose();
			}
			_items = null;
			
			if(_list)
			{
				if(_list.parent)_list.parent.removeChild(_list);
				_list.clearItems();
			}
			_list = null;
			
			if(_bottomBMP1)
			{
				removeChild(_bottomBMP1);
				_bottomBMP1 = null;
			}
			if(_bottomBMP2)
			{
				removeChild(_bottomBMP2);
				_bottomBMP2 = null;
			}
			if(_bottomBMP3)
			{
				removeChild(_bottomBMP3);
				_bottomBMP3 = null;
			}
			
			if(_chat && _chat.parent)
				_chat.parent.removeChild(_chat);
			_chat = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}