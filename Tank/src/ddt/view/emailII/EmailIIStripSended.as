package ddt.view.emailII
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.emailII.DiamondAsset;
	
	import ddt.data.EmailInfoOfSended;
	import ddt.manager.LanguageMgr;
	
	public class EmailIIStripSended extends EmailIIStrip
	{
		private var cell:DiamondAsset;
		public function EmailIIStripSended()
		{
			super();
		}
		
		override internal function initView():void
		{
			topic_txt.mouseEnabled = false;
			sender_txt.mouseEnabled = false;
			
			removeChild(checkBoxPos_mc);
			removeChild(validity_txt);
			removeChild(label_mc);
			removeChild(payIcon_mc);
			removeChild(delete_btn);
			removeChild(gmIcon);
			
			cell = new DiamondAsset();
			cell.charged_mc.visible = false;
			cell.removeChild(cell.picPos_mc);
			cell.removeChild(cell.count_txt);
			cell.click_mc.gotoAndStop(5);
			cell.x = diamondMask_mc.x - 9;
			cell.y = diamondMask_mc.y - 10;
			addChild(cell);
			cell.mask = diamondMask_mc;
			back_mc.gotoAndStop(1);
			back_mc.buttonMode = true;
		}
		
		override internal function update():void
		{
			topic_txt.text = _info.Title;
//			sender_txt.text = LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.sender") + _info.Sender;
			sender_txt.text = LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripSended.sender_txt") + (_info as EmailInfoOfSended).Receiver;
			//sender_txt.text = "收件人:" + (_info as EmailInfoOfSended).Receiver;
			
			if(_isReading)
			{
				back_mc.gotoAndStop(2);
			}
			else
			{
				back_mc.gotoAndStop(1);
			}
		} 
		
		override internal function addEvent():void
		{
			addEventListener(MouseEvent.CLICK,__click);
			addEventListener(MouseEvent.MOUSE_OVER,__over);
			addEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		override internal function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,__click);
			removeEventListener(MouseEvent.MOUSE_OVER,__over);
			removeEventListener(MouseEvent.MOUSE_OUT,__out);
		}
		
		override internal function dispose():void
		{
			removeEvent();
			_info = null;
			if(cell.parent)
			{
				removeChild(cell);
			} 
			cell = null;
		}
	}
}