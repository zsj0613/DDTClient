package ddt.shop.view
{
	import flash.events.MouseEvent;
	
	import ddt.data.player.PlayerInfo;
	import road.manager.SoundManager;
	
	import webGame.crazyTank.view.shopII.ShopIIPlayerListItemAsset;

	public class ShopPlayerListItem extends ShopIIPlayerListItemAsset
	{
		private var _info:PlayerInfo;
		private var _doClick:Function;
		
		public function ShopPlayerListItem(info:PlayerInfo,doClick:Function = null)
		{
			_doClick = doClick;
			_info = info;
			super();
			init();
			initEvent();
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
			if(_doClick != null)
			{
				SoundManager.Instance.play("008");
				_doClick(_info.NickName);
			}
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			this.bg.visible = true;
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			bg.visible = false;
		}
	}
}