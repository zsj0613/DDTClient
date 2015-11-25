package ddt.church.churchScene.invite
{
	import flash.display.Sprite;
	
	import road.comm.PackageIn;
	
	import ddt.data.player.PlayerInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;

	public class ChurchInviteController
	{
		private var _view:ChurchInviteView;
		private var _model:ChurchInviteModel;
		
		public function ChurchInviteController()
		{
			init();
		}
		
		private function init():void
		{
			_model = new ChurchInviteModel();
			_view = new ChurchInviteView(this,_model);
		}
		
		public function getView():Sprite
		{
			return _view;
		}

		public function refleshList(type:int,count:int = 0):void
		{
			if(type == 0)
			{
				setList(0,PlayerManager.Instance.onlineFriendList);
			}
			else if(type == 1)
			{
				setList(1,PlayerManager.Instance.onlineConsortiaMemberList);
			}
		}
		
		private function isOnline(item:*):Boolean
		{
			return item.State == 1;
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
			_model.dispose();
			_model = null;
			if(_view && _view.parent)_view.parent.removeChild(_view);
			if(_view)_view.dispose();
			_view = null;
		}
	}
}