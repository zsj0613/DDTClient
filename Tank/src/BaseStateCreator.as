﻿﻿package
{
	import flash.utils.Dictionary;
	import road.utils.ClassUtils;	
	import ddt.hall.ChooseHallView;
	import ddt.loginstate.LoginView;
	import ddt.serverlist.ServerListView;
	import ddt.states.BaseStateView;
	import ddt.states.IStateCreator;
	import ddt.states.StateType;
	
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
				default:
					return null;		
			}
			return null;
		}
		
		
		public function createAsync(type:String,callback:Function):void
		{			
			var clsStr:String = getTypeClass(type);
			var state:Object = ClassUtils.CreatInstance(clsStr);			
			callback(state);
		}
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
	}
}