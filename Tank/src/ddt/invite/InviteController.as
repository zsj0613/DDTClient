package ddt.invite
{
	import flash.display.Sprite;
	
	import road.comm.PackageIn;
	
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;

	public class InviteController implements IInviteController
	{
		private var _view:InviteView;
		private var _model:IInviteModel;
		
		public function InviteController()
		{
			init();
			initEvent();
		}
		
		private function init():void
		{
			_model = new InviteModel();
			_view = new InviteView(this,_model);
		}
		
		private function initEvent():void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,__getList);
		}
		
		public function getView():Sprite
		{
			return _view;
		}

		public function refleshList(type:int,count:int = 0):void
		{
			if(type == 0)
			{
				GameInSocketOut.sendGetScenePlayer(count);
			}
			else if(type == 1)
			{
				setList(1,PlayerManager.Instance.onlineFriendList);
			}
			else if(type == 2)
			{
				setList(2,PlayerManager.Instance.onlineConsortiaMemberList);
			}
		}
		
		private function isOnline(item:*):Boolean
		{
			return item.State == 1;
		}
		
		private function __getList(evt:CrazyTankSocketEvent):void
		{
			var pkg:PackageIn = evt.pkg;
			var list:Array = [];
			var _length:int = pkg.readByte();
			for(var i:uint = 0;i<_length;i++)
			{
				var info:PlayerInfo = new PlayerInfo();
				info.ID = pkg.readInt();
				info.NickName = pkg.readUTF();
				info.Sex = pkg.readBoolean();
				info.Grade = pkg.readInt();
				info.ConsortiaID = pkg.readInt();
				info.ConsortiaName = pkg.readUTF();
				info.Offer = pkg.readInt();
				info.WinCount = pkg.readInt();
				info.TotalCount = pkg.readInt();
				info.EscapeCount = pkg.readInt();
				info.Repute		 = pkg.readInt();
				info.FightPower  = pkg.readInt(); 
				list.push(info);
			}
			setList(0,list);
		}

		
		private function setList(type:int,data:Array):void
		{
			_model.setList(type,data);
		}
		public function hide():void
		{
			_view.hide();
		}
		
		public function dispose():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,__getList);
			_model.dispose();
			_model = null;
			_view.dispose();
			_view = null;
		}
	}
}