package ddt.view.common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.manager.SoundManager;

	public class ShineObject extends Sprite
	{
		private var _shiner:MovieClip
		private var _addToBottom:Boolean;
		public function ShineObject(shiner:MovieClip,addToBottom:Boolean = true)
		{
			_shiner = shiner;
			_addToBottom = addToBottom;
			super();
			init();
			initEvents();
		}
		
		private function init():void
		{
			addChild(_shiner);
			_shiner.stop();
		}
		
		private function initEvents():void
		{
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function removeEvents():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function __addToStage(evt:Event):void
		{
			if(parent)
			{
				this.scaleX=1/parent.scaleX;
				this.scaleY=1/parent.scaleY;
				this._shiner.x = (parent.width*parent.scaleX - this._shiner.width)*0.5;
				this._shiner.y = (parent.height*parent.scaleY - this._shiner.height)*0.5;
				if(_addToBottom)
				{
					parent.addChildAt(this,0);
				}
			}
		}
		
		public function shine(playSound:Boolean = false):void
		{
			if(_shiner)
			{
				if(!SoundManager.instance.isPlaying("044")&&playSound)
				{
					SoundManager.instance.play("044",false,true,100);
				}
				_shiner.play();
			}
		}
		
		public function stopShine():void
		{
			if(_shiner)
			{
				SoundManager.instance.stop("044");
				_shiner.gotoAndStop(1);
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_shiner)
			{
				_shiner.stop();
			} 
			if(parent)
			{
				parent.removeChild(this);
			}
			_shiner = null;
		}
		
	}
}