package ddt.view.bossbox
{
	import fl.motion.easing.Elastic;
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.game.movement.BossBoxAsset;
	
	public class BossBoxView extends BossBoxAsset
	{
		//private var _box:BossBoxAsset;
		public var _jiangli:AwardsView;
		
		private var _templateIds:Array;
		
		public var boxType:int = 0;
		
		public var boxID:int;
		
		private var _time:Timer;
		
		public static const CLOSEBOX:String = "closeBox";
		
		public function BossBoxView(t:int , id:int , itemArr:Array)
		{
			super();
			buttonMode = true;
			_templateIds = itemArr;
			boxType = t;
			boxID = id;
			init();
			initEvent();
		}
		
		private function init():void
		{
			SoundManager.instance.pauseMusic();
			SoundManager.instance.play("1001");
			setTimeout(startMusic,3000);
		}
		
		private function startMusic():void
		{
			SoundManager.instance.resumeMusic();
			SoundManager.instance.stop("1001");
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.CLICK , _boxClick);
		}
		
		private function _boxClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			downBossBox.gotoAndPlay("openBox");
			
			removeEvent();
			
			_time = new Timer(500,1);
			_time.start();
			_time.addEventListener(TimerEvent.TIMER_COMPLETE, _time_complete);
			
			
		}
		
		private function _time_complete(e:TimerEvent):void
		{
			_jiangli = new AwardsView(boxType,_templateIds);
			_jiangli.show();
			_jiangli.addEventListener(AwardsView.HAVEBTNCLICK ,_close);
			
			
			removeChild(downBossBox);
			
			_time.removeEventListener(TimerEvent.TIMER_COMPLETE, _time_complete);
			_time.stop();
			_time = null;
			
			TipManager.RemoveTippanel(this);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK , _boxClick);
		}
		
		private function _close(e:Event):void
		{
			this.dispatchEvent(new Event(BossBoxView.CLOSEBOX));
		}
		
		public function dispose():void
		{
			if(_jiangli)
			{
				_jiangli.removeEventListener(AwardsView.HAVEBTNCLICK,_close);
				_jiangli.dispose();
				_jiangli.close();
				_jiangli = null;
			}
		}
	
	}
}








