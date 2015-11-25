package ddt.hotSpring.controller
{
	import road.comm.PackageIn;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.hotSpring.model.HotSpringRoomListModel;
	import ddt.hotSpring.view.HotSpringRoomView;
	import ddt.hotSpring.view.HotSpringMainView;
	import ddt.manager.SocketManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	
	public class HotSpringRoomListController extends BaseStateView
	{
		private var _view:HotSpringMainView;
		private var _model:HotSpringRoomListModel;
		public function HotSpringRoomListController()
		{
		}
		
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			_model = HotSpringRoomListModel.Instance;
			if(_view){_view.hide();_view.dispose();}_view=null;
			_view = new HotSpringMainView(this,_model);
			setEvent();
			_view.show();
		}
		
		private function setEvent():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,roomAddOrUpdate);//增加或更新房间
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE,roomCreateSucceed);//玩家创建房间成功
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET,roomListGet);//房间列表
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE,roomRemove);//移除房间
		}
		
		private function removeEvent():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,roomAddOrUpdate);//房间新增或更新
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE,roomCreateSucceed);//玩家创建房间成功
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET,roomListGet);//房间列表
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE,roomRemove);//房间移除
		}
		
		/**
		 * 增加或更新房间
		 */		
		private function roomAddOrUpdate(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var roomVO:HotSpringRoomInfo=new HotSpringRoomInfo();
			roomVO.roomNumber = pkg.readInt();
			roomVO.roomID=pkg.readInt();
			roomVO.roomName=pkg.readUTF();
			roomVO.roomPassword=pkg.readUTF();
			roomVO.effectiveTime=pkg.readInt();//房间的有效剩余时间
			roomVO.curCount=pkg.readInt();
			roomVO.playerID=pkg.readInt();
			roomVO.playerName=pkg.readUTF();
			roomVO.startTime=pkg.readDate();
			roomVO.roomIntroduction=pkg.readUTF();
			roomVO.roomType=pkg.readInt();
			roomVO.maxCount=pkg.readInt();
			roomVO.roomIsPassword=(roomVO.roomPassword!="" && roomVO.roomPassword.length>0);
			
			_model.roomAddOrUpdate(roomVO);
		}
		
		/**
		 * 进入温泉模块
		 */		
		public function hotSpringEnter():void
		{
			SocketManager.Instance.out.sendHotSpringEnter();
		}
		
		/**
		 * 	玩家创建房间成功
		 */
		private function roomCreateSucceed(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var result:Boolean = pkg.readBoolean();
			if(!result) return;	
			
			var roomVO:HotSpringRoomInfo=new HotSpringRoomInfo();
			roomVO.roomID=pkg.readInt();
			roomVO.roomName=pkg.readUTF();
			roomVO.roomPassword=pkg.readUTF();
			roomVO.effectiveTime=pkg.readInt();
			roomVO.curCount=pkg.readInt();
			roomVO.playerID=pkg.readInt();
			roomVO.playerName=pkg.readUTF();
			roomVO.startTime=pkg.readDate();
			roomVO.roomIntroduction=pkg.readUTF();
			roomVO.roomType=pkg.readInt();
			roomVO.maxCount=pkg.readInt();
			
			if(roomVO.roomPassword && roomVO.roomPassword!="" && roomVO.roomPassword.length>0){roomVO.roomIsPassword=true;}else{roomVO.roomIsPassword=false;}
			_model.roomSelf=roomVO;
		}
		
		/**
		 * 取得房间列表
		 */
		private function roomListGet(event:CrazyTankSocketEvent):void
		{
			var roomVO:HotSpringRoomInfo;
			var pkg:PackageIn = event.pkg;
			var roomCount:int=pkg.readInt();//房间总计
			for(var i:int=0;i<roomCount;i++)
			{
				roomVO=new HotSpringRoomInfo();
				roomVO.roomNumber=pkg.readInt();
				roomVO.roomID=pkg.readInt();
				roomVO.roomName=pkg.readUTF();
				roomVO.roomPassword=pkg.readUTF();
				roomVO.effectiveTime=pkg.readInt();
				roomVO.curCount=pkg.readInt();
				roomVO.playerID=pkg.readInt();
				roomVO.playerName=pkg.readUTF();
				roomVO.startTime=pkg.readDate();
				roomVO.roomIntroduction=pkg.readUTF();
				roomVO.roomType=pkg.readInt();
				roomVO.maxCount=pkg.readInt();
				
				_model.roomAddOrUpdate(roomVO);
			}
		}
		
		/**
		 * 移除(关闭)房间
		 */		
		private function roomRemove(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var roomID:int=pkg.readInt();
			_model.roomRemove(roomID);
		}
		
		/**
		 * 进入房间的确认
		 */		
		public function roomEnterConfirm(roomID:int):void
		{
			SocketManager.Instance.out.sendHotSpringRoomEnterConfirm(roomID);
		}
		
		/**
		 * 进入指定的房间
		 */		
		public function roomEnter(roomID:int, inputPassword:String):void
		{
			SocketManager.Instance.out.sendHotSpringRoomEnter(roomID, inputPassword);
		}
		
		/**
		 * 快速进入房间
		 */		
		public function quickEnterRoom():void
		{
			SocketManager.Instance.out.sendHotSpringRoomQuickEnter();
		}	
		
		/**
		 * 创建房间
		 */		
		public function roomCreate(roomVO:HotSpringRoomInfo):void
		{
			SocketManager.Instance.out.sendHotSpringRoomCreate(roomVO);
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			dispose();
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function getType():String
		{
			return StateType.HOT_SPRING_ROOM_LIST;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_view)
			{
				_view.hide();
				_view.dispose();
			}
			_view = null;
			
			if(_model) _model.dispose();
			_model=null;
		}
	}
}