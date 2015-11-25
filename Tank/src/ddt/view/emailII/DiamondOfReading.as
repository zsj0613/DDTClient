package ddt.view.emailII
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.goods.InventoryItemInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MailManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	/**
	 * 读附件
	 * @author SYC
	 * 
	 */
	public class DiamondOfReading extends DiamondBase
	{		
		private var type:int;
		
		public function set readOnly(value:Boolean):void
		{
			if(value)
			{
				removeEvent();
			}else
			{
				addEvent();
			}
		}
		
		public function DiamondOfReading(index:int)
		{
			super(index);
		}
		
		override protected function addEvent():void
		{
			addEventListener(MouseEvent.CLICK,__distill);
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,__distill);
		}
		
		override protected function update():void
		{
			var annex:* = _info.getAnnexByIndex(_index);
			charged_mc.visible = false;
			if(annex && annex is String)
			{
				_cell.visible = false;
				click_mc.visible = true;
				count_txt.text = "";
				mouseEnabled = true;
				mouseChildren = true;
								
				if(annex == "gold")
				{
					click_mc.gotoAndStop(3);
					count_txt.text = String(_info.Gold);
					mouseChildren = false;
				} 
				else if(annex == "money")
				{
					if(_info.Type >100)
					{
						click_mc.visible = false;
						mouseEnabled = false;
						mouseChildren = false;
					}
					else
					{
						click_mc.gotoAndStop(2);
						count_txt.text = String(_info.Money);
						mouseChildren = false;
					}
				}else if(annex == "gift")
				{
					click_mc.gotoAndStop(6);
					count_txt.text = String(_info.GiftToken);
					mouseChildren = false;
				}
				
			}
			else if(annex)
			{
				_cell.visible = true;
				_cell.info = (annex as InventoryItemInfo);
				mouseEnabled = true;
				mouseChildren = true;
				count_txt.text = "";
				
				if(_info.Type >100 && _info.Money > 0)
				{
					click_mc.visible = true;
					click_mc.gotoAndStop(7);
					charged_mc.visible = true;
				}else{
					click_mc.visible = false;
				}
			}
			else
			{
				mouseEnabled = false;
				mouseChildren = false;
				click_mc.visible = false;
				_cell.visible = false;
				count_txt.text = ""; 
			}
		}
		
		/**
		 * 提取附件 
		 * @param event
		 * 
		 */		
		private function __distill(event:MouseEvent):void
		{
			SoundManager.instance.play("008");//bret 09.6.11
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			mouseEnabled = false;
			mouseChildren = false;
			if(_info == null)return;
			var annex:* = _info.getAnnexByIndex(_index);
			if(annex)
			{
				for(var i:uint = 1;i<=5;i++)
				{
					if(annex == _info["Annex"+i])
					{
						type = i;
						break;
					}
				}
				if(annex == "gold")
				{
					type = 6;
				}
				else if(annex == "money")
				{
					type = 7;
				}else if(annex == "gift")
				{
					type = 8;
				}
			}
			if(type > -1)
			{
//				if(_type == -1)
//				{
//					type = _type;//包裹栏满的情况判断 bret 09.5.18	
//				    MailManager.Instance.getAnnexToBag(_info,type);	//包裹栏满的情况判断 bret 09.5.18
//				}			
				if(_info.Type >100 && (type>=1&&type<=5) && _info.Money > 0)
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIDiamondView.emailTip"),LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIDiamondView.deleteTip")+" "+_info.Money+LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIDiamondView.money"),true,confirmPay,canclePay,false);
					//ConfirmDialog.show("提示：付费邮件",需要扣除+" "+_info.Money+"点券",true,startPay,canclePay);
					return;
				}
				MailManager.Instance.getAnnexToBag(_info,type);
			}
		}
		/**
		 * 确认支付 
		 */		
		private function confirmPay():void
		{
			if(PlayerManager.Instance.Self.Money >= _info.Money)
			{
				MailManager.Instance.getAnnexToBag(_info,type);
				mouseEnabled = false;
				mouseChildren = false;
			}
			else
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				//MessageTipManager.getInstance().show("您的点券不足");
				mouseEnabled = true;
				mouseChildren = true;
			}
		}
		/**
		 * 取消支付 
		 */		
		private function canclePay():void
		{
			mouseEnabled = true;
			mouseChildren = true;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}