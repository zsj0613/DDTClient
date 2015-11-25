package ddt.room
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomII.RoomIIFlagPanelAsset;
	
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.ComponentHelper;
	
	import ddt.data.player.RoomPlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.RoomManager;

	/**
	 * 夺取的窗口 
	 * @author Administrator
	 * 
	 */
	public class RoomIIFlagPanel extends RoomIIFlagPanelAsset
	{
		private var _controller:RoomIIController;
		private var _timer:Timer;
		private var _bg:HConfirmFrame;
		private var _team:int;
		private var _list:SimpleGrid;
		private var _self:RoomPlayerInfo;
		
		public function RoomIIFlagPanel(controller:RoomIIController,self:RoomPlayerInfo)
		{
			super();
			_controller = controller;
			_self = self;
			init();
		}
		
		private function init():void
		{
			_bg = new HConfirmFrame();
			_bg.okLabel = LanguageMgr.GetTranslation("duoqi");
			//_bg.okLabel = "夺 旗";
			_bg.cancelLabel = LanguageMgr.GetTranslation("cancel");
			_bg.okFunction = __flagClick;
			_bg.cancelFunction = __cancelClick;
			_bg.buttonGape = 120;
			_bg.setSize(375,420);
			_bg.moveEnable = false;
			_bg.showClose = false;
			addChildAt(_bg,0);
			
			cancel_btn.visible = false;
			flag_btn.visible = false;
			

			_list = new SimpleGrid(290,46);
			_list.cellPaddingHeight = 8;
			ComponentHelper.replaceChild(this,list_pos,_list);
			for each(var i:RoomPlayerInfo in RoomManager.Instance.current.players)
			{
				if(i.team == _self.team)
				{
					var item:RoomIIFlagItem = new RoomIIFlagItem();
					item.info = i;
					_list.appendItem(item);
				}
			}
			
			_timer = new Timer(1000,5);
			_timer.addEventListener(TimerEvent.TIMER,__timer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer.start();
			count_txt.text = "5";
			
		}
		
		private function __timer(evt:TimerEvent):void
		{
			count_txt.text = String(int(count_txt.text) - 1);
		}
		
		private function __timerComplete(evt:TimerEvent):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function __flagClick():void
		{
			_controller.captureLeader(true);
		}
		
		private function __cancelClick():void
		{
			_controller.captureLeader(false);
		}
		
		public function dispose():void
		{
			_timer.removeEventListener(TimerEvent.TIMER,__timer);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,__timerComplete);
			_timer.stop();
			_timer = null;
			
			if(_list)
			{
				for each(var i:RoomIIFlagItem in _list.items)
				{
					i.dispose();
					i = null;
				}
				_list.clearItems();
				
				if(_list.parent)
					_list.parent.removeChild(_list);
			}
			_list = null;
			
			if(_bg)
				_bg.dispose();
			_bg = null;
			
			_controller = null;
			_self = null;
			
			if(parent != null)
				parent.removeChild(this);
		}
		
	}
}