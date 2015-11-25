package ddt.view.roulette
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	public class RouletteButton extends Sprite
	{
		private var _view:MovieClip;
		private var _enable:Boolean;
		
		public function RouletteButton(movie:MovieClip)
		{
			_view = movie;
			this.x = movie.x;
			this.y = movie.y;
			_view.x = 0;
			_view.y = 0;
			this.buttonMode = true;
			movie.parent.removeChild(movie);
			addChild(_view);
			_view.gotoAndStop(1);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_view.addEventListener(MouseEvent.MOUSE_OVER , _over);
			_view.addEventListener(MouseEvent.MOUSE_OUT , _out);
			_view.addEventListener(MouseEvent.MOUSE_DOWN , _down);
			_view.addEventListener(MouseEvent.MOUSE_UP , _up);
		}
		
		private function _over(e:MouseEvent):void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1.3, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, 1.3, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, 1.3, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			var color:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			_view.filters = [color];
		}
		
		private function _out(e:MouseEvent):void
		{
			_view.filters = [];
			_view.gotoAndStop(1);
		}
		
		private function _down(e:MouseEvent):void
		{
			_view.gotoAndStop(2);
		}
		
		private function _up(e:MouseEvent):void
		{
			_view.gotoAndStop(1);
		}
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
			this.mouseEnabled = _enable;
			this.mouseChildren = _enable;
			if(!_enable)
			{
				var matrix:Array = new Array();
				matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // red
				matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // green
				matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // blue
				matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
				var color:ColorMatrixFilter = new ColorMatrixFilter(matrix);
				this.filters = [color];
			}
			else
			{
				this.filters = [];
			}
		}
		
		public function dispose():void
		{
			_view.removeEventListener(MouseEvent.MOUSE_OVER , _over);
			_view.removeEventListener(MouseEvent.MOUSE_OUT , _out);
			_view.removeEventListener(MouseEvent.MOUSE_DOWN , _down);
			_view.removeEventListener(MouseEvent.MOUSE_UP , _up);
			_view = null;
		}
	}
}

















