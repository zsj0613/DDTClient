package ddt.view.emailII
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.emailII.EmailIIStripAsset;
	
	import road.manager.SoundManager;
	import road.ui.accect.CheckUIAccect;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.EmailInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MailManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.TimeManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	public class EmailIIStrip extends EmailIIStripAsset
	{
		internal static const SELECT:String = "select";
		
		internal var _info:EmailInfo;
		internal var _isReading:Boolean;
		
		private var _cell:DiamondOfStrip;
		private var checkBox:HCheckBox;
		private var _delete_btn : HBaseButton;
		
		internal function set info(value:EmailInfo):void
		{
			_info = value;
			update();
		}
		internal function get info():EmailInfo
		{
			return _info;
		}

		internal function set isReading(value:Boolean):void
		{
			if(_isReading == value)return;
			_isReading = value;
			update();
		}
		
		public function get selected():Boolean
		{
			return checkBox.selected;
		}
		
		public function set selected(value:Boolean):void
		{
			checkBox.selected = value;
		}
		
		public function EmailIIStrip()
		{
			initView();
			addEvent();
		}
		
		internal function initView():void
		{
			checkBox = new HCheckBox("");
			checkBox.x = checkBoxPos_mc.x;
			checkBox.y = checkBoxPos_mc.y;
			checkBox.fireAuto = true;
			checkBox.selected = false;
			addChild(checkBox);
			removeChild(checkBoxPos_mc);
			
			topic_txt.mouseEnabled = false;
			sender_txt.mouseEnabled = false;
			validity_txt.mouseEnabled = false;
			label_mc.mouseEnabled = false;
			payIcon_mc.mouseEnabled = false;
			
			_delete_btn = new HBaseButton(delete_btn);
			_delete_btn.useBackgoundPos = true;
			addChild(_delete_btn);
			
			_cell = new DiamondOfStrip(0);
			_cell.x = diamondMask_mc.x - 9;
			_cell.y = diamondMask_mc.y - 10;
			addChild(_cell);
			_cell.mask = diamondMask_mc;
			back_mc.gotoAndStop(1);
			back_mc.buttonMode = true;
		}
		
		internal function update():void
		{
			topic_txt.text = _info.Title;
			sender_txt.text = LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.sender") + _info.Sender;
			//sender_txt.text = "发件人:" + _info.Sender;
			
			var remain:Number;
			
			remain = calculateRemainTime(_info.SendTime,_info.ValidDate);
			if(remain >=24)
			{
				validity_txt.text = LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.validity")+String(Math.round(remain/24))+LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.day");				
			}else if(remain>0&&remain<24)
			{
				validity_txt.text = LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.validity")+String(Math.round(remain))+LanguageMgr.GetTranslation("hours");
			}else
			{
				MailManager.Instance.removeMail(info);
				MailManager.Instance.changeSelected(null);
				clearItem();
			}
			label_mc.visible = !_info.IsRead;
			
			if(_info.Type>100)
			{
				label_mc.visible = false;
				
				payIcon_mc.visible = _info.Money > 0;
				if(gmIcon.parent)removeChild(gmIcon);
			}else{
				
				if(_info.Type == 51)
				{
					addChild(gmIcon);
				}else
				{
					if(gmIcon.parent)removeChild(gmIcon);
				}
				payIcon_mc.visible = false;
			}
			
			if(_isReading)
			{
				back_mc.gotoAndStop(2);
			}
			else
			{
				back_mc.gotoAndStop(1);
			}
			_cell.info = _info;
		}
		/**
		 * 
		 * @param startTime  开始时间 (2009-07-10 12:12:42)
		 * @param validHours 有效时间(小时)
		 * @return 剩余时间(小时)
		 * 
		 */		
		private function calculateRemainTime(startTime:String,validHours:Number):Number
		{
			var str:String = startTime;
			var startDate:Date = new Date(Number(str.substr(0,4)),Number(str.substr(5,2))-1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
//			var nowDate:Date = new Date();
			var nowDate:Date = TimeManager.Instance.Now()
			var remain:Number = validHours -(nowDate.time - startDate.time)/(60*60*1000);
			
			if(remain<0)
			{
				return -1;
			}else
			{
				return remain;		
			}
		}
		
		internal function addEvent():void
		{
			_delete_btn.addEventListener(MouseEvent.CLICK,__delete);
			addEventListener(MouseEvent.CLICK,__click);
			addEventListener(MouseEvent.MOUSE_OVER,__over);
			addEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		internal function removeEvent():void
		{
			if(_delete_btn)_delete_btn.removeEventListener(MouseEvent.CLICK,__delete);
			removeEventListener(MouseEvent.CLICK,__click);
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		private function __delete(event:MouseEvent):void
		{
            if(PlayerManager.Instance.Self.bagLocked)
            {
            	new BagLockedGetFrame().show();
            	return;
            }
			if(info.hasAnnexs() || info.Money != 0) {
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.delectEmail"),true,ok,cancle);
			}
			else {
				ok();
			}
		}
		
		private function cancle():void
		{
			SoundManager.instance.play("008");
		}
		
		private function ok():void
		{
			SoundManager.instance.play("008");
			MailManager.Instance.deleteEmail(_info);
			clearItem();
			MailManager.Instance.removeMail(info);
			MailManager.Instance.changeSelected(null);
		}	
		
		internal var _emptyItem : Boolean = false;
		public function get emptyItem() : Boolean
		{
			return this._emptyItem;
		}
		private function clearItem() : void
		{
			removeEvent();
			
			buttonMode = false;
			_emptyItem = true;
			topic_txt.text = "";
			sender_txt.text = "";
			validity_txt.text = "";
			if(gmIcon.parent)removeChild(gmIcon);
			if(topic_txt.parent)this.removeChild(topic_txt);
			if(sender_txt.parent)this.removeChild(sender_txt);
			if(validity_txt.parent)this.removeChild(validity_txt);
			if(label_mc.parent)this.removeChild(label_mc);
//			label_mc.mouseEnabled = false;
			if(payIcon_mc.parent)this.removeChild(payIcon_mc);
//			payIcon_mc.mouseEnabled = false;
			
			if(checkBox.parent)this.removeChild(checkBox);
			if(_cell.parent) this.removeChild(_cell);
			back_mc.gotoAndStop(1);
		}
		
		internal function __over(event:MouseEvent):void
		{
			if(!_isReading)
			{
				back_mc.gotoAndStop(2);
			}
		}
		
		internal function __out(event:MouseEvent):void
		{
			if(!_isReading)
			{
				back_mc.gotoAndStop(1);
			}
		}

		internal function __click(event:MouseEvent):void
		{
			if(event.target is CheckUIAccect)
			{
				return;
			}
			
			SoundManager.instance.play("008");
			if(!_info.IsRead)
			{
				MailManager.Instance.readEmail(_info);
				_info.IsRead = true;

                var str:String = _info.SendTime;
                var startTime:Date = new Date(Number(str.substr(0,4)),Number(str.substr(5,2))-1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
				if(!(_info.Type >100&&_info.Money > 0))_info.ValidDate = 72+(TimeManager.Instance.Now().time - startTime.time)/(60*60*1000);
				update();
			}
			isReading = true;
			
			dispatchEvent(new Event(SELECT));
			MailManager.Instance.changeSelected(_info);
		}
		
		internal function dispose():void
		{
			removeEvent();
			if(_delete_btn.parent)this.removeChild(_delete_btn);
			_delete_btn.dispose();
			_delete_btn = null;
			_info = null;
			if(_cell)
			{
				if(_cell.parent)
				{
					removeChild(_cell);
				}
				_cell.dispose();
				_cell = null;
			}
		}
	}
}