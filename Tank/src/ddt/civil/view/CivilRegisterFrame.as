package ddt.civil.view
{
	import TankCivil.RegisterAsset;
	
	import ddt.civil.CivilModel;
	
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.StringHelper;
	
	import ddt.data.EquipType;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.events.ShortcutBuyEvent;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.QuickBuyFrame;
	
	public class CivilRegisterFrame extends HConfirmFrame
	{
		private var _register : RegisterAsset;
		private var _checkBox : HCheckBox;
		private var _introduction : String;
		private var _isPublishEquip : Boolean;
		private var _model : CivilModel;
		private var fastPurchaseGoldBox:FastPurchaseGoldBox;
		private var _quick:QuickBuyFrame;
		private var _introductionText : TextArea;
		
		public function CivilRegisterFrame($model:CivilModel)
		{
			super();
			
			this.moveEnable = false;
			
			_model = $model;
			
			setSize(460,400);
			okLabel = LanguageMgr.GetTranslation("ok");
			cancelLabel = LanguageMgr.GetTranslation("cancel");
			buttonGape = 120;
			
			_register = new RegisterAsset();
			_register.name_txt.text = PlayerManager.Instance.Self.NickName;
			_register.marry_txt.text = PlayerManager.Instance.Self.IsMarried?LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.married"):LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.marry");
			//_register.marry_txt.text = PlayerManager.Instance.Self.IsMarried?"已婚":"未婚";
			addChild(_register);
			
			_checkBox = new HCheckBox(LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.checkBox"));
			//_checkBox = new HCheckBox("公开个人装备信息");
			_checkBox.fireAuto = true;
			_checkBox.buttonMode = true;
			_checkBox.x = _register.checkPos.x;
			_checkBox.y = _register.checkPos.y;
			
			_introductionText = new TextArea();
			_introductionText.x = _register.introductionPos.x;
			_introductionText.y = _register.introductionPos.y + 2;
			_introductionText.setStyle("upSkin",new Sprite());
			_introductionText.setStyle("disabledSkin",new Sprite());
			_introductionText.verticalScrollPolicy = "on";
			_introductionText.horizontalScrollPolicy = "off";
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x013465;
			format.leading = 4;
			
			_introductionText.setStyle("disabledTextFormat",format);
			_introductionText.setStyle("textFormat",format);
			_introductionText.setSize(365,135);
			_introductionText.textField.defaultTextFormat = new TextFormat("Arial",14,0x013465);
			
			var filterA:Array = [];
			var glowFilter : GlowFilter = new GlowFilter(0xffffff,1,4,4,10);
			filterA.push(glowFilter);
			_introductionText.textField.filters = filterA;
			addChild(_introductionText);
			_register.introductionPos.visible = false;
			
			addChild(_checkBox);
			_register.checkPos.visible = false;
			
			selfInfo();
			addEvent();
			
			
			
		}
		
		public function addEvent():void
		{
			okFunction = __ok;
			cancelFunction = __cancel;
			this.addEventListener(Event.ADDED_TO_STAGE,initUI);
			PlayerManager.Instance.addEventListener(PlayerManager.CIVIL_SELFINFO_CHANGE,__getSelfInfo);
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_introductionText.textField.addEventListener(TextEvent.TEXT_INPUT,__limit);
		}
		public function removeEvent():void
		{
			okFunction = null;
			cancelFunction = null;
			this.removeEventListener(Event.ADDED_TO_STAGE,initUI);
			PlayerManager.Instance.removeEventListener(PlayerManager.CIVIL_SELFINFO_CHANGE,__getSelfInfo);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__propertyChange);
			_introductionText.textField.removeEventListener(TextEvent.TEXT_INPUT,__limit);
		}
		
		private function initUI(e:Event):void
		{
			
			if(!PlayerManager.Instance.Self.MarryInfoID)
			{
				_register.title.gotoAndStop(1);
				titleText = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.titleText");
				//titleText = "登记信息";
				_checkBox.selected = true;
			}
			else
			{
				_register.title.gotoAndStop(2);
				titleText = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.modify");
				//titleText = "修改信息";
				if(_register.ps.visible)_register.ps.visible = false;
			}
			
			_introductionText.stage.focus = _introductionText;
			_introductionText.setSelection(_introductionText.text.length,_introductionText.text.length);
			SocketManager.Instance.out.sendForMarryInfo(PlayerManager.Instance.Self.MarryInfoID);
		}
		
		private function __ok():void
		{
			if(PlayerManager.Instance.Self.Gold < 10000 && !PlayerManager.Instance.Self.MarryInfoID)
			{
				this.close();
				fastPurchaseGoldBox=new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX);
				fastPurchaseGoldBox.autoDispose=true;
				fastPurchaseGoldBox.okFunction=okFastPurchaseGold;
				fastPurchaseGoldBox.cancelFunction=cancelFastPurchaseGold;
				fastPurchaseGoldBox.closeCallBack=cancelFastPurchaseGold;
				fastPurchaseGoldBox.show();
				return;
			}
			_isPublishEquip = _checkBox.selected;
			//			_introduction = FilterWordManager.filterWrod(_introductionText.text);
			if(FilterWordManager.isGotForbiddenWords(_introductionText.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.checkIntro"));
				return;
			}
			_introduction = _introductionText.text;
			if(!PlayerManager.Instance.Self.MarryInfoID)
			{
				SocketManager.Instance.out.sendRegisterInfo(PlayerManager.Instance.Self.ID,_isPublishEquip,_introduction);
			}
			else
			{
				SocketManager.Instance.out.sendModifyInfo(_isPublishEquip,_introduction);
			}
			_model.updateBtn();
			selfInfo();
			
			if(parent)parent.removeChild(this);
			
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
		
		private function __cancel():void
		{
			selfInfo();
			
			if(parent)parent.removeChild(this);
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				if(cancelBtn.enable)
				{
					if(cancelFunction != null)
					{
						cancelFunction();
					}else
					{
						super.dispose();
					}
				}
			}
		}
		
		
		override protected function __closeClick(e:MouseEvent):void
		{
			__cancel();
			SoundManager.Instance.play("008");
		}
		
		private function __getSelfInfo(e:Event):void
		{
			selfInfo();
		}
		private function selfInfo():void
		{
			if(PlayerManager.Instance.Self.MarryInfoID != 0)
			{
				_checkBox.selected = PlayerManager.Instance.Self.IsPublishEquit;
				_introductionText.text = PlayerManager.Instance.Self.Introduction;
			}else
			{
				_checkBox.selected = true;
				_introductionText.text = LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.text");
				//_introductionText.text = "很期待和你做朋友，快来和我联系吧！";
			}
			
		}
		
		private function __propertyChange(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["IsPublishEquit"])
			{
				_checkBox.selected = PlayerManager.Instance.Self.IsPublishEquit;
			}
			else if(evt.changedProperties["Introduction"])
			{
				_introductionText.text = PlayerManager.Instance.Self.Introduction;
			}
		}
		
		private function __limit(e:TextEvent):void
		{
			StringHelper.checkTextFieldLength(_introductionText.textField,300);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			_model.dispose();
			_model = null;
			if(parent)parent.removeChild(this);
		}
	}
}