﻿﻿package
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	import road.utils.ClassUtils;
	
	//import road.loader.ModelLoader;
	//import road.model.ModelEvent;
	//import road.model.ModelManager;
	
	import ddt.hall.ChooseHallView;
	import ddt.loginstate.LoginView;
	import ddt.manager.LanguageMgr;
	import ddt.serverlist.ServerListView;
	import ddt.states.BaseStateView;
	import ddt.states.IStateCreator;
	import ddt.states.StateType;
	import ddt.view.common.WaitingView;
	
	public class BaseStateCreator implements IStateCreator
	{
		private var _dic: Dictionary = new Dictionary();
		
		public function create(type:String):BaseStateView
		{
			switch(type)
			{
				case StateType.LOGIN:
					return new LoginView();
				case StateType.SERVER_LIST:
					return new ServerListView();
				case StateType.MAIN:
					return new ChooseHallView();
//				case StateType.SHOP:
//					return new ShopController();
//				case StateType.ROOM:
//					return new RoomIIController();
//				case StateType.FIGHTING:
//					return new GameView();
//				case StateType.FIGHTING_RESULT:
//					return new GameOverView();
//				case StateType.ROOM_LIST:
//					return new RoomListIIController();
//				case StateType.DUNGEON:
//				    return new DungeonListController();
//				case StateType.MISSION_RESULT:
//					return new MissionResult();
//				case StateType.TRAINER:
//				    return new TrainerView();
//				case StateType.LODING_TRAINER:
//				    return new TrainerControl();
//				case StateType.FIGHT_LIB:
//					return new FightLibState();
//				case StateType.FIGHT_LIB_GAMEVIEW:
//					return new FightLibGameView();
//				case StateType.CIVIL:
//				return new CivilControler();
//				case StateType.STORE_ARM:
//					return new StoreStateView();
//				case StateType.CREATE_PLAYER:
//					return new ChooseCharacterController();
//				case StateType.TOFFLIST:
//					return new TofflistController();
//				case StateType.TASK:
//					return new TaskPannelView();
//				case StateType.CONSORTIA:
//					return new ConsortiaControl();
//				case StateType.AUCTION:
//				    return new AuctionHouseController();
//				case StateType.CHURCH_ROOMLIST:
//					return new WeddingRoomControler();
//				case StateType.CHURCH_SCENE:
//					return new SceneControler();
//				case StateType.CIVIL:
//					return new CivilControler();
//				case StateType.HOT_SPRING_ROOM_LIST:
//					return new HotSpringRoomListController();
//				case StateType.HOT_SPRING_ROOM:
//					return new HotSpringRoomController();
				default:
					return null;		
			}
			return null;
		}
		
	//	private var _loader:ModelLoader;
		
		public function createAsync(type:String,callback:Function):void
		{			
			var clsStr:String = getTypeClass(type);
			var state:Object = ClassUtils.CreatInstance(clsStr);			
			callback(state);
		}
		/*{
			var clsStr:String = getTypeClass(type);
			var state:Object = ModelManager.create(clsStr);
			if(state == null)
			{
				var file:String = getTypeFile(type);
				if(file)
				{
					if(_loader)
					{
						__cancel(null);
					}
					
					_loader = ModelManager.addModelFile(getTypeFile(type));
					if(_dic[_loader] == null || _dic[_loader] == undefined)
					{
						_dic[_loader] = {type:type,func:callback};
						_loader.addEventListener(ModelEvent.MODEL_COMPLETE,__complete);
						_loader.addEventListener(ProgressEvent.PROGRESS,__progress);
						if(!_loader.isStarted())
						{
							_loader.loadAtOnce();	
						}
						if(type == StateType.CREATE_PLAYER || type == StateType.LODING_TRAINER)
						{
							WaitingView.instance.show(WaitingView.LOAD,LanguageMgr.GetTranslation("BaseStateCreator.LoadingTip"),false);
						}
						else
						{
							WaitingView.instance.show(WaitingView.LOAD,LanguageMgr.GetTranslation("BaseStateCreator.LoadingTip"));
							WaitingView.instance.addEventListener(WaitingView.WAITING_CANCEL,__cancel);
						}
					}
				}
				else
				{
					trace("Can't find type:",type);
				}
			}
			else
			{
				callback(state);
			}
		}
		
		private function __cancel(evt:Event):void
		{
			WaitingView.instance.removeEventListener(WaitingView.WAITING_CANCEL,__cancel);
			WaitingView.instance.hide();
			_loader.removeEventListener(ModelEvent.MODEL_COMPLETE,__complete);
			_loader.removeEventListener(ProgressEvent.PROGRESS,__progress);
			delete _dic[_loader];
			_loader = null;
		}
		
		private function __complete(event:ModelEvent):void
		{
			WaitingView.instance.hide();
			WaitingView.instance.removeEventListener(WaitingView.WAITING_CANCEL,__cancel);
			_loader.removeEventListener(ModelEvent.MODEL_COMPLETE,__complete);
			_loader.removeEventListener(ProgressEvent.PROGRESS,__progress);
			var obj:Object = _dic[_loader];
			if(obj != null)
			{
				var type:String = obj["type"];
				var func:Function = obj["func"];
				var state:Object =  ModelManager.create(getTypeClass(type));
				func(state);
				delete _dic[_loader];
			}
		}
		
		private function __progress(evt:ProgressEvent):void
		{
			WaitingView.instance.percent = int((evt.bytesLoaded / evt.bytesTotal) * 100);
		}
		*/
		public function getTypeClass(type:String):String
		{
			switch(type)
			{
				case StateType.SERVER_LIST:
					return "ddt.serverlist.ServerListView";
				case StateType.MAIN:
					return "ddt.hall.ChooseHallView";
				case StateType.ROOM_LIST:
					return "ddt.roomlist.RoomListIIController";
				case StateType.ROOM:
					return "ddt.room.RoomIIController";
				case StateType.FIGHTING:
					return "ddt.game.GameView";
				case StateType.SHOP:
					return "ddt.shop.ShopController";
				case StateType.STORE_ARM:
					return "ddt.store.StoreStateView";
				case StateType.FIGHTING_RESULT:
					return "ddt.gameover.GameOverView";
				case StateType.CREATE_PLAYER:
					return "choosecharacter.ChooseCharacterController"; 
				case StateType.TOFFLIST:
					return "ddt.tofflist.TofflistController";
				case StateType.AUCTION:
					return "ddt.auctionHouse.controller.AuctionHouseController";
				case StateType.CONSORTIA:
					return "ddt.consortia.ConsortiaControl";
				case StateType.CONSORTIASTORE:
					return "ddt.store.StoreStateView";
				case StateType.CHURCH_ROOMLIST:
					return "ddt.church.weddingRoom.WeddingRoomControler";
				case StateType.CHURCH_SCENE:	
					return "ddt.church.churchScene.SceneControler";
				case StateType.CIVIL:	
					return "ddt.civil.CivilControler";
				case StateType.GAME_LOADING:	
					return "ddt.gameLoad.GameLoadingControler";
				case StateType.DUNGEON:
					return "ddt.roomlist.DungeonListController";
				case StateType.MISSION_RESULT:
					return "ddt.missionresult.MissionResult";
				case StateType.LODING_TRAINER:
					return "ddt.gametrainer.TrainerControl";
				case StateType.TRAINER:
					return "ddt.gametrainer.TrainerView";
				case StateType.FIGHT_LIB:
					return "ddt.fightLib.FightLibState";
				case StateType.FIGHT_LIB_GAMEVIEW:
					return "ddt.fightLib.FightLibGameView";
				case StateType.HOT_SPRING_ROOM_LIST:
					return "ddt.hotSpring.controller.HotSpringRoomListController";
				case StateType.HOT_SPRING_ROOM:
					return "ddt.hotSpring.controller.HotSpringRoomController";
			}
			return null;
		}
		
		public function getTypeFile(type:String):String
		{
			switch(type)
			{
				case StateType.ROOM_LIST:
				case StateType.ROOM:
				case StateType.FIGHTING:
				case StateType.FIGHTING_RESULT:
				case StateType.DUNGEON:
				case StateType.LODING_TRAINER:
				case StateType.TRAINER:
				case StateType.FIGHT_LIB:
				case StateType.FIGHT_LIB_GAMEVIEW:
				case StateType.SHOP:

				case StateType.STORE_ARM:

				case StateType.CREATE_PLAYER:

				case StateType.TOFFLIST:
		
				case StateType.AUCTION:
	
				case StateType.CONSORTIA:

				case StateType.CIVIL:

				case StateType.CHURCH_SCENE:
				case StateType.CHURCH_ROOMLIST:

				case StateType.HOT_SPRING_ROOM:
				case StateType.HOT_SPRING_ROOM_LIST:
					
			}
			return null;
		}
	}
}