package ddt.church.churchScene.fire
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	import road.utils.ClassUtils;
	
	import tank.church.fireAcect.*;
	public class FireEffectItem extends Sprite
	{
		private var _id:String;
		private var _fire:MovieClip;
		public var owerID:int;
		private var count : int = 0;
		private var myTimer:Timer;
		public function FireEffectItem(id:int)
		{
			_id = id.toString();
			creatFire();
			super();
		}
		private function creatFire():void
		{
			var effClass:Object = ClassUtils.getDefinition("ddt.church.fireAcect.FireItemAccect"+_id.substr(3,2));
			if(effClass != null)
			{
				_fire = new effClass() as MovieClip;
				addChild(_fire);
			}
		}
	
		public function fire(playSound:Boolean = true):void
		{
			if(playSound)
			{
				SoundManager.Instance.play("117");
			}
			
			if(_fire)
			{
				_fire.gotoAndPlay(1);
				_fire.addEventListener(Event.ENTER_FRAME,enterFrameHander);	
				count = 0;
				myTimer = new Timer(3500,0);
				myTimer.start();
				myTimer.addEventListener(TimerEvent.TIMER , __timer);
			}else
			{
				die();
			}
		}
		
		public function die():void
		{
			
			if(_fire)
			{
				_fire.removeEventListener(Event.ENTER_FRAME,enterFrameHander);
				_fire = null;
			}
			if(parent)
			{	
				parent.removeChild(this);
			}
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
		private function __timer(evt:TimerEvent):void
		{
			if(myTimer)
			{
				myTimer.removeEventListener(TimerEvent.TIMER , __timer);
				myTimer.stop();
				myTimer = null;
			}
			die();
		}
		
		private function enterFrameHander(e:Event):void
		{
			count ++;
//			if(_fire.currentFrame == _fire.totalFrames)
			if(count == _fire.totalFrames)
			{
				die();
				count = int.MAX_VALUE;
			}
		}
		
		public function dispose() : void
		{
			if(_fire)
			{
				_fire.removeEventListener(Event.ENTER_FRAME,enterFrameHander);
				_fire = null;
			}
			if(this.parent)this.parent.removeChild(this);
		}
	}
}