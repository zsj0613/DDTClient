package ddt.consortia.club
{
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.consortia.ConsortiaControl;
	import tank.consortia.accect.ApplyItemAsset;


	public class ConsortiaRecordItem extends ApplyItemAsset
	{
		private var _hbBtns : HBaseButton;
		private var _type   : String;
		private var _controler:ConsortiaControl;
		public function ConsortiaRecordItem(controler:ConsortiaControl)
		{
			_controler = controler;
			super();
			init();
			addEvent();
		}
		
		private function init() : void
		{
			titleTxt.selectable = false;
			titleTxt.mouseEnabled = false;
			applyRecordBg.gotoAndStop(1);
			
		}
		private function addEvent() : void
		{
			if(_hbBtns)_hbBtns.addEventListener(MouseEvent.CLICK, __recordBtClickHandler);
		}
	    
		
		internal function set type(t : String) : void
		{
			_type = t; 
			switch(t)
			{
				case "applyRecord":
				_hbBtns = new HBaseButton(cancleApplyBtnAccect);
				_hbBtns.useBackgoundPos = true;
				addChild(_hbBtns);
				this.removeChild(this.acceptInviteBtnAsset);
				break;
				case "inviteRecord":
				_hbBtns = new HBaseButton(acceptInviteBtnAsset);
				_hbBtns.useBackgoundPos = true;
				addChild(_hbBtns);
				this.removeChild(cancleApplyBtnAccect);
				break;
			}
			addEvent();
		}
		private function __recordBtClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(_type == "applyRecord")
			{
				_controler.sendDeleteTryinRecord(_info.ID);
			}else if(_type == "inviteRecord")
			{
				_controler.sendInventPass(_info.ID)
			}
		}
		public function dispose ():void
		{
			if(_hbBtns)_hbBtns.removeEventListener(MouseEvent.CLICK, __recordBtClickHandler);
			if(_hbBtns && _hbBtns.parent)_hbBtns.parent.removeChild(_hbBtns);
			if(_hbBtns)_hbBtns.dispose();
			_hbBtns = null;
			_info = null;
			_type ="";
			if(this.parent)this.parent.removeChild(this);
			
		}
		
		private function upView() : void
		{
			this.titleTxt.text = _info.ConsortiaName;
		}
		
		public function gotoRecordTxtBg(b : Boolean) : void
		{
			if(!b)applyRecordBg.gotoAndStop(2);
		}
		
		private var _info : Object;
		public function set info(data : Object) : void
		{
			_info = data;
			upView();
		}
		public function get info() : Object
		{
			return this._info;
		}
		public function get id() : String
		{
			return String(_info.UserID);
		}

		
		
	}
}