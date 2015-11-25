package ddt.church.churchScene
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class SwitchMovie extends Sprite
	{
		public static const SWITCH_COMPLETE:String = "switch complete";
		
		private const SHOW:String = "mask show";
		private const HIDE:String = "mask hide";
		
		private var _currentStatus:String; 
		private var _sprite:Sprite;
		
		private var _autoClear:Boolean;
		private var _speed:Number;	
		
		public function SwitchMovie(autoClear:Boolean,speed:Number = 0.02)
		{
			this._autoClear = autoClear;
			this._speed = speed;
			
			init();
		}
		
		private function init():void
		{
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0x000000);
			_sprite.graphics.drawRect(-1000,-1000,3000,2600);
			_sprite.graphics.endFill();
			_sprite.alpha = 0;
			
			addChild(_sprite);
			
			_currentStatus = this.SHOW;
		}
		
		public function playMovie():void
		{
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function __enterFrame(event:Event):void
		{
			if(_currentStatus == this.SHOW)
			{
				_sprite.alpha +=_speed;
				
				if(_sprite.alpha>=1)
				{
					_currentStatus = this.HIDE;
					
					dispatchEvent(new Event(SwitchMovie.SWITCH_COMPLETE));
				}
			}else if(_currentStatus == this.HIDE)
			{
				_sprite.alpha -=_speed;
				
				if(_sprite.alpha<=0)
				{
					_currentStatus = this.SHOW;
					removeEventListener(Event.ENTER_FRAME,__enterFrame);
					if(_autoClear)
					{
						dispose();
					}
				}
			}
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			if(parent)parent.removeChild(this);
		}
	}
}