package ddt.roomlist
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import par.manager.ParticleManager;
	import par.manager.ShapeManager;
	
	import road.loader.*;
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.StringHelper;
	
	import ddt.data.DungeonInfo;
	import ddt.data.SimpleRoomInfo;
	import ddt.manager.MapManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StatisticManager;
	import ddt.manager.TaskManager;
	import ddt.menu.RightMenu;
	import ddt.menu.RightMenuPanel;
	import ddt.socket.GameInSocketOut;
	import ddt.socket.GameSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	
	/**
	 * 远征码头
	 * 2009 12 / leili
	 * **/
	public class DungeonListController extends RoomListIIController
	{
		private var _viewPVE       : RoomListIIPveView;//
		private var _createviewPVE : RoomListIICreatePveRoomView;//
		private var _defaluDungeonMapId_3 : int;
		private var _defaluDungeonMapId_4 : int;
		public function DungeonListController()
		{
			upMapId();
			super();
		}
		override protected function init():void
		{
			_model = new RoomListIIModel();
			_container = new Sprite();
			_container.graphics.beginFill(0x000000,0);
			_container.graphics.drawRect(0,0,1000,600);
			_container.graphics.endFill();
			_viewPVE = new RoomListIIPveView(this,_model);
			_container.addChild(_viewPVE);
			RightMenu.Instance.chanllengeEnable = true;
			RightMenu.Instance.addEventListener(RightMenuPanel.CHALLENGE, __onChanllengeClick);
		}
		
		override protected function updataRoom(tempArray : Array) : void
		{
			if(tempArray.length == 0)
			{
				_model.updateRoom(tempArray);
				return;
			}
			if((tempArray[0] as SimpleRoomInfo).roomType > 2 && (tempArray[0] as SimpleRoomInfo).roomType != 10)
			{
				if((tempArray[0] as SimpleRoomInfo) .mapId == 0)
				{
					(tempArray[0] as SimpleRoomInfo).mapId = ((tempArray[0] as SimpleRoomInfo).roomType == 3 ? _defaluDungeonMapId_3 : _defaluDungeonMapId_4);
				}
				_model.updateRoom(tempArray);
			}
		}
		
		private function upMapId() : void
		{
			var dungeon : DungeonInfo = MapManager.getListByType(3)[0] as DungeonInfo;
			if(dungeon)_defaluDungeonMapId_3 =  dungeon.ID;
			var dungeon_4 : DungeonInfo = MapManager.getListByType(4)[0] as DungeonInfo;
			if(dungeon_4)_defaluDungeonMapId_4 =  dungeon_4.ID;
		}
		override public function getType():String
		{
			return StateType.DUNGEON;
		}
		override public function sendGoIntoRoom(info:SimpleRoomInfo):void
		{
			_viewPVE.sendGointoRoom(info);
		}
		override protected function __containerClick(evt:MouseEvent):void
		{
			_viewPVE.setMenuDisvisiable();
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			SoundManager.Instance.playMusic("062");
//			super.enter(prev,data);
			StatisticManager.loginRoomListNum ++;
			SocketManager.Instance.out.sendCurrentState(1);
			
			init();
			initEvent();
			SocketManager.Instance.out.sendSceneLogin(lookupEnumerate.DUNGEON_LIST);
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			BellowStripViewII.Instance.tutorialBtnsStatus(true);
			BellowStripViewII.Instance.tutorialStatus(false);
			RoomManager.Instance.current = null;
			BellowStripViewII.Instance.newQuest(false);
			if(StatisticManager.Instance().IsNovice)TaskManager.requestCanAcceptTask();
			if(!ShapeManager.ready)
			{
				var ml:ModuleLoader =  LoaderManager.Instance.createLoader("shape.swf",BaseLoader.MODULE_LOADER);
				LoaderManager.Instance.startLoad(ml);
				if(ml.isSuccess)
				{
					ShapeManager.setup();
				}
				else
				{
					ml.addEventListener(LoaderEvent.COMPLETE,__modelCompleted);
				}
			}
			if(!ParticleManager.ready)
				ParticleManager.loadSyc("partical.xml"+"?"+StringHelper.getRandomNumber());
			
			if(PlayerManager.Instance.hasTempStyle)
			{
				PlayerManager.Instance.readAllTempStyleEvent();
			}
		}
		
		private function __modelCompleted(event:Event):void
		{
			(event.currentTarget as ModuleLoader).removeEventListener(LoaderEvent.COMPLETE,__modelCompleted);
			ShapeManager.setup();
		}
		
		override public function showCreateView():void
		{
			if(_createviewPVE !=null)
			{
				_createviewPVE.dispose();
				_createviewPVE=null;
			}
			_createviewPVE = new RoomListIICreatePveRoomView(this);
			UIManager.setChildCenter(_createviewPVE);
			TipManager.AddTippanel(_createviewPVE);
		}
		
		override public function dispose():void
		{
			RightMenu.Instance.removeEventListener(RightMenuPanel.CHALLENGE, __onChanllengeClick);
			if(_viewPVE)_viewPVE.dispose();
			if(_createviewPVE)_createviewPVE.dispose();
			_createviewPVE=null;
			_viewPVE = null;
			super.dispose();
		}
	}
}