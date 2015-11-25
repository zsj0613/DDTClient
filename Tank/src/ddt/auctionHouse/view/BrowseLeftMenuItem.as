package ddt.auctionHouse.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	
	import ddt.auctionHouse.view.vmenu.IMenuItem;
	import ddt.data.goods.CateCoryInfo;

	public class BrowseLeftMenuItem extends Sprite implements IMenuItem
	{
		private var  accect:MovieClip;
		private var _info:CateCoryInfo;
		private var _isOpen:Boolean = false;
		private var _hasIcon:Boolean;
		private var _hideIcon:Boolean;
		
		public function BrowseLeftMenuItem($accect:MovieClip,$info:CateCoryInfo,$hideIcon:Boolean = false)
		{
			accect = $accect;
			accect.stop();
			_info = $info;
			_hideIcon = $hideIcon;
			addChild(accect);
			initView();
			initEvent();
		}
		
		private function initEvent():void
		{
			accect["hot"].addEventListener(MouseEvent.CLICK,btnClickHandler);
			addRollEvent();
			
			if(accect["icon"]){
				_hasIcon = true;
				if(_hideIcon)
				{
					accect["icon"].visible = false;
				}
				
				accect["icon"].gotoAndStop(1);
			}
		}
		
		public function dispose():void
		{
			removeRollEvent();
			if(accect["hot"])accect["hot"].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			if(parent){
				parent.removeChild(this);
			}
			_info = null;
		}
		private function removeRollEvent():void
		{
			accect["hot"].removeEventListener(MouseEvent.MOUSE_OVER,btnClickHandler);
			accect["hot"].removeEventListener(MouseEvent.MOUSE_OUT,btnClickHandler);
		}
		private function addRollEvent():void
		{
			accect["hot"].addEventListener(MouseEvent.MOUSE_OVER,btnClickHandler);
			accect["hot"].addEventListener(MouseEvent.MOUSE_OUT,btnClickHandler);
		}
		
		
		
		private function initView():void
		{
			accect["type_txt"].text = _info.Name;
		}

		public function get info():Object
		{
			return _info;
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(b:Boolean):void
		{
			_isOpen = b;
			if(_isOpen && _hasIcon)
			{
				accect["icon"].gotoAndStop(2);
			}
			else if(!_isOpen && _hasIcon)
			{
				accect["icon"].gotoAndStop(1);
			}
			else
			{
				
			}
		}
		
		public function set enable (b:Boolean):void
		{
			
			if(b){
				accect.gotoAndStop(1);
				addRollEvent();
			}else{
				accect.gotoAndStop(2);
				removeRollEvent();
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.CLICK:
				SoundManager.instance.play("008");
				accect.gotoAndStop(2);
				if(_isOpen){
					addRollEvent();
				}else{
					removeRollEvent();
				}
				break;
				case MouseEvent.MOUSE_OVER:
				accect.gotoAndStop(2);
				break;
				case MouseEvent.MOUSE_OUT:
				accect.gotoAndStop(1);
				break;
			}
		}
		
	}
}