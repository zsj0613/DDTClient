package ddt.view.consortia{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.consortia.accect.MyConsortiaTaxViewAccect;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	public class MyConsortiaTax extends HConfirmFrame
	{
		private var _input:uint;   //输入点券数
		private var _money: Number; //输入点券数转换后财富
		private var _bg:MyConsortiaTaxViewAccect ;//背景
		
		public function MyConsortiaTax()
		{
			super();			
			init();
			addEvent();
		}
		
		private function init() : void
		{
			this.buttonGape = 70;
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.titleText");
			//this.titleText = "上缴会费";
			this.setSize(415,220);
			this.okBtnEnable = false;
		
			fireEvent = false;
			moveEnable = false;
	
			_bg = new MyConsortiaTaxViewAccect();
			_bg.inputTicket_txt.restrict = "0-9"; 
			
			_bg.totalMoney_txt.selectable = false;
			_bg.totalMoney_txt.mouseEnabled = false;
			_bg.totalTicket_txt.selectable = false;
			_bg.totalMoney_txt.mouseEnabled = false;
			_bg.totalMoney_txt.text = "0";
			_bg.x = 10;
			_bg.y = 10;
			
			this.addContent(_bg,true);
			closeCallBack = __cancel;
			
			
			//bret 09.6.10 当身上点券为0时
			if(PlayerManager.Instance.Self.Money == 0)
			{
				okBtnEnable = false;
				_bg.inputTicket_txt.restrict = "";
			}
		} 
		
		private function __displayCursor(e:Event):void
		{	
			isTex(false);
			_bg.inputTicket_txt.stage.focus = _bg.inputTicket_txt;
			_bg.inputTicket_txt.text = "";
			_bg.totalMoney_txt.text = "0";
			_bg.totalTicket_txt.text = String("您目前拥有 " + PlayerManager.Instance.Self.Money + " 元宝，捐献多少呢？");
			okBtnEnable = false;
			//_bg.totalTicket_txt.text = String("您目前拥有 " + PlayerManager.Instance.Self.Money + " 点券，捐献多少呢？");
		}
		
		public function addEvent():void
		{
			this.okFunction = sendOffer;
			this.cancelFunction = __cancel;
			this.cancelFunction = __cancel;
			if(stage) stage.focus = _bg.inputTicket_txt;
			_bg.totalTicket_txt.text = String("您目前拥有 " + PlayerManager.Instance.Self.Money + " 元宝，捐献多少呢？");
			_bg.inputTicket_txt.addEventListener(Event.CHANGE,        __input);
			_bg.inputTicket_txt.addEventListener(Event.ADDED_TO_STAGE,__displayCursor);
		}
		public function removeEvent() : void
		{
			this.okFunction = null;
			this.cancelFunction = null;
			this.cancelFunction = null;
			_bg.inputTicket_txt.removeEventListener(Event.CHANGE,        __input);
			_bg.inputTicket_txt.removeEventListener(Event.ADDED_TO_STAGE,__displayCursor);
		}
		
		override public function close():void
		{
			super.close();
			removeEvent();
		}
		override public function hide():void
		{
			super.close();
			removeEvent();
		}
		override protected function __closeClick(e: MouseEvent):void
		{
			okBtnEnable = false;
			removeEvent();
			super.__closeClick(e);
		}
		private function __cancel():void
		{
			removeEvent();
			okFunction = null;
			okBtnEnable = false;
			_bg.inputTicket_txt.text = "";
			_bg.totalMoney_txt.text = "0";
			if(parent)parent.removeChild(this);
			dispose();
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			super.__onKeyDownd(e);
		}
		
		private function sendOffer():void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
//				HConfirmDialog.show("提示","二级密码尚未解锁，不可进行操作。");
				new BagLockedGetFrame().show();
				return ;
			}
			var money : int = int(_bg.inputTicket_txt.text);
			if(money > PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
			}
			else
			{
				
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.sure"),true,sendSocketData,null);
				//HConfirmDialog.show("提示","是否确认上缴?",true,sendSocketData);
			}
			
		}
		private function sendSocketData() : void
		{
			var money : int = int(_bg.inputTicket_txt.text);
			SocketManager.Instance.out.sendConsortiaRichOffer(money);
			_bg.totalMoney_txt.text = "0";
			okBtnEnable = false;
			dispose();
		}
		/* 玩家输入点券数 */
		private function __input(evt:Event):void
		{
			this.okBtnEnable = true;
			if(!isTex())return;
			var money : int = int(_bg.inputTicket_txt.text);
			_bg. inputTicket_txt.maxChars = 6;
			if(money <= PlayerManager.Instance.Self.Money)
			{
				if(_bg.inputTicket_txt.text == "")this.okBtnEnable = false;
				 _bg. inputTicket_txt.restrict = "0-9";
//			     _bg. inputTicket_txt.maxChars = String(PlayerManager.Instance.Self.Money).length;
			}
			else
			{
				_bg.inputTicket_txt.text = String(PlayerManager.Instance.Self.Money);
//				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,__fillClick,null);
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIDiamondView.moneyDeficient"));
				//MessageTipManager.getInstance().show("您的点券不足");
			}
			if(money == 0)
			{
				this.okBtnEnable = false;
				_bg.inputTicket_txt.text = "";
			}
			_money = Number((evt.currentTarget as TextField).text)*100;
			_bg.totalMoney_txt.text = String(Math.floor(_money));
			
		}
		
		private function isTex(b : Boolean=true): Boolean
		{
			if(PlayerManager.Instance.Self.Money == 0 && b)
			{
				_bg.inputTicket_txt.text = "";
				_bg.inputTicket_txt.restrict = "";
				okBtnEnable = false;
//				if(b)MessageTipManager.getInstance().show("您的点券余额为0");
				return false;
			}
			else
			{
				_bg.inputTicket_txt.restrict = "0-9";
			}
			return true;
		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_bg.parent)_bg.parent.removeChild(_bg);
			if(cancelBtn && cancelBtn.parent)cancelBtn.parent.removeChild(cancelBtn);
			if(cancelBtn)cancelBtn.dispose();
			if(okBtn && okBtn.parent)okBtn.parent.removeChild(okBtn);
			if(okBtn)okBtn.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		
		/* bret 09.7.14 */
		public function set TextInput(str:String):void
		{
			_bg.inputTicket_txt.text = str;
			_bg.totalMoney_txt.text = "0";
		}
	}
}