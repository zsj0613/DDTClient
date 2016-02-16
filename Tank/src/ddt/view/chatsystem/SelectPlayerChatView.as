package ddt.view.chatsystem
{
	import fl.controls.ComboBox;
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;

	public class SelectPlayerChatView extends HConfirmFrame
	{
		private var _label:TextField;
		private var _combo:ComboBox;
		
		public function SelectPlayerChatView()
		{
			super();
			okFunction = __okbtnClick;
			cancelFunction = __cancelbtnClick;
			closeCallBack=__cancelbtnClick;
			addEventListener(Event.REMOVED_FROM_STAGE,__onRemoveFromStage);
			showCancel = true;
			alphaGound = true;
			blackGound = false;
			fireEvent = false;
			
			setContentSize(290,100);
			
			titleText = LanguageMgr.GetTranslation("ddt.view.scenechatII.PrivateChatIIView.privatename");
			//titleText = "私聊";
			_label = new TextField();
			_label.text = LanguageMgr.GetTranslation("ddt.view.scenechatII.PrivateChatIIView.nick");
			//_label.text = "玩家昵称";
			var t:TextFormat = new TextFormat(LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font"),14,0x2C1525);
			_label.setTextFormat(t);
			_label.x = 20;
			_label.y = 20;
			_label.selectable = false;
			addContent(_label);
			
			
			_combo = new ComboBox();
			_combo.setSize(140,22);
			_combo.move(_label.x+_label.width-5,18);
			_combo.editable = true;
			_combo.textField.maxChars = 15;
			_combo.textField.setStyle("textFormat",new TextFormat(null,12));
			_combo.dropdown.setRendererStyle("textFormat",new TextFormat(null,12));
			_combo.textField.addEventListener(ComponentEvent.ENTER,__okbtnClick);
			for each(var i:PlayerInfo in PlayerManager.Instance.friendList)
			{
				_combo.addItem({label:i.NickName,id:i.ID});
			}
			addContent(_combo);
			initEvent();
			
		}

		
		private function initEvent():void
		{
			_combo.addEventListener(Event.CHANGE,__comboChange);
			_combo.textField.addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
		}
		private function __onRemoveFromStage(e:Event):void
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE,__onRemoveFromStage);
			if(ChatManager.Instance.input.inputField.privateChatName == "")
			{
				ChatManager.Instance.setFocus();
				ChatManager.Instance.inputChannel=ChatInputView.CURRENT;
			}
			if(_combo)
			{
				_combo.textField.removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
				_combo.textField.removeEventListener(ComponentEvent.ENTER,__okbtnClick);
				_combo.removeEventListener(Event.CHANGE,__comboChange);
				_combo.close();
			}
		}
		private function __comboChange(evt:Event):void
		{
			if(_combo.selectedIndex != -1)
			{
				_combo.text = _combo.selectedItem["label"];
			}
		}
		
		private function __okbtnClick(evt:ComponentEvent = null):void
		{
			if(_combo.text != "")
			{
				if(_combo.selectedItem)
				{
					ChatManager.Instance.privateChatTo(_combo.text,_combo.selectedItem["id"]);
				}else
				{
					ChatManager.Instance.privateChatTo(_combo.text);
				}
			}else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.chat.SelectPlayerChatView.name"));
				return;
			}
				
			dispose();
			if(evt)
			{
				evt.stopImmediatePropagation();
			}
		}
		
		private function __cancelbtnClick():void
		{
			ChatManager.Instance.setFocus();
			ChatManager.Instance.inputChannel=ChatInputView.CURRENT;
			dispose();
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
			if(stage) 
			{
				_combo.textField.setFocus();
			}
			_combo.textField.addEventListener(ComponentEvent.ENTER,__okbtnClick);
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				if(cancelBtn.enable)
				{
					SoundManager.Instance.play("008");
					if(cancelFunction != null)
					{
						cancelFunction();
					}else
					{
						hide();
					}
				}
			}
		}
		
		
		override public function dispose():void
		{
			if(_combo)
			{
				_combo.textField.removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDownd);
				_combo.textField.removeEventListener(ComponentEvent.ENTER,__okbtnClick);
				_combo.removeEventListener(Event.CHANGE,__comboChange);
			}
			//_combo = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			super.dispose();
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}