package ddt.hotSpring.controller
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.Socket;
	
	import road.comm.PackageIn;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	
	import ddt.data.HotSpringRoomInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import ddt.hotSpring.model.HotSpringRoomModel;
	import ddt.hotSpring.player.HotSpringPlayer;
	import ddt.hotSpring.view.HotSpringRoomView;
	import ddt.hotSpring.vo.PlayerVO;
	import ddt.manager.ChatManager;
	import ddt.manager.HotSpringManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	
	public class HotSpringRoomController extends BaseStateView
	{
		private var _model:HotSpringRoomModel;
		private var _view:HotSpringRoomView;
		private var _isActive:Boolean = true;
		private var _messageTip:String;
		
		public function HotSpringRoomController()
		{
		}
		
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			TipManager.clearTipLayer();
			UIManager.clear();
			
			_model = HotSpringRoomModel.Instance;
			if(_view){_view.hide();_view.dispose();}_view=null;
			_view = new HotSpringRoomView(this,_model);
			_view.show();
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 1000, 600);
			graphics.endFill();
			
			setEvent();
		}
		
		private function setEvent():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,roomAddOrUpdate);//增加或更新房间
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,roomPlayerAdd);	//房间内增加一个玩家
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,roomPlayerRemove);	//房间内玩家成功退出
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,roomPlayerRemoveNotice);//房间内玩家成功退出/移除后通知房间内其它玩家
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,roomPlayerTargetPoint);//玩家要移动到的目标点
		}
		
		private function removeEvent():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,roomAddOrUpdate);//增加或更新房间
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,roomPlayerAdd);	//房间内增加一个玩家
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,roomPlayerRemove);	//房间内玩家成功退出
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,roomPlayerRemoveNotice);//房间内玩家成功退出/移除后通知房间内其它玩家
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,roomPlayerTargetPoint);//玩家要移动到的目标点
			removeEventListener(Event.ACTIVATE,__activeChange);
			removeEventListener(Event.DEACTIVATE,__activeChange);
			removeEventListener(MouseEvent.CLICK,__activeChange);
		}
		
		private function __activeChange(event:Event):void
		{
			if(event.type == Event.DEACTIVATE)
			{
				_isActive = false;
			}else
			{
				_isActive = true;
			}
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
			
			if(roomVO.roomID==HotSpringManager.Instance.roomCurrently.roomID)
			{
				HotSpringManager.Instance.roomCurrently=roomVO;
			}
		}
		
		/**
		 * 增加房间内玩家
		 */		
		private function roomPlayerAdd(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var playerID:int=pkg.readInt();
			var playerVO:PlayerVO;
			if(playerID==PlayerManager.Instance.Self.ID)
			{//如果为当前玩家，则记录当前玩家信息至model
				playerVO=_model.selfVO;
			}
			else
			{
				playerVO=new PlayerVO();
			}
			
			var playerInfo:PlayerInfo=PlayerManager.Instance.findPlayer(playerID);
			playerInfo.beginChanges();
			playerInfo.Grade = pkg.readInt();
			playerInfo.Hide = pkg.readInt();
			playerInfo.Repute = pkg.readInt();
			playerInfo.NickName = pkg.readUTF();
			playerInfo.Sex = pkg.readBoolean();
			playerInfo.Style = pkg.readUTF();
			playerInfo.Colors = pkg.readUTF();
			playerInfo.Skin = pkg.readUTF();
			var playerPos:Point = new Point(pkg.readInt(),pkg.readInt());
			playerInfo.FightPower = pkg.readInt();
			playerInfo.WinCount   = pkg.readInt();
			playerInfo.TotalCount = pkg.readInt();
			playerVO.playerDirection=pkg.readInt();//玩家方向
			playerInfo.commitChanges();
			playerVO.playerInfo=playerInfo;
			playerVO.playerPos=playerPos;
			if(playerID==PlayerManager.Instance.Self.ID)
			{
				_model.selfVO=playerVO;//更新当前玩家信息至model
			}
			
			_model.roomPlayerAddOrUpdate(playerVO);
		}
		
		/**
		 * 玩家退出房间协议发送
		 */		
		public function roomPlayerRemoveSend(messageTip:String=null):void
		{
			_messageTip=messageTip;
			SocketManager.Instance.out.sendHotSpringRoomPlayerRemove();
		}
		
		/**
		 * 玩家成功退出/移除房间后的通知
		 */
		private function roomPlayerRemoveNotice(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var playerID:int=pkg.readInt();
			_model.roomPlayerRemove(playerID);
		}
		
		/**
		 * 玩家成功退出/移除房间
		 */
		public function roomPlayerRemove(event:CrazyTankSocketEvent=null):void
		{
			var pkg:PackageIn = event.pkg;
			var msg:String=pkg.readUTF();
			
			HotSpringManager.Instance.roomCurrently=null;
			dispose();
			StateManager.setState(StateType.HOT_SPRING_ROOM_LIST);
			
			if(PlayerManager.Instance.Self.Grade<40)
			{//只有在小于40级时
				if(msg && msg!="" && msg.length>0)
				{
					ChatManager.Instance.sysChatYellow(msg);
					MessageTipManager.getInstance().show(msg);
				}
			}
			
			if(_messageTip && _messageTip!="" && _messageTip.length>0)
			{
				ChatManager.Instance.sysChatYellow(_messageTip);
				MessageTipManager.getInstance().show(_messageTip);
			}
		}
		
		/**
		 * 玩家行动目标点发送
		 */
		public function roomPlayerTargetPointSend(playerVO:PlayerVO):void
		{
			SocketManager.Instance.out.sendHotSpringRoomPlayerTargetPoint(playerVO);
		}
		
		/**
		 * 玩家要移动到的目标点接收
		 */
		private function roomPlayerTargetPoint(event:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = event.pkg;
			var pathStr:String=pkg.readUTF();//玩家的路径
			var playerID:int=pkg.readInt();//玩家ID
			var lastStartX:int = pkg.readInt();//目的点X
			var lastStartY:int = pkg.readInt();//目的点Y
			var arr:Array = pathStr.split(",");
			var path:Array = [];
			for(var i:uint = 0;i<arr.length;i+=2)
			{
				var p:Point = new Point(arr[i],arr[i+1]);
				path.push(p);
			}
			var playerVO:PlayerVO=_model.roomPlayerList[playerID] as PlayerVO;
			if(!playerVO) return;
			if(_isActive)
			{
				playerVO.currentWalkStartPoint = new Point(lastStartX,lastStartY);
				playerVO.walkPath = path;
				_model.roomPlayerAddOrUpdate(playerVO);
			}else
			{
				playerVO.playerPos = path.pop();
			}
		}
		
		/**
		 * 房间续费
		 */		
		public function roomRenewalFee(roomVO:HotSpringRoomInfo):void
		{
			SocketManager.Instance.out.sendHotSpringRoomRenewalFee(roomVO.roomID);
		}
		
		/**
		 * 编辑房间
		 */		
		public function roomEdit(roomVO:HotSpringRoomInfo):void
		{
			SocketManager.Instance.out.sendHotSpringRoomEdit(roomVO);
		}
		
		/**
		 * 系统房间刷新时，针对于玩家的继续(扣费)是否继续操作发送
		 */		
		public function roomPlayerContinue(isContinue:Boolean):void
		{
			SocketManager.Instance.out.sendHotSpringRoomPlayerContinue(isContinue);
		}
		
		override public function leaving(next:BaseStateView):void
		{
			dispose();
			super.leaving(next);
		}
		
		override public function getBackType():String
		{
			return StateType.HOT_SPRING_ROOM_LIST;
		}
		
		override public function getType():String
		{
			return StateType.HOT_SPRING_ROOM;
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