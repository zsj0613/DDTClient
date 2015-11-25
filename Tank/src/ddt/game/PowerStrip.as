package ddt.game
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import game.crazyTank.view.common.powerStripAssetII;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.game.LocalPlayer;
	import ddt.manager.LanguageMgr;

	public class PowerStrip extends powerStripAssetII
	{
		private var _tip:ToolStripTip;
		private var _self:LocalPlayer;
		private var _timer:Timer;
		public function PowerStrip(self:LocalPlayer)
		{
			super();
			_self = self;
			_glint.visible = false;
			_timer = new Timer(400,1);
			_timer.stop();
			initEvents();
			_tip = new ToolStripTip();
			_tip.content = LanguageMgr.GetTranslation("ddt.game.PowerStrip.tip");
		}
		
		/**
		 *当体力改变时,改变体力条的显示 
		 * @param frame gotoAndStop()的帧数
		 * 
		 */		
		public function changePower(frame:int):void
		{
			var i:int = 100 - frame;
			gotoAndStop(i);
			if(i == 0)
			{
				_glint.visible = true;
				_timer.reset();
				_timer.start();
			}
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE , _timerComplete);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
			removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE , _timerComplete);
		}
		
		private function _timerComplete(evt:TimerEvent):void
		{
			_glint.visible = false;
		}
		
		private function __showTip(evt:MouseEvent):void
		{
			_tip.titleTxt.defaultTextFormat = _tip.totalTxt.defaultTextFormat = new TextFormat("Arial",13,0xffffff,true);
			_tip.currentTxt.defaultTextFormat = new TextFormat("Arial",13,0xd2ff00,true);
			_tip.title = LanguageMgr.GetTranslation("ddt.game.PowerStrip.energy");
			_tip.currentTxt.text = String(_self.energy);
			_tip.currentTxt.filters = [new GlowFilter(0x009904)]
			_tip.totalTxt.text = "/"+_self.maxEnergy;
			TipManager.setCurrentTarget(this,_tip);
		}
		
		private function __hideTip(evt:MouseEvent):void
		{
			TipManager.setCurrentTarget(null,_tip);
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_tip && _tip.parent)_tip.parent.removeChild(_tip);
			_tip = null;
			if(_timer)
			{
				_timer.stop();
				_timer = null;
			}
			if(parent) parent.removeChild(this);
		}
		
	}
}