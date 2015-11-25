package ddt.invite
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.invite.InviteBgAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.ConsortiaPlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;

	public class InviteView extends HConfirmFrame
	{
		private var _bg:InviteBgAsset;
		private var _controller:IInviteController;
		private var _currentTab:int;
		private var _refleshCount:int;
		private var _model:IInviteModel;
		private var _list:SimpleGrid;
		
		public function InviteView(controller:IInviteController,model:IInviteModel)
		{
			_controller = controller;
			_model = model;
			super();
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
			
			configUI();
		}
	
		private function configUI():void
		{
			_bg = new InviteBgAsset();
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
		
			_bg.hall_btn.buttonMode = true;
			_bg.friend_btn.buttonMode = true;
			_bg.consortia_btn.buttonMode = true;
			
			initEvent();
		}
	
		private function initEvent():void
		{
			_bg.hall_btn.addEventListener(MouseEvent.CLICK,__hallClick);
			_bg.friend_btn.addEventListener(MouseEvent.CLICK,__friendClick);
			_bg.consortia_btn.addEventListener(MouseEvent.CLICK,__consortiaClick);
			_model.addEventListener(InviteModel.LIST_UPDATE,__listUpdate);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function removeEvent():void
		{
			_bg.hall_btn.removeEventListener(MouseEvent.CLICK,__hallClick);
			_bg.friend_btn.removeEventListener(MouseEvent.CLICK,__friendClick);
			_bg.consortia_btn.removeEventListener(MouseEvent.CLICK,__consortiaClick);
			_model.removeEventListener(InviteModel.LIST_UPDATE,__listUpdate);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			_refleshCount = 0;
		}
		
		private function __refleshClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			if(_currentTab == 0)
				_controller.refleshList(_currentTab,++_refleshCount);
			else
				_controller.refleshList(_currentTab);	
		}
		
		private function __closeClickHandler(evt:Event = null):void
		{
			SoundManager.instance.play("008");
			hideAndClose();
		}
	
		public function hideAndClose():void
		{
			if(parent)parent.removeChild(this);
		}
		
		private function __hallClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_currentTab == 0)return;
			_currentTab = 0
			_bg.bg.gotoAndStop(1);
			_controller.refleshList(_currentTab,++_refleshCount);
		}
		
		private function __friendClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_currentTab == 1)return;
			_currentTab = 1;
			_bg.bg.gotoAndStop(2);
			_controller.refleshList(_currentTab);
		}
		
		private function __listUpdate(evt:Event):void
		{
			clearList();
			var l:Array = _model.currentList;
			for(var i:int = 0; i < l.length; i++)
			{
				if(l[i] is ConsortiaPlayerInfo)if(l[i].UserId == PlayerManager.Instance.Self.ID)continue;
				var item:InvitePlayerItem = new InvitePlayerItem(l[i]);
				_list.appendItem(item);
			}
			_currentTab = _model.type;
			_bg.bg.gotoAndStop(_currentTab + 1);
		}
		
		private function clearList():void
		{
			if(_list)
			{
				for each(var i:InvitePlayerItem in _list.items)
				{
					i.dispose();
					i = null;
				}
				
				_list.clearItems();
				_currentTab = 0;
			}
		}
		
		private function __consortiaClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_currentTab == 2)return;
			_currentTab = 2;
			_bg.bg.gotoAndStop(3);
			_controller.refleshList(_currentTab);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			
			clearList();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
			
			if(_bg && _bg.parent)
				_bg.parent.removeChild(_bg);
			_bg = null;
			
			_controller = null;
			_model = null;
			
			super.dispose();
		}
	}
}