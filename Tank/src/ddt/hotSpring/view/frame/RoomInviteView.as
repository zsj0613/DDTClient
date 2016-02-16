package ddt.hotSpring.view.frame
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import tank.hotSpring.HotSpringInviteAsset;
	import ddt.hotSpring.controller.HotSpringRoomController;
	import ddt.hotSpring.model.HotSpringRoomModel;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;
	
	public class RoomInviteView extends HConfirmFrame
	{
		private var _controller:HotSpringRoomController;
		private var _bg:HotSpringInviteAsset;
		private var _model:HotSpringRoomModel;
		private var _currentTab:int;
		private var _refleshCount:int;
		private var _list:SimpleGrid;
		private var _dataList:Array=PlayerManager.Instance.onlineFriendList;//当前数据列表
		private var _callBack:Function;
		
		public function RoomInviteView(controller:HotSpringRoomController, model:HotSpringRoomModel, callBack:Function)
		{
			_controller=controller;
			_model=model;
			_callBack=callBack;
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		private function initialize():void
		{
			okLabel = LanguageMgr.GetTranslation("ddt.invite.InviteView.list");
			cancelLabel = LanguageMgr.GetTranslation("ddt.invite.InviteView.close");
			okFunction = __refleshClick;
			cancelFunction = __closeClickHandler;
			showCancel = true;
			blackGound = false;
			alphaGound = false;
			showBottom = true;
			setContentSize(243,315);
			titleText = LanguageMgr.GetTranslation("ddt.invite.InviteView.request");
			
			_bg = new HotSpringInviteAsset();
			_bg.bg.gotoAndStop(1);
			_bg.x = -4;
			_bg.y = -1;
			addContent(_bg);
			
			_bg.reflesh_pos.visible = false;
			_bg.close_btn.visible = false;
			
			_currentTab = 0;
			_refleshCount = 0;
			
			_list = new SimpleGrid(227,24);
			ComponentHelper.replaceChild(_bg,_bg.list_pos,_list);
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			_bg.friend_btn.buttonMode = true;
			_bg.consortia_btn.buttonMode = true;
			
			updateList();
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_bg.friend_btn.addEventListener(MouseEvent.CLICK, getFriendList);
			_bg.consortia_btn.addEventListener(MouseEvent.CLICK, getConsortiaList);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			_refleshCount = 0;
		}
		
		private function __refleshClick(evt:MouseEvent = null):void
		{
			SoundManager.Instance.play("008");
			updateList();
		}
		
		private function __closeClickHandler(evt:Event = null):void
		{
			SoundManager.Instance.play("008");
			hideAndClose();
			if(_callBack!=null) _callBack();
		}
		
		public function hideAndClose():void
		{
			if(parent)parent.removeChild(this);
		}
		
		private function getFriendList(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_currentTab == 0)return;
			_currentTab = 0;
			_bg.bg.gotoAndStop(1);
			_dataList=PlayerManager.Instance.onlineFriendList;
			updateList();
		}
		
		private function getConsortiaList(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_currentTab == 1)return;
			_currentTab = 1;
			_bg.bg.gotoAndStop(2);
			_dataList=PlayerManager.Instance.onlineConsortiaMemberList;
			updateList();
		}
		
		private function updateList():void
		{
			_list.clearItems();
			for(var i:int = 0; i < _dataList.length; i++)
			{
				var roomInviteListItemView:RoomInviteListItemView = new RoomInviteListItemView(_dataList[i]);
				_list.appendItem(roomInviteListItemView);
			}
			_bg.bg.gotoAndStop(_currentTab + 1);
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			if(this.cancelFunction != null) this.cancelFunction();
			super.__closeClick(e);
		}
		
		override public function dispose():void
		{
			super.dispose();

			_bg.friend_btn.removeEventListener(MouseEvent.CLICK, getFriendList);
			_bg.consortia_btn.removeEventListener(MouseEvent.CLICK, getConsortiaList);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			
			
			for each(var roomInviteListItemView:RoomInviteListItemView in _list)
			{
				roomInviteListItemView.dispose();
			}
			
			while(_dataList.length>0)
			{
				_dataList.shift();
			}
			_dataList=null;
			
			_controller = null;
			_model = null;
			DisposeUtils.disposeDisplayObject(_bg);
			if(_list && _list.parent)_list.parent.removeChild(_list);
			if(_list)_list.clearItems();
			_list = null;
			if(parent)parent.removeChild(this);
		}
	}
}