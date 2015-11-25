package ddt.view.setview
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.crazyTank.view.setting.SliderAsset;
	
	import ddt.utils.ComponentHelperII;
	import ddt.utils.Helpers;
	
	public class Slider extends SliderAsset
	{
		private var _maximum:Number=100;
		private var _minimum:Number=0;
		
		private var _value:Number=0;
		
		private var _bg_click:Sprite;
		
		private var _greyArea:Sprite;
		
		public function Slider()
		{
			super();
			init();
		}
		private function init():void
		{
			thumb.x=min_pos.x
			thumb.y=min_pos.y;
			thumb.buttonMode=true;
			
			
			
			Helpers.hidePosMc(this);
			
			Helpers.registExtendMouseEvent(thumb);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN,__thumbMouseDown);
			thumb.addEventListener(Helpers.STAGE_UP_EVENT,__thumbUp);
			thumb.addEventListener(Helpers.MOUSE_DOWN_AND_DRAGING_EVENT,__dragMove);
			
			
			
			initBackClickArea();
			
			updateValue()
		}
		private function initBackClickArea():void
		{
			_bg_click=new Sprite;
			_bg_click.graphics.beginFill(0xffffff,0);
			_bg_click.graphics.drawRect(0,0,max_pos.x-min_pos.x,10);
			_bg_click.graphics.endFill();
			_bg_click.buttonMode=true;
			
			_leftGreyArea = new Sprite()
			addChild(_leftGreyArea)
			_leftGreyArea.buttonMode=false;
			
			_greyArea = new Sprite()
			addChild(_greyArea)
			_greyArea.buttonMode=false;
			
			
			addChild(_bg_click)
			//swapChildren(thumb,_bg_click)
			setChildIndex(_bg_click, numChildren - 1)
			setChildIndex(thumb,numChildren - 1)
			
			
			_bg_click.x=min_pos.x;
			_bg_click.y=min_pos.y-_bg_click.height/2;
			
			_bg_click.addEventListener(MouseEvent.MOUSE_DOWN,__bgClick);
		}
		private function __bgClick(e:MouseEvent):void
		{
			thumb.x=globalToLocal(_bg_click.localToGlobal(new Point(e.localX,0))).x;
			updateValue();
		}
		private function __thumbMouseDown(e:Event):void
		{
			thumb.startDrag(false,new Rectangle(min_pos.x+1,min_pos.y+1,max_pos.x-min_pos.x,0));
		}
		private function __dragMove(e:Event):void
		{
			updateValue();
		}
		private function __thumbUp(e:Event):void
		{
			thumb.stopDrag();
		}
		
		private function updateGreyArea():void
		{

			_greyArea.graphics.clear()
			_greyArea.graphics.beginFill(0,0.7);
			_greyArea.graphics.drawRoundRect(0,0,max_pos.x-thumb.x+max_pos.width,15,10,10);
			_greyArea.graphics.endFill();
			

			_greyArea.x = thumb.x;
			_greyArea.y = min_pos.y - _bg_click.height/2 - 3;
				
		}
		
		private var _leftGreyArea:Sprite
		
		public function showGreyAreaFull():void{
			_leftGreyArea.graphics.clear()
			_leftGreyArea.graphics.beginFill(0,0.7);
			_leftGreyArea.graphics.drawRoundRect(0,0,thumb.x-min_pos.x,15,10,10);
			_leftGreyArea.graphics.endFill();
			
			_leftGreyArea.x = min_pos.x - 3;
			_leftGreyArea.y = min_pos.y - _bg_click.height/2 - 3;
		}
		
		public function hideGreyArea():void{
			_leftGreyArea.graphics.clear()
		}
		
		public function unableUseGrey():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			this.filters = [new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0])];
		}
		
		public function ableUseGrey():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
			
			this.filters = [];
		}
		
		private function updateValue():void
		{
			var old:Number = _value;
			_value=(thumb.x-min_pos.x)/(max_pos.x-min_pos.x)*(maximum-minimum)+minimum;
			if(old != value)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			updateGreyArea()
		}
		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value;
			thumb.x = (value-minimum)/(maximum-minimum)*(max_pos.x-min_pos.x)+min_pos.x;
			updateGreyArea()
		}

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set maximum(value:Number):void
		{
			_maximum = value;
		}

		public function get minimum():Number
		{
			return _minimum;
		}

		public function set minimum(value:Number):void
		{
			_minimum = value;
		}


	}
}