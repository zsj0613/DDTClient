package ddt.view.bossbox
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.TipBgAccect;
	
	import tank.game.movement.SmallBoxButtonAsset;
	import tank.game.movement.TipTextAsset;
	import ddt.view.bagII.TipColorBlock;
	
	public class SmallBoxButton extends SmallBoxButtonAsset
	{
		private var _hour:int = 0;
		private var _minute:int = 0;
		private var _second:int = 0;
		private var _timeSum:int = 0;
		private var _tipContainer:Sprite;
		
		public static const SMALLBOXBUTTON_CLICK:String = "smallBoxButton_click";
		public static const showTypeWait:int = 1;
		public static const showTypeCountDown:int = 2;
		public static const showTypeOpenbox:int = 3;
		
		public function SmallBoxButton()
		{
			addEvent();
			
			_openBox.visible = false;
			_boxDelayTimeText.visible = false;
			_boxDelayTimeText.mouseEnabled = false;
		}
		
		private function createTip():void
		{
			_tipContainer = new Sprite();
			
			var tipBg:TipBgAccect = new TipBgAccect();
			tipBg.scale9Grid = new Rectangle(8,8,44,10);
			_tipContainer.addChild(tipBg);
			
			var tipTextField:TipTextAsset = new TipTextAsset();
			tipTextField.x = 8;
			tipTextField.y = 8;
			tipBg.scaleX = 2.3;
			tipBg.scaleY = 2;
			_tipContainer.addChild(tipTextField);
						
			_tipContainer.mouseChildren = false;
			_tipContainer.mouseEnabled = false;
		}
		
		public function gotoOpenBox():void
		{
			_closeBox.visible = false;
			_openBox.visible = true;
			_boxDelayTimeText.visible = false;	
			
			
		}
		
		public function updateTime(second:int):void
		{
			_timeSum = second;
			_minute = _timeSum/60;
			_second = _timeSum%60;
			
			var str:String = "";

			if(_minute < 10)
				str += "0" + _minute + "分";
			else
				str += _minute + "分";
			
			if(_second < 10)
				str += "0" + _second;
			else
				str += _second;
			
			str += "秒";
			
			_boxDelayTimeText.text = str;
		}
		
		public function set timeSum(sum:int):void
		{
		}
		
		public function showType(value:int):void
		{
			switch(value)
			{
				case SmallBoxButton.showTypeWait:
					_closeBox.visible = true;
					_openBox.visible = false;
					_boxDelayTimeText.visible = false;
					break;
				case SmallBoxButton.showTypeCountDown:
					_closeBox.visible = true;
					_openBox.visible = false;
					_boxDelayTimeText.visible = true;
					break;
				case SmallBoxButton.showTypeOpenbox:
					gotoOpenBox();
					break;
				default:
					break;
			}
		}
		
		private function _click(e:Event):void
		{
			SoundManager.instance.play("008");
			dispatchEvent(new Event(SmallBoxButton.SMALLBOXBUTTON_CLICK));
		}
		
		private function _onMouseOver(e:MouseEvent):void
		{
			createTip();
			addChild(_tipContainer);
			updatePosition();
		}
		
		private function _onMouseOut(e:MouseEvent):void
		{
			if(_tipContainer.parent)
			{
				_tipContainer.parent.removeChild(_tipContainer);
			}
			_tipContainer = null;
		}
		
		private function updatePosition():void
		{
			_tipContainer.x = 0;
			_tipContainer.y =  -_tipContainer.height;
			
			if(y < 100)
			{
				_tipContainer.y = _closeBox.height - 15;
			}
			if(x > 900)
			{
				_tipContainer.x = - _tipContainer.width + _closeBox.width;
			}
		}
		
		private function addEvent():void
		{
			_openBox.buttonMode = true;
			_openBox.addEventListener(MouseEvent.CLICK , _click);
			_closeBox.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			_closeBox.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		}
		
		private function removeEvent():void
		{
			_openBox.removeEventListener(MouseEvent.CLICK , _click);
			_closeBox.removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			_closeBox.removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}