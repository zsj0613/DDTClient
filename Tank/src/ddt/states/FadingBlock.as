package ddt.states
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import road.loader.LoaderSavingManager;
	import road.ui.manager.TipManager;
	
	import ddt.manager.StateManager;

	public class FadingBlock extends Sprite
	{		
		private var _func:Function;
		private var _life:Number;
		private var _exected:Boolean;
		private var _nextView:BaseStateView;
		private var _showLoading:Function;
		private var _newStart:Boolean;
		private var _showed:Boolean;
		private var _canSave:Boolean;
		
		public function FadingBlock(func:Function,showLoading:Function)
		{
			_func = func;
			_showLoading = showLoading;
			_life = 0;
			_newStart = true;
			_canSave = true;
			graphics.beginFill(0);
			graphics.drawRect(0,0,1008,608);
			graphics.endFill();
		}
		
		public function setNextState(next:BaseStateView):void
		{
			_nextView = next;
			_canSave = StateManager.currentStateType != StateType.LOGIN;
		}
		
		public function update():void
		{
			if(parent == null)
				TipManager.AddToLayerNoClear(this);
			if(_newStart)
			{
				this.alpha = 0;
				_life = 0;
				_exected = false;
				_showed = false;
				addEventListener(Event.ENTER_FRAME,__enterFrame);
			}
			else
			{
				_life = 1;
				alpha = _life;
				_exected = false;
			}
			_newStart = false;
		}
		
		
		public function stopImidily():void
		{
			parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			_newStart = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function set executed(value:Boolean):void
		{
			_exected = value;
		}
		
		private function __enterFrame(event:Event):void
		{
			if(_life < 1)
			{
				_life += 0.16;
				this.alpha = _life;
			}
			else if(_life < 2)
			{
				var tick:int = getTimer();
				if(_canSave)
				{
					LoaderSavingManager.saveFilesToLocal();
				}
				tick = getTimer() -tick;
				var time:Number = (tick / 40) * 0.1;
				_life += time < 0.1 ? 0.1 : time;
				if(_life > 2)
				{
					_life = 2.01;
				}
				if(!_exected)
				{
					_exected = true;
					alpha = 1;
					_func();
				}
			}
			else if(_life > 2)
			{
				_life += 0.16;
				alpha = 3 - _life;
				if(alpha < 0.2)
				{
					if(parent)
					{
						parent.removeChild(this);
					}
					removeEventListener(Event.ENTER_FRAME,__enterFrame);
					_newStart = true;
					dispatchEvent(new Event(Event.COMPLETE));
					_nextView.fadingComplete();
				}
			}
		}
	}
}