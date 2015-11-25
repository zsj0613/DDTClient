package ddt.church.churchScene.invite
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import tank.church.ChurchInviteAsset;
	import ddt.manager.LanguageMgr;
	import ddt.utils.DisposeUtils;

	public class ChurchInviteView extends HConfirmFrame
	{
		private var _bg:ChurchInviteAsset;
	
		private var _controller:ChurchInviteController;
		private var _model:ChurchInviteModel;
		
		private var _currentTab:int;
		private var _refleshCount:int;
		
		private var _list:SimpleGrid;
		
		public function ChurchInviteView(controller:ChurchInviteController,model:ChurchInviteModel)
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
			_bg = new ChurchInviteAsset();
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
			
			initEvent();
		}
	
		private function initEvent():void
		{
			_bg.friend_btn.addEventListener(MouseEvent.CLICK,__friendClick);
			_bg.consortia_btn.addEventListener(MouseEvent.CLICK,__consortiaClick);
			_model.addEventListener(ChurchInviteModel.LIST_UPDATE,__listUpdate);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			_refleshCount = 0;
		}
		
		private function __refleshClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
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
		
		private function __friendClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_currentTab == 0)return;
			_currentTab = 0;
			_bg.bg.gotoAndStop(1);
			_controller.refleshList(_currentTab);
		}
		
		private function __consortiaClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_currentTab == 1)return;
			_currentTab = 1;
			_bg.bg.gotoAndStop(2);
			_controller.refleshList(_currentTab);
		}
		
		private function __listUpdate(evt:Event):void
		{
			_list.clearItems();
			var l:Array = _model.currentList;
			for(var i:int = 0; i < l.length; i++)
			{
				var item:ChurchInvitePlayerItem = new ChurchInvitePlayerItem(l[i]);
				_list.appendItem(item);
			}
			_currentTab = _model.type;
			_bg.bg.gotoAndStop(_currentTab + 1);
		}
		
		override public function dispose():void
		{
			super.dispose();
			for each(var i:ChurchInvitePlayerItem in _list)
			{
				i.dispose();
			}
			if(_model)_model.removeEventListener(ChurchInviteModel.LIST_UPDATE,__listUpdate);
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