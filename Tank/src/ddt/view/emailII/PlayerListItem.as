package ddt.view.emailII
{
	import flash.events.MouseEvent;
	
	import ddt.data.player.PlayerInfo;
	import road.manager.SoundManager;
	
	import webGame.crazyTank.view.shopII.ShopIIPlayerListItemAsset;

	public class PlayerListItem extends ShopIIPlayerListItemAsset
	{
		private var _info:PlayerInfo;
		
		private var _fun:Function;
		
		public static const SELECT:String = "select";
		
		public function get info():PlayerInfo
		{
			return _info;
		}
		
		public function PlayerListItem(info:PlayerInfo,fun:Function)
		{
			_fun = fun;
			_info = info;
			init();
			initEvent();
		}
		
		public function dispose():void
		{
			_info = null;
			_fun = null;
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			removeEventListener(MouseEvent.CLICK,__mouseClick);
			
		}
		
		private function init():void
		{
			name_txt.text = String(_info.NickName);
			bg.visible = false;
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
			addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			if(_fun != null)
			{
				SoundManager.instance.play("008");
				_fun(_info.NickName,_info.ID);
			}
		}
		private function __mouseOver(evt:MouseEvent):void
		{
			bg.visible = true;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			bg.visible = false;
		}
	}
}