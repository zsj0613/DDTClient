package ddt.consortia.myconsortia.frame
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.StringHelper;
	
	import ddt.data.ConsortiaDutyType;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;

	public class MyConsortiaDeclarationFrame extends HConfirmFrame
	{
		private var _text : TextArea;
		private var _right:Boolean;
		public function MyConsortiaDeclarationFrame()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaDeclarationFrame.titleText");
			//this.titleText = "公会宣言";
			this.okLabel = LanguageMgr.GetTranslation("ok");
			//this.okLabel = "修 改";
			this.cancelLabel = LanguageMgr.GetTranslation("cancel");
			//this.cancelLabel = "关 闭";
			this.moveEnable = false;
			
			this.buttonGape = 60;
			this.setSize(425,245);
			
			_text = new TextArea();
			_text.horizontalScrollPolicy = "off";
			_text.verticalScrollPolicy = "on";
			_text.setStyle("upSkin",new Sprite());
			_text.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0x000000;
			format.leading = 4;
			_text.setStyle("disabledTextFormat",format);
			_text.setStyle("textFormat",format);
			_text.setSize(392,160);
			_text.textField.defaultTextFormat = new TextFormat("Arial",16,0x013465);
			
			
			
			var filterA:Array = [];
			var glowFilter:GlowFilter = new GlowFilter(0xffffff,1,4,4,10);
			filterA.push(glowFilter);
			_text.textField.filters = filterA;
			addChild(_text);
			_text.x = 18;
			_text.y = 35;
			
			_right = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._5_Enounce);
			_text.editable = okBtnEnable = _right;
			
			
			super.removeKeyDown();
			fireEvent = false;
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
						SoundManager.Instance.play("008");//修复1145号bug wicki 09.06.27
						hide();
					}
				}
			}
		}
		
		public function addEvent() : void
		{
		    okFunction = sendDeclar;
			_text.textField.addEventListener(Event.CHANGE,__input);
			_text.textField.addEventListener(TextEvent.TEXT_INPUT,__text);
			_text.textField.addEventListener(Event.ADDED_TO_STAGE,__addToStageHandler);
		}
		public function removeEvent() : void
		{
			okFunction = null;
			_text.textField.removeEventListener(Event.CHANGE,__input);
			_text.textField.removeEventListener(TextEvent.TEXT_INPUT,__text);
			_text.textField.removeEventListener(Event.ADDED_TO_STAGE,__addToStageHandler);
		}
		private function __input(e:Event):void
		{
			StringHelper.checkTextFieldLength(_text.textField,300);
			if(_text.textField.text == _oldMessage)okBtnEnable = false;
			else okBtnEnable = true;
		}
		
		private function __text(e:TextEvent):void
		{
//			SoundManager.instance.play("043");
			StringHelper.checkTextFieldLength(_text.textField,300);
		}
		/* 设置文本光标焦点 */
		private function __addToStageHandler(e:Event):void
		{
			_text.textField.stage.focus = _text.textField;
			_text.textField.text = "";
			_right = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._5_Enounce);
			_text.editable = okBtnEnable = _right;
		}
		private var _oldMessage : String;
		public function set consortiaDeclaration(msg : String) : void
		{
			this._text.textField.text = msg;
			_oldMessage = msg;
			_text.editable = okBtnEnable = _right;
			if(_right)
			{
				if(msg)
				{
					_text.textField.setSelection(msg.length,msg.length);
				}
				if(_text.textField.text == "")
					okBtnEnable = false;
				else 
					okBtnEnable = true;
			}
		}
		private function sendDeclar():void
		{
			var b:ByteArray = new ByteArray();
        	b.writeUTF(StringHelper.trim(_text.textField.text));
        	if(b.length >300)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaDeclarationFrame.long"));
				//MessageTipManager.getInstance().show("当前输入文本过长");
				return;
			}
			if(FilterWordManager.isGotForbiddenWords(_text.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
				return;
			}
			var str:String = FilterWordManager.filterWrod(_text.textField.text);
//			str.replace("\r","");
//			str.replace("\n","");
			str = StringHelper.trim(str);
//			if(str == "")
//			{
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaDeclarationFrame.input"));
//				//MessageTipManager.getInstance().show("请输入公会宣言");
//				return ;
//			}
			SocketManager.Instance.out.sendConsortiaUpdateDescription(str);
			if(this.parent)this.parent.removeChild(this);
		}
		public function get info() : String
		{
			return this._text.textField.text.toString();
		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
	}
}