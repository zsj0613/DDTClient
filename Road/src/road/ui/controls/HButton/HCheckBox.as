package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.accect.CheckUIAccect;

	public class HCheckBox extends Sprite
	{
		private var _label:String = "";
		private var _displayText:DisplayObject;
		private var _displayCheck:MovieClip;
		private var _textField:TextField;
		private var _select:Boolean;
		private var _enable:Boolean = true;
		private var myColorMatrix_filter:ColorMatrixFilter;
		private var _lableGape:Number;
		private var _fireAuto:Boolean = false;
		private var _tipString:String;
		
		private var tipSprite:Sprite;
		private var _tipField:TextField;
		public function HCheckBox(label:String = "checkBox",displayText:DisplayObject = null,displayCheck:MovieClip = null)
		{
			buttonMode = true;
			_label = label;
			_displayText = displayText;
			_displayCheck = displayCheck;
			
			if(_displayCheck == null)
			{
				_displayCheck = new CheckUIAccect();
			}
			addChild(_displayCheck);
			_displayCheck.gotoAndStop(1);
			if(_displayText == null)
			{
				_textField = creatTextField();
				_textField.text = _label;
				_textField.setTextFormat(new TextFormat(null,12,0xffffff));
				_textField.filters = [new GlowFilter(0x000000,1,2,2,10)];
				addChild(_textField);
			}else
			{
				addChild(_displayText);
			}
			super();
			tipSprite = new Sprite();
			_tipField = creatTextField();
			_tipField.defaultTextFormat = new TextFormat(null,12,0xffffff);
			_tipField.filters = [new GlowFilter(0x000000,1,3,3,10)];
			tipSprite.addChild(_tipField);
			tipSprite.visible = false;
			addEventListener(MouseEvent.CLICK,onClick);
			addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			labelGape = 10;
			drawRect();
			
			addChild(tipSprite);
			
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
		}
		
		public function set tips(t:String):void
		{
			_tipString = t;
			_tipField.text = _tipString;
			tipSprite.graphics.clear();
			tipSprite.graphics.beginFill(0x000000,0.5);
			tipSprite.graphics.drawRoundRect(-3,-3,_tipField.width+6,_tipField.height+6,3,3);
			postion();
		}
		
		private function drawRect():void
		{
			if(tipSprite.parent)removeChild(tipSprite);
			graphics.clear();
			graphics.beginFill(0xff00ff,0);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function get tipField():TextField
		{
			return _tipField;
		}
		
		
		
		
		public function set labelGape(n:Number):void
		{
			_lableGape = n;
			postion();
			drawRect();
		}
		
		public function postion():void
		{
			if(_displayText)
			{
				_displayText.x=_displayCheck.x+_displayCheck.width+_lableGape;
			}
			if(_textField)
			{
				_textField.x = _displayCheck.x+_displayCheck.width+_lableGape;
				_textField.y = (_displayCheck.height - _textField.height)/2;
			}
			
			
			tipSprite.x = (width - tipSprite.width)/2;
			tipSprite.y = -tipSprite.height-5;
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			if(_tipString != "")
			{
				tipSprite.visible = true;
				addChild(tipSprite);
			}	
			if(_select)
			{
				_displayCheck.gotoAndStop(4);
			}else
			{
				_displayCheck.gotoAndStop(2);
			}
			
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			tipSprite.visible = false;
			if(_select)
			{
				_displayCheck.gotoAndStop(3);
			}else
			{
				_displayCheck.gotoAndStop(1);
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(!enable)
			{
				e.stopImmediatePropagation();
			}else
			{
				SoundManager.instance.play("008");
				if(_fireAuto)
				{
					selected = !selected;
					if(_select)
					{
						_displayCheck.gotoAndStop(4);
					}else
					{
						_displayCheck.gotoAndStop(2);
					}
				}
			}
		}
		
		public function set textFormat (tf:TextFormat):void
		{
			_textField.setTextFormat(tf);
		}
		
		public function set textFilter(filter:Array):void
		{
			_textField.filters = filter;
		}
		
		public function set selected (b:Boolean):void
		{
			if(_select != b)
			{
				_select = b;

				dispatchEvent(new Event(Event.CHANGE));
			}
			_select = b;
			if(_select)
			{
				_displayCheck.gotoAndStop(3);
			}else
			{
				_displayCheck.gotoAndStop(1);
			}
		}
		
		public function set enable(b:Boolean):void
		{
			_enable = b;
			buttonMode = _enable;
			if(b)
			{
				filters = null;
			}else
			{
				filters = [myColorMatrix_filter];
			}
		}
		
		public function set fireAuto(b:Boolean):void
		{
			_fireAuto = b;
		}
		
		public function get fireAuto():Boolean
		{
			return _fireAuto;
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function get selected():Boolean
		{
			return _select;
		}
		
		private function creatTextField():TextField
		{
			var  _t:TextField = new TextField();
			_t.autoSize = "left";
			_t.selectable = false;
			_t.mouseEnabled = false;
			return _t;
		}
		
		private function setUpGrayFilter():void {
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.CLICK,onClick);
			removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
			_displayText = null;
			_displayCheck = null;
			_textField = null;
			myColorMatrix_filter = null;
		}
		
	}
}