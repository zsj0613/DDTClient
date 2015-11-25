package ddt.room
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	
	import ddt.data.RoomInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.UserGuideManager;

	public class RoomMapSetPanelBase extends Sprite
	{
		protected var _confirmBtn : HBaseButton;
		protected var _hadChange  : Boolean;
		protected var _bg         : HFrame;
		protected var _room       : RoomInfo;
		protected var _controller : RoomIIController;
		public function RoomMapSetPanelBase(controller:RoomIIController,room:RoomInfo)
		{
			_controller = controller;
			_room = room;
			super();
			init();
			addEvent();
		}
		protected function init() : void
		{
			_bg = new HFrame();
			_bg.showClose = true;
			_bg.closeCallBack = hide;
			_bg.titleText = LanguageMgr.GetTranslation("ddt.room.RoomIIMapSetPanel.room");
			_bg.centerTitle = true;
			_bg.moveEnable  = false;
			_bg.showBottom  = true;
			_bg.blackGound  = false;
			_bg.alphaGound  = false;
			_bg.fireEvent   = false;
			_bg.x = 32;
			addChildAt(_bg,0);
			_hadChange = false;
			_confirmBtn = new HLabelButton();
			_confirmBtn.label = LanguageMgr.GetTranslation("ok");
			addChild(_confirmBtn);
		}
		protected function addEvent() : void
		{
			_confirmBtn.addEventListener(MouseEvent.CLICK,__confirmClick);
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		protected function removeEvent() : void
		{
			if(_confirmBtn)_confirmBtn.removeEventListener(MouseEvent.CLICK,__confirmClick);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		protected function __confirmClick(evt : MouseEvent) : void
		{
			
		}
		protected function __onKeyDownd(evt : KeyboardEvent) : void
		{
			
		}
		protected function hide():void
		{
			_hadChange = false;
			if(parent)
				parent.removeChild(this);
		}
		public function dispose() : void
		{
			removeEvent();
			
			if(_confirmBtn)
				_confirmBtn.dispose();
			_confirmBtn = null;
			
			if(_bg)
				_bg.dispose();
			_bg = null;
			
			_room = null;
			_controller = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}