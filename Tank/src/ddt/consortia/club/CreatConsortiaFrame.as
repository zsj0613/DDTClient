package ddt.consortia.club
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.StringHelper;
	
	import ddt.consortia.ConsortiaControl;
	import tank.consortia.accect.CreateConsortiaAsset;
	import ddt.data.EquipType;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.QuickBuyFrame;
	
	public class CreatConsortiaFrame extends HConfirmFrame
	{
		private var fastPurchaseGoldBox:FastPurchaseGoldBox;
		private var _quick:QuickBuyFrame;
		private var _context : CreateConsortiaAsset;
		private var _control : ConsortiaControl;
		public function CreatConsortiaFrame(controler:ConsortiaControl)
		{
			super();
			_control = controler;
			init();
			addEvent();	
		}
		private function init() : void
		{
			setSize(355,230);
			buttonGape = 20;
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.club.CreatConsortiaFrame.titleText");
			//this.titleText = "创建公会";
			okLabel = LanguageMgr.GetTranslation("ok");
			cancelLabel = LanguageMgr.GetTranslation("cancel");
			_context = new CreateConsortiaAsset();
			this.addContent(_context,false);
			_context.inputTxt.text = "";
			_context.inputTxt.restrict = "a-z 0-9 ([\u4e00-\u9fa5]*)  -~^ ";
			this.fireEvent = false;
			okBtnEnable = false;
		}
		private function addEvent() : void
		{
			okFunction = sendCreatedConsortia;
			_context.inputTxt.addEventListener(TextEvent.TEXT_INPUT,                __callCheckLength);
			_context.addEventListener(Event.ADDED_TO_STAGE,                         __context);
			_context.inputTxt.addEventListener(Event.CHANGE,__input);
			PlayerManager.Instance.addEventListener(PlayerManager.CONSORTIA_CHANNGE,__onConsortiaChange);
		}	
		private function removeEvent() : void
		{
			okFunction = null;
			_context.inputTxt.removeEventListener(TextEvent.TEXT_INPUT,                __callCheckLength);
			_context.removeEventListener(Event.ADDED_TO_STAGE,                         __context);
			_context.inputTxt.removeEventListener(Event.CHANGE,__input);
			PlayerManager.Instance.removeEventListener(PlayerManager.CONSORTIA_CHANNGE,__onConsortiaChange);
		}	
		private function __callCheckLength(e:TextEvent):void
		{
			StringHelper.checkTextFieldLength(_context.inputTxt,12);
		}
		
		private function __context(e:Event):void
		{
			_context.inputTxt.stage.focus = _context.inputTxt;
		}
		
		private function __input(e:Event):void
		{
			if(_context.inputTxt.text != "")
			{
				okBtnEnable = true;
			}
			else okBtnEnable = false;
		}
		
		/**
		 * 
		 * 创建工会 bret 09.5.21
		 */		
		
		private function sendCreatedConsortia():void
		{
            if(!checkCanCreatConsortia())return;
            SocketManager.Instance.out.sendCreateConsortia(this._context.inputTxt.text);
		}
		
		private function okFastPurchaseGold():void
		{
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.close();
			}
			
			_quick = new QuickBuyFrame(LanguageMgr.GetTranslation("ddt.view.store.matte.goldQuickBuy"),"");
			_quick.cancelFunction=_quick.closeCallBack=cancelQuickBuy;
			_quick.itemID = EquipType.GOLD_BOX;
			_quick.x = 350;
			_quick.y = 200;
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,__shortCutBuyHandler);
			_quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,__shortCutBuyMoneyOkHandler);
			_quick.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
			_quick.show();
		}
		
		private function cancelQuickBuy():void
		{
			if(_quick)
			{
				_quick.close();
			}
		}
		
		private function cancelFastPurchaseGold():void
		{
			if(fastPurchaseGoldBox)
			{
				fastPurchaseGoldBox.close();
			}
		}
		
		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
		private function __shortCutBuyHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			this.show();
		}
		
		private function __shortCutBuyMoneyOkHandler(evt:ShortcutBuyEvent):void
		{
			evt.stopImmediatePropagation();
			okFastPurchaseGold();
		}
		
		/**
		 * 
		 * 玩家是否有公会状态切换 bret 09.5.21
		 * 
		 */		
		private function __onConsortiaChange(e:Event):void
		{   
			 /* 进入玩家创建的公会界面 bret09.5.21*/
            _control.viewState = ConsortiaControl.MYCONSORTIA_STATE;
            
            dispose();       
            
		}
		
		/**
		 * 
		 * 判断是否具备创建公会的条件 
		 * 
		 */		
		
		private function checkCanCreatConsortia():Boolean
		{
			/* 检查人物是否具备创建公会的条件 */
			
			/* 如果没有输入公会名 */
			if(_context.inputTxt.text =="")
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.CreatConsortiaFrame.inputPlease"));
				//MessageTipManager.getInstance().show("请输入您要创建的公会名");
				return false;
			}
			
			/* 如果名称太长 */
//			if(this._context.inputTxt.length > 6)s = 1;
						
			/* 如果等级不够 */
			/* 如果金钱不够 */
			if(PlayerManager.Instance.Self.Money < 1000)
			{
//				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
			    MessageTipManager.getInstance().show("您的元宝余额不足");
			    //MessageTipManager.getInstance().show("您身上的金币，余额不足");
			    return false;
			}
			/* 是否含有政治、官方禁用的词汇及骂人词汇 */			
			if(FilterWordManager.isGotForbiddenWords(_context.inputTxt.text,"name"))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.club.CreatConsortiaFrame.consortiaName"));
				//MessageTipManager.getInstance().show("公会名不能含有非法信息");
				return false;
			}
			
			return true;
		}
		
		override public function hide():void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(this.parent)this.parent.removeChild(this);
		}
		
		
		
	}
}