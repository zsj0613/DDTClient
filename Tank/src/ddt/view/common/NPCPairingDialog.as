package ddt.view.common
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;
	import ddt.manager.SocketManager;
	import tank.view.common.NPCPairingAsset;
	
	public class NPCPairingDialog extends HConfirmFrame
	{
		private var _timer:Timer;
		private const DISPLAY_TIME:int = 20;/** 倒数时间，单位是秒 */
		private var _asset:NPCPairingAsset;
		public function NPCPairingDialog()
		{
			super();
			this.moveEnable = false;
			this.fireEvent = false;
			this.showBottom = true;
			this.showClose = true;
			this.autoDispose = true;
			this.showCancel = true
			this.setContentSize(405,120);
			
			_asset = new NPCPairingAsset();
			addContent(_asset,true);
			
			this.okFunction =__confirm ;
			this.cancelFunction = __cancel;
			
			addEventListener(Event.ADDED_TO_STAGE,__onAddToStage);
		}
		private function get timer():Timer{
			if(!_timer){
				_timer = new Timer(1000,20);
				timer.addEventListener(TimerEvent.TIMER,__onTimer);
			}
			return _timer;
		}
		private function __onAddToStage(evt:Event):void{
			timer.start();
		}
		private function __onTimer(evt:Event):void{
			if(_timer.currentCount < 20)
			{
				_asset.timeTxt.text = String(20-_timer.currentCount);
			}else
			{
				close();
			}
		}
		private function __confirm():void{
			SocketManager.Instance.out.sendBeginFightNpc();
			close();
		}
		private function __cancel():void{
			close();
		}
		override public function close():void{
			super.close();
			dispose();
		}
		override public function dispose():void{
			if(_timer){
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__onTimer);
				_timer.stop();
				_timer = null;
			}
			_asset = null;
			super.dispose();
		}
	}
}