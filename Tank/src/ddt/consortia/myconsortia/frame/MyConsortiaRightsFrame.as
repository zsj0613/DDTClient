package ddt.consortia.myconsortia.frame
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.consortia.ConsortiaModel;
	import ddt.consortia.event.ConsortiaDataEvent;
	import tank.consortial.accect.MyConsortiaRightsAsset;
	import ddt.manager.LanguageMgr;

	public class MyConsortiaRightsFrame extends HConfirmFrame
	{
		private var _contextBg : MyConsortiaRightsAsset;
		private var _jobPane   : MyConsortiaJobsList;
		private var _model     : ConsortiaModel;
		private var _checkBoxs : Array = new Array();
		public static var selectItem : MyConsortiaJobItem;
		public function MyConsortiaRightsFrame(model : ConsortiaModel)
		{
			super();
			this._model  = model;
			init();
			addEvent();
			fireEvent = false;
		}
		
		
		private function init() : void
		{
			this.setSize(336,320);
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaRightsFrame.titleText");
			//this.titleText = "职位管理";
			this.okLabel = LanguageMgr.GetTranslation("close");
			//this.okLabel = "关 闭";
			this.showCancel = false;
			this.moveEnable = false;
			
			_contextBg = new MyConsortiaRightsAsset();
			this.addContent(_contextBg,true);
			_contextBg.y = 32;
			_contextBg.x = 11;
			
			
			_jobPane = new MyConsortiaJobsList();
			_jobPane.x = this._contextBg.jobPos.x
			_jobPane.y = this._contextBg.jobPos.y;

			_contextBg.jobPos.visible = false;
			_contextBg.checkBoxsPos.visible = false;
			_contextBg.addChild(_jobPane);
			
			
		}
		override protected function __addToStage(e: Event):void
		{
			super.__addToStage(e);
			super.removeKeyDown();
		}
		public function addEvent() : void
		{
			okFunction = cannelFun;
			_model.addEventListener(ConsortiaDataEvent.DUTY_LIST_CHANGE,     __consortiaDutyHandler);
			_jobPane.addEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,  __selectItemHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
			
		}
		private function __consortiaDutyHandler(evt : ConsortiaDataEvent) : void
		{
			this._jobPane.info = _model.dutyList;
		}
		
		
	
		private function __selectItemHandler(evt : ConsortiaDataEvent) : void
		{
			var item : MyConsortiaJobItem = evt.data as MyConsortiaJobItem;
			if(this._contextBg.myConsortiaCheckBoxAsset.totalFrames >= item.info.Level)
			this._contextBg.myConsortiaCheckBoxAsset.gotoAndStop(item.info.Level);
		}
		
		
		override public function dispose() : void
		{
			removeEvent();
			super.dispose();
			if(this && this.parent)this.parent.removeChild(this);
			
			
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				if(cancelBtn.enable)
				{
					if(cancelFunction != null)
					{
						cancelFunction();
					}else
					{
						SoundManager.instance.play("008");
						hide();
					}
				}
			}
		}
		
		public function removeEvent() : void
		{
			okFunction = null;
			_model.removeEventListener(ConsortiaDataEvent.DUTY_LIST_CHANGE,     __consortiaDutyHandler);
			_jobPane.removeEventListener(ConsortiaDataEvent.SELECT_CLICK_ITEM,  __selectItemHandler);
			this.removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		private function cannelFun() : void
		{
			if(_jobPane)_jobPane.hideRightsFrams();
			if(this && this.parent)this.parent.removeChild(this);
		}
		
	}
}