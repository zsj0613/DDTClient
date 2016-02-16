﻿﻿package ddt.view.emailII
{
	import fl.controls.BaseButton;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.emailII.WritingEmailAsset;
	
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	import road.utils.StringHelper;
	
	import ddt.data.EmailInfo;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MailManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.SimpleButtonTip;
	
	public class WritingView extends BaseEmailRightView implements IAcceptDrag
	{
		private var _asset:WritingEmailAsset;
		
		private var _friendList:FriendListView;
		
		private var _selectInfo:EmailInfo;
		
		private var _send_btn  : HLabelButton;
		private var _close_btn : HLabelButton;
		private var _pay_btn   : HBaseButton;
//		private var _sendMoney_btn : HBaseButton;
		
		private var _checkBox : HCheckBox;
		
		private var _diamonds:Array;
		
		private var oneHour_btn:HFrameButton;
		private var sixHour_btn:HFrameButton;
		
		private var _bag:BagFrame;
		
		private var isChargeMail:Boolean = false;
		private var _hours:uint;
		
		private var _titleIsManMade:Boolean = false;
		
		public function set selectInfo(value:EmailInfo):void
		{
			_selectInfo = value;
		}
		public function WritingView()
		{
			super();
			
			closeCallBack = closeWin;
		}
		
		/**
		 * 当前邮件是否编写过 
		 * @return 
		 * 
		 */		
		private function isHasWrite():Boolean
		{
			if(!StringHelper.IsNullOrEmpty(FilterWordManager.filterWrod(_sender.text)))
			{
				return true;
			}
			if(!StringHelper.IsNullOrEmpty(FilterWordManager.filterWrod(_topic.text)))
			{
				return true;
			}
			if(!StringHelper.IsNullOrEmpty(FilterWordManager.filterWrod(_ta.text)))
			{
				return true;
			}
			
			for(var i:uint = 0;i<4;i++)
			{
				if(DiamondOfWriting(_diamonds[i]).annex)
				{
					return true;
				}
			}
			
			return false;
		}
		
		override protected function initView():void
		{
			super.initView();
			_asset = new WritingEmailAsset();
			addContent(_asset);
			setContentSize(408,466);
			
			oneHour_btn = new HFrameButton(_asset.oneH_btn,"");
			oneHour_btn.useBackgoundPos = true;
			oneHour_btn.enable = false;
			_asset.addChild(oneHour_btn);
			
			sixHour_btn = new HFrameButton(_asset.sixH_btn,"");
			sixHour_btn.useBackgoundPos = true;
			sixHour_btn.enable = false;
			_asset.addChild(sixHour_btn);

			_sender.type = TextFieldType.INPUT;
			_topic.type = TextFieldType.INPUT;

			_topic.maxChars = 16;
			
			_checkBox = new HCheckBox("");
			_checkBox.fireAuto = true;
			_checkBox.enable = false;
			_checkBox.x = _asset.moneyCheckBoxPos.x;
			_checkBox.y = _asset.moneyCheckBoxPos.y;
			_asset.addChild(_checkBox);
			_checkBox.mouseChildren = _checkBox.mouseEnabled = _checkBox.buttonMode = false;
			_asset.moneyCheckBoxPos.visible = false;
			
			ComponentHelper.replaceChild(_asset,_asset.senderPos_mc,_sender);
			ComponentHelper.replaceChild(_asset,_asset.topicPos_mc,_topic);
			ComponentHelper.replaceChild(_asset,_asset.contentPos_mc,_ta);			
			
			_friendList = new FriendListView(selectName);
//			_friendList.visible = false;
//			_friendList.x = _asset.com_btn.x + _asset.com_btn.width;
//			_friendList.y = _asset.com_btn.y;
//			_asset.addChild(_friendList);

			_diamonds = new Array();
			
			for(var i:uint = 0;i<MailManager.Instance.NUM_OF_WRITING_DIAMONDS;i++)
			{
				var diamond:DiamondOfWriting = new DiamondOfWriting(i);
				diamond = new DiamondOfWriting(i);
				diamond.x = _asset.diamondListPos_mc.x + i*68.5;
				diamond.y = _asset.diamondListPos_mc.y + 1;
				_asset.addChild(diamond);
				
				_diamonds.push(diamond);
			}
			
			_asset.diamondListPos_mc.visible = false;
			
			_bag = new BagFrame();
			
//			_asset.sendMoney_mc.gotoAndStop(2);
//			_asset.pay_mc.gotoAndStop(1);
			
			_asset.money_txt.restrict = "0-9";
			_asset.money_txt.maxChars = 9;
			_asset.money_txt.visible  = false;
			
			_send_btn   = new HLabelButton();
			_send_btn.label = LanguageMgr.GetTranslation("send");
			_send_btn.useBackgoundPos = true;
			_send_btn.x = _asset.sendPos_mc.x;
			_send_btn.y = _asset.sendPos_mc.y;
			_asset.removeChild(_asset.sendPos_mc);
			_asset.addChild(_send_btn);
			
			_close_btn = new HLabelButton();
			_close_btn.label = LanguageMgr.GetTranslation("cancel");
			_close_btn.useBackgoundPos = true;
			_close_btn.x = _asset.cancelPos_mc.x;
			_close_btn.y = _asset.cancelPos_mc.y;
			_asset.removeChild(_asset.cancelPos_mc);
			_asset.addChild(_close_btn);
			
			_pay_btn = new HBaseButton(_asset.pay_btn);
			_pay_btn.useBackgoundPos = true;
			_asset.addChild(_pay_btn);
			
			_pay_btn.enable = false;
			
//			_sendMoney_btn = new HBaseButton(_asset.sendMoney_btn);
//			_sendMoney_btn.useBackgoundPos = true;
//			_asset.addChild(_sendMoney_btn);
		}
		
		private function selectName(nick:String,id:int = 0):void
		{
			_sender.text = nick;
		}
		
		public function dragDrop(effect:DragEffect):void
		{
//			DragManager.acceptDrag(null);
            effect.action = DragEffect.MOVE;
            var info:InventoryItemInfo = effect.data as InventoryItemInfo;
			if(info && effect.action != DragEffect.SPLIT)
			{
				for(var i:int = 0; i < _diamonds.length; i ++)
				{
					if(_diamonds[i].annex == null)
					{
						_diamonds[i].dragDrop(effect);
						if(effect.target)
						{
							return;
						}
					}
				}
				effect.action = DragEffect.NONE;
				DragManager.acceptDrag(this);
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.EmaillIIBagCell.full"));
			}
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_send_btn.addEventListener(MouseEvent.CLICK,__send);
			_close_btn.addEventListener(MouseEvent.CLICK,__close);
			_topic.addEventListener(Event.CHANGE,__sound);
			_sender.addEventListener(Event.CHANGE,__sound);
			_ta.addEventListener(Event.CHANGE,__sound);
			_ta.addEventListener(TextEvent.TEXT_INPUT,__taInput);
			addEventListener(Event.ADDED_TO_STAGE,addToStageListener);
			
			oneHour_btn.addEventListener(MouseEvent.CLICK,selectHourListener);
			oneHour_btn.addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			oneHour_btn.addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			sixHour_btn.addEventListener(MouseEvent.CLICK,selectHourListener);
			sixHour_btn.addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			sixHour_btn.addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			
			_asset.com_btn.addEventListener(MouseEvent.CLICK,__friendListView);
		
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				_diamonds[i].addEventListener(EmailIIEvent.SHOW_BAGFRAME,__showBag);
				_diamonds[i].addEventListener(EmailIIEvent.HIDE_BAGFRAME,__hideBag);
				_diamonds[i].addEventListener(EmailIIEvent.DRAGIN_ANNIEX,doDragIn);
				_diamonds[i].addEventListener(EmailIIEvent.DRAGOUT_ANNIEX,doDragOut);
			}
						
//			_sendMoney_btn.addEventListener(MouseEvent.CLICK,selectMoneyType);
//			_asset.sendMoney_mc.addEventListener(MouseEvent.CLICK,selectMoneyType);
			
			_checkBox.addEventListener(MouseEvent.CLICK,selectMoneyType);
			this._pay_btn.addEventListener(MouseEvent.CLICK,selectMoneyType);
//			_asset.pay_mc.addEventListener(MouseEvent.CLICK,selectMoneyType);

			_asset.money_txt.addEventListener(Event.CHANGE,moneyChange);

			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL,__sendEmailBack);
			addEventListener(KeyboardEvent.KEY_DOWN,__StopEnter);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_send_btn.removeEventListener(MouseEvent.CLICK,__send);
//			_asset.send_btn.removeEventListener(MouseEvent.CLICK,__send);
			_close_btn.removeEventListener(MouseEvent.CLICK,__close);
//			_asset.close_btn.removeEventListener(MouseEvent.CLICK,__close);
			_topic.removeEventListener(Event.CHANGE,__sound);
			_sender.removeEventListener(Event.CHANGE,__sound);
			_ta.removeEventListener(Event.CHANGE,__sound);
			_ta.removeEventListener(TextEvent.TEXT_INPUT,__taInput);
			removeEventListener(Event.ADDED_TO_STAGE,addToStageListener);
			_asset.com_btn.removeEventListener(MouseEvent.CLICK,__friendListView);
			
			oneHour_btn.removeEventListener(MouseEvent.CLICK,selectHourListener);
			oneHour_btn.removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
			oneHour_btn.removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			sixHour_btn.removeEventListener(MouseEvent.CLICK,selectHourListener);
			sixHour_btn.removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
			sixHour_btn.removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				_diamonds[i].removeEventListener(EmailIIEvent.SHOW_BAGFRAME,__showBag);
				_diamonds[i].removeEventListener(EmailIIEvent.HIDE_BAGFRAME,__hideBag);
				_diamonds[i].removeEventListener(EmailIIEvent.DRAGIN_ANNIEX,doDragIn);
				_diamonds[i].removeEventListener(EmailIIEvent.DRAGOUT_ANNIEX,doDragOut);
			}
			//			_sendMoney_btn.removeEventListener(MouseEvent.CLICK,selectMoneyType);
			_checkBox.removeEventListener(MouseEvent.CLICK,selectMoneyType);
			this._pay_btn.addEventListener(MouseEvent.CLICK,selectMoneyType);
//			_asset.sendMoney_mc.removeEventListener(MouseEvent.CLICK,selectMoneyType);
//			_asset.pay_mc.removeEventListener(MouseEvent.CLICK,selectMoneyType);
			
			_asset.money_txt.removeEventListener(Event.CHANGE,moneyChange);
			
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SEND_EMAIL,__sendEmailBack);
			removeEventListener(KeyboardEvent.KEY_DOWN,__StopEnter);
		}
		
		private var btnTip:SimpleButtonTip;
		private function __showTip(event:MouseEvent):void
		{
			if(!(event.currentTarget as HFrameButton).enable)return;
			
			var label:String = "";
			if(event.currentTarget == oneHour_btn)
			{
				label = LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.backTime");
				//label = "邮件返还时间:1小时";
			}else
			{
				label = LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.backTime2");
				//label = "邮件返还时间:6小时";
			}
			
			btnTip = new SimpleButtonTip(label);
			
			btnTip.x = oneHour_btn.x;	
			btnTip.y = oneHour_btn.y;
			this.addChild(btnTip);
		}
		
		private function __hideTip(event:MouseEvent):void
		{
			if(!btnTip)
			{
				return;
			}else
			{
				if(btnTip.parent)
				{
					btnTip.parent.removeChild(btnTip);
				}
			}
		}
		
		private function __StopEnter(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				e.stopImmediatePropagation();
			}
		}
		
		internal function reset():void
		{
			_sender.text = "";
			_topic.text = "";
			_ta.text = "";
			_asset.money_txt.text = "";
			
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				DiamondOfWriting(_diamonds[i]).annex = null;
			}
			
			_pay_btn.enable = false;
			_checkBox.enable = false;
			oneHour_btn.enable = false;
			sixHour_btn.enable = false;
			_currentHourBtn = null;
			_hours = 1;
			
			setDiamondMoneyType()
		}
		
		private function __taInput(event:TextEvent):void
		{
			if(_ta.text.length > 300)
			{
				event.preventDefault();
			}
		}

		private function __friendListView(event:MouseEvent):void
		{
			btnSound();
			event.stopImmediatePropagation();
//			_friendList.visible = true;

			TipManager.AddTippanel(_friendList);
			var pos:Point = _asset.com_btn.localToGlobal(new Point(0,0));
			_friendList.x = pos.x + _asset.com_btn.width;
			_friendList.y = pos.y;
			
			stage.addEventListener(MouseEvent.CLICK,__stageClick);
		}
		
		private function __stageClick(evt:MouseEvent):void
		{
			if(evt.target is BaseButton)return;
			if(stage)
			{
				stage.removeEventListener(MouseEvent.CLICK,__stageClick);
			}
			evt.stopImmediatePropagation();
			if(_friendList&&_friendList.parent)
			{
//				_friendList.visible = false;
				_friendList.parent.removeChild(_friendList);
			}
		}
		/**
		 * Send mail 
		 * @param event
		 * 
		 */		
		private function __send(event:MouseEvent):void
		{
			btnSound();
			if(PlayerManager.Instance.Self.bagLocked)
			{
//				HConfirmDialog.show("提示","二级密码尚未解锁，不可进行操作。");
				new BagLockedGetFrame().show();
				return;
			}
			
			if(FilterWordManager.IsNullorEmpty(_sender.text))
			{
				
				_sender.text = "";
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.sender"));
				//MessageTipManager.getInstance().show("请填写收件人");
			}
			else if(_sender.text == PlayerManager.Instance.Self.NickName)
			{
				_sender.text = "";
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.NickName"));
				//MessageTipManager.getInstance().show("不能给自己发邮件");
			}
			else if(FilterWordManager.IsNullorEmpty(_topic.text)&&(!getFirstDiamond()))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.topic"));
				//MessageTipManager.getInstance().show("请填写邮件主题");
			}
			else if(PlayerManager.Instance.Self.Gold<100)
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
			}
			else if(_ta.text.length > 300)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.contentLength"));
				//MessageTipManager.getInstance().show("您输入内容不得超过300字");
			}
			else
			{
				if(isChargeMail && !Number(_asset.money_txt.text)) 
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.money_txt"));
					return
				}
				if(isChargeMail && (!atLeastOneDiamond()))
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.annex"));
					return
				}
				
				if(!isChargeMail && int(_asset.money_txt.text) > PlayerManager.Instance.Self.Money)
				{
					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
					return
				}
				
				var param:Object = new Object();
				param.NickName = _sender.text;
				
				if(FilterWordManager.IsNullorEmpty(_topic.text))
				{
					_topic.text = getFirstDiamond().annex.Name;
				}
				
				param.Title = FilterWordManager.filterWrod(_topic.text);
				param.Content = FilterWordManager.filterWrod(_ta.text);
				param.SendedMoney = Number(_asset.money_txt.text);
				param.isPay = isChargeMail;
				
				if(isChargeMail)
				{
					param.hours = _hours;
					var diamond:DiamondOfWriting = getFirstDiamond();
					param.Title=diamond.annex.Name;
				}
				else
				{
					param.SendedMoney = 0;
				}
				var annexArr:Array = [];
				for(var i:uint = 0;i<_diamonds.length;i++)
				{
					if(DiamondOfWriting(_diamonds[i]).annex)
					{
						var tempDiamond:InventoryItemInfo = DiamondOfWriting(_diamonds[i]).annex as InventoryItemInfo;
						annexArr.push(tempDiamond);
						param["Annex"+i] = tempDiamond.BagType.toString() + "," + tempDiamond.Place.toString();
					}
				}
				MailManager.Instance.sendEmail(param);
				MailManager.Instance.onSendAnnex(annexArr);
				_send_btn.enable = false;
			}
		}
		
		private function getFirstDiamond():DiamondOfWriting
		{
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				if(DiamondOfWriting(_diamonds[i]).annex)
				{
					return _diamonds[i] as DiamondOfWriting;
				}
			}
			return null;
		}
		
		private function __close(event:MouseEvent):void
		{
			btnSound();
			closeWin();
		}
		
		
		public  function closeWin():void
		{
			__stageClick(new MouseEvent(MouseEvent.CLICK));
			if(isHasWrite())
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.tip"),LanguageMgr.GetTranslation("ddt.view.emailII.WritingView.isEdit"),true,__okCancel,null);
			}
			else
			{
				__okCancel();
			}
		}
		
		private function __sendEmailBack(e:CrazyTankSocketEvent):void
		{
			_send_btn.enable = true;
		}
		
		public function __okCancel():void
		{
			reset();
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				DiamondOfWriting(_diamonds[i]).setBagUnlock();
			}
			if(_friendList&&_friendList.parent)
			{
//				_friendList.visible = false;
				_friendList.parent.removeChild(_friendList);
			}
			btnSound();
			_bag.close();
			MailManager.Instance.changeState(EmailIIState.READ);	
		}
		
		private function __sound(event:Event):void
		{
			_titleIsManMade = true;
//			btnSound();
		}
		
		private function addToStageListener(event:Event):void
		{
			reset();
			_sender.text = _selectInfo ? _selectInfo.Sender : "";
			_topic.text  = "";
			_ta.text     = "";
			_asset.money_txt.text = "";
			_bag.show();
			
			if(stage)
			{
				stage.focus = this;
			}
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				DiamondOfWriting(_diamonds[i]).annex = null;
			}
		}
		
		private function __showBag(event:EmailIIEvent):void
		{
			var diamond:DiamondOfWriting = event.target as DiamondOfWriting;
			if(diamond.annex == null || _bag.parent == null)
			{
				_bag.show();
			}
		}
		
		private function __hideBag(event:EmailIIEvent):void
		{
			_bag.close();
		}
		
		private function moneyChange(e:Event):void
		{
			if(_asset.money_txt.text.charAt(0) == "0")
			_asset.money_txt.text = "";
			e.preventDefault();
		}
		
		private function doDragIn(e:EmailIIEvent):void
		{
			_pay_btn.enable = true;
			_checkBox.enable = true;
			_checkBox.mouseChildren = _checkBox.mouseEnabled = _checkBox.buttonMode = true;
			if(_topic.text == "" || !_titleIsManMade)
			{
				var diamond:DiamondOfWriting = getFirstDiamond();
				if(diamond)
				{
					_topic.text = diamond.annex.Name;
					_titleIsManMade = false;
				}else
				{
					_topic.text = "";
					_titleIsManMade = false;
				}
			}
			setDiamondMoneyType();			
		}
		
		private function doDragOut(e:EmailIIEvent):void
		{
			
			if(atLeastOneDiamond())
			{
				_pay_btn.enable = true;
				_checkBox.enable = true;
			}
			else
			{
				payEnable(false);
				if(!_titleIsManMade)
				{
					_topic.text = "";
				}
			}
			setDiamondMoneyType();
		}
		
		
		private function payEnable(b : Boolean) : void
		{
			_pay_btn.enable          = b;
			_checkBox.enable         = b;
			_checkBox.mouseChildren  = b;
			_checkBox.mouseEnabled   = b;
			_checkBox.selected       = b;
			_checkBox.buttonMode     = b;
			_asset.money_txt.visible = b;
			_asset.money_txt.text    = "";
			isChargeMail = _checkBox.selected;
		}
		
		/**
		 * 至少有一个附件
		 * @return 
		 */		
		private function atLeastOneDiamond():Boolean
		{
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				if(DiamondOfWriting(_diamonds[i]).annex)
				{
					return true;
				}
			}
			return false;
		}
		
		private function selectMoneyType(e:MouseEvent):void
		{
//			
			if(e.currentTarget is HBaseButton)
			{
				this._checkBox.selected = !_checkBox.selected;
			}
			isChargeMail = _checkBox.selected;
			if(isChargeMail)
			{
				_topic.selectable=false;
			}else
			{
				_topic.selectable=true;
			}
			btnSound();
			_asset.money_txt.text = "";
			_asset.money_txt.visible = _checkBox.selected;
			if(_checkBox.selected)
			{
				if(_asset && _asset.money_txt && _asset.money_txt.stage)_asset.money_txt.stage.focus = _asset.money_txt;
				_checkBox.mouseChildren = _checkBox.mouseEnabled = _checkBox.buttonMode = true;

			}
			else
			{
				_ta.textField.stage.focus = _ta.textField;
			}
			setDiamondMoneyType();
		}
		
		private function setDiamondMoneyType():void
		{
			for(var i:uint = 0;i<_diamonds.length;i++)
			{
				
				DiamondOfWriting(_diamonds[i]).charged_mc.visible = false;
				DiamondOfWriting(_diamonds[i]).click_mc.visible = true;
				
				if(DiamondOfWriting(_diamonds[i]).annex && isChargeMail)
				{
					DiamondOfWriting(_diamonds[i]).click_mc.gotoAndStop(7);
					DiamondOfWriting(_diamonds[i]).charged_mc.visible = true;
				}else if(DiamondOfWriting(_diamonds[i]).annex && !isChargeMail)
				{
					DiamondOfWriting(_diamonds[i]).click_mc.visible = false;
				}else{
					DiamondOfWriting(_diamonds[i]).click_mc.gotoAndStop(1);
				}
			}


			
			switchHourBtnState(isChargeMail);
		}
		
		private var _currentHourBtn:HFrameButton;
		private function selectHourListener(e:MouseEvent):void
		{
			btnSound();
			
			if(_currentHourBtn)_currentHourBtn.selected = false;
			
			_currentHourBtn = e.currentTarget as HFrameButton;
			_currentHourBtn.selected = true;
			
			if(_currentHourBtn == oneHour_btn)
			{
				_hours = 1;
			}else
			{
				_hours = 6;
			}
		}
		
		/**
		 * 切换小时按钮可用状态 
		 * @param isChargeMail
		 * 
		 */				
		private function switchHourBtnState(isChargeMail:Boolean):void
		{
			oneHour_btn.selected = false;
			sixHour_btn.selected = false;
			
			oneHour_btn.enable = isChargeMail;
			sixHour_btn.enable = isChargeMail;
			
			if(isChargeMail)
			{
				_currentHourBtn = oneHour_btn;
				_currentHourBtn.selected = true;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_send_btn.dispose();
			_close_btn.dispose();
			if(_pay_btn)_pay_btn.dispose();
//			_checkBox.dispose();
//			_sendMoney_btn.dispose();
			oneHour_btn.dispose();
			sixHour_btn.dispose();
						
			_send_btn = null;
			_close_btn = null;
			_pay_btn = null;
			_checkBox = null;
//			_sendMoney_btn = null;
			oneHour_btn = null;
			sixHour_btn = null;
			
			if(_friendList.parent)
			{
				_friendList.parent.removeChild(_friendList);
			}
			_friendList.dispose();
			_friendList = null;
			if(_asset.parent)
			{
				_asset.parent.removeChild(_asset);
			}
			_selectInfo = null;
			_asset = null;
			_bag.dispose();
			_bag.close();
			_bag == null;
		}
	}
}