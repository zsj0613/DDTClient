package road.ui.controls
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.ui.manager.TipManager;
	
	public class ConfirmTimerDialog extends ConfirmDialog
	{
		private var __timerback:Function;
		private var _times:uint;
		private var _tick:Timer;
		
		public function ConfirmTimerDialog(title:String,msg:String,times:uint,model:Boolean = true,callback:Function = null,cancelback:Function = null,timerback:Function = null,confirmLabel:String = null,cancelLabel:String = null)
		{
			__timerback = timerback;
			_times = times;
			super(title, msg, model, callback, cancelback,confirmLabel,cancelLabel);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_btnOK.label = _confirmLabel + _times;
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
				_btnOK.label = _confirmLabel + _times;
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
		
		public static function show(title:String,msg:String,times:uint,model:Boolean = true,callback:Function = null,cancelback:Function = null,timerback:Function = null,autoClear:Boolean = true,confirmLabel:String = "确定",cancelLabel:String = "取消"):ConfirmTimerDialog
		{
			var dialog:ConfirmTimerDialog = new ConfirmTimerDialog(title,msg,times,model,callback,cancelback,timerback,confirmLabel,cancelLabel);
			if(autoClear)
				TipManager.AddTippanel(dialog,true);
			else
				TipManager.AddToLayerNoClear(dialog,true);
			return dialog;
		}
	}
}