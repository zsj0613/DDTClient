package ddt.view.common.church
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HCheckBox;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import tank.church.ProposeAsset;
	import ddt.data.player.BagInfo;
	import ddt.manager.FilterWordManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	/**
	 * 求婚 
	 * @author Administrator
	 * 
	 */	
	public class ProposeFrame extends HConfirmFrame
	{
		private var _bg:ProposeAsset;
		
		private var _checkBox:HCheckBox;
		private var _ta:TextArea;
		
		private var spouseID:int;
		private var useBugle:Boolean;
		
		public function ProposeFrame(id:int)
		{
			super();
			super.removeKeyDown();
			
			this.spouseID = id;
			
			showBottom = true;
			showClose = true;
			buttonGape = 100;
			moveEnable = false;
			
			setContentSize(310,179);
			
			setSize(450,425);
			
			init();
			addEvent();
		}

		private function init():void
		{
			_bg = new ProposeAsset();

			addContent(_bg,true);
			
			_bg.check_mc.y = -2;
			_checkBox = new HCheckBox("",_bg.check_mc);
			_checkBox.fireAuto = true;
			_checkBox.buttonMode = true;
			_checkBox.x = _bg.check_pos.x;
			_checkBox.y = _bg.check_pos.y;
			_checkBox.selected = true;
			_bg.addChild(_checkBox);
			_bg.check_pos.visible = false;
			
			_ta = new TextArea();
			_ta.maxChars = 300;
			_ta.setStyle("upSkin",new Sprite());
			_ta.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x013465;
			format.leading = 4;
			_ta.setStyle("disabledTextFormat",format);
			_ta.setStyle("textFormat",format);
			_ta.setSize(_bg.txt_pos.width,_bg.txt_pos.height);
			_ta.textField.defaultTextFormat = new TextFormat("Arial",14,0x013465);
			_ta.x = _bg.txt_pos.x;
			_ta.y = _bg.txt_pos.y;
			_bg.addChild(_ta);
			
			_bg.txt_pos.visible = false;
			
			useBugle = _checkBox.selected;
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
						super.hide();
					}
				}
			}
		}
		
		private function addEvent():void
		{
			cancelFunction =__cancel; 
			okFunction =__confirm;
			_checkBox.addEventListener(Event.CHANGE,__checkClick);
			_checkBox.addEventListener(MouseEvent.CLICK,getFocus);
			_ta.textField.addEventListener(Event.ADDED_TO_STAGE,__addToStages);
			_ta.textField.addEventListener(Event.CHANGE,__input);
		}
		private function removeEvent():void
		{
			cancelFunction = null; 
			okFunction = null;
			_checkBox.removeEventListener(Event.CHANGE,__checkClick);
			_checkBox.removeEventListener(MouseEvent.CLICK,getFocus);
			_ta.textField.removeEventListener(Event.ADDED_TO_STAGE,__addToStages);
			_ta.textField.removeEventListener(Event.CHANGE,__input);
		}
		private function __checkClick(event:Event):void
		{
			useBugle = _checkBox.selected;
		}
		
		private function getFocus(evt:MouseEvent):void
		{
			if(stage)
			{
				stage.focus = this;
			}
		}
		
		private function __addToStages(e:Event):void
		{
			_ta.stage.focus = _ta;
			_ta.text = "";
		}
		private function __input(e:Event):void
		{

			var inputCharacter:int = _ta.textField.length;
			_bg.txtCount.text = String(300 - inputCharacter);
		}

		private function __confirm():void
		{
//			if(!PlayerManager.Instance.Self.Bag.findFistItemByTemplateId(11103))
			if(!PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).findFistItemByTemplateId(11103))
			{
				var str : String = FilterWordManager.filterWrod(_ta.text);
				var buyRingFrame:BuyRingFrame = new BuyRingFrame(spouseID,str,useBugle);
				TipManager.AddToLayerNoClear(buyRingFrame,true);
				
				super.hide();
				return;
			}

			sendPropose();
		}
		
		private function sendPropose():void
		{
			var str : String = FilterWordManager.filterWrod(_ta.text);
			SocketManager.Instance.out.sendPropose(spouseID,str,useBugle);
			super.hide();
		}
		
		private function __cancel():void
		{
			super.hide();
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(parent)parent.removeChild(this);
		}
	}
}