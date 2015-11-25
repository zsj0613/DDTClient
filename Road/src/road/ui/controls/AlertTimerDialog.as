package road.ui.controls
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.ui.manager.TipManager;
	
	public class AlertTimerDialog extends AlertDialog
	{
		private var _times:uint;
		private var _tick:Timer;
		protected var __timerback:Function;
		
		public function AlertTimerDialog(title:String, msg:String, timers:uint, model:Boolean=true,callback:Function = null,timerback:Function = null,confirmLabel:String = null)
		{
			_times = timers;
			__timerback = timerback;
			super(title, msg, model,callback,confirmLabel);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_btnOk.label = _confirmLabel + _times;
			_tick = new Timer(1000,_times);
			_tick.addEventListener(TimerEvent.TIMER,__tickTimer,false,0,true);
			_tick.addEventListener(TimerEvent.TIMER_COMPLETE,__tickComplete,false,0,true);
			_tick.start();
		}
		
		private function __tickTimer(evt:TimerEvent):void
		{
			_times --;
			if(_times >= 0)
			{
				_btnOk.label = _confirmLabel + _times;
			}
		}
		
		private function __tickComplete(evt:TimerEvent):void
		{
			if(__timerback != null)
			{
				__timerback();
			}
			doClosing();
		}
		
		override protected function doClosing():void
		{
			_tick.stop();
			_tick.removeEventListener(TimerEvent.TIMER,__tickTimer);
			_tick.removeEventListener(TimerEvent.TIMER_COMPLETE,__tickComplete);
			super.doClosing();
		} 
		
		public static function show(title:String,msg:String,times:uint,model:Boolean = true,callback:Function = null,timerback:Function = null,autoClear:Boolean = true,confirmLabel:String = null):AlertTimerDialog
		{
			var dialog:AlertTimerDialog = new AlertTimerDialog(title,msg,times,model,callback,timerback,confirmLabel);
			if(autoClear)
				TipManager.AddTippanel(dialog,true);
			else
				TipManager.AddToLayerNoClear(dialog,true);
			return dialog;
		}
	}
}