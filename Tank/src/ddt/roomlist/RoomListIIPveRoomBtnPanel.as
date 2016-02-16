package ddt.roomlist
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomlistII.PveRoomListIIBtnPanelAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	import ddt.socket.GameInSocketOut;
	public class RoomListIIPveRoomBtnPanel extends PveRoomListIIBtnPanelAsset
	{
		private var _controller:IRoomListIIController;
		
		private var _hadGetRoom:Boolean;
		private var joinDacoity_btn:HTipButton;
		private var joinChallengeBOSS_btn:HTipButton;
		private var lookup_btn:HTipButton;
		
		private var all_btn:HTipButton;
		private var createPveRoom_btn:HTipButton;
		
		private var isClickJoin:Boolean;
		
		private var MyTimer:Timer;
		
		public function RoomListIIPveRoomBtnPanel(controller:IRoomListIIController)
		{
			_controller = controller;
			super();
			init();
			initEvent();
		}
		
		private function init():void 
		{
			_hadGetRoom = false;
			joinDacoity_btn = new HTipButton(joinDacoity_mc ,"" ,LanguageMgr.GetTranslation("ddt.roomlist.joinDuplicateQuickly"));
			joinDacoity_btn.useBackgoundPos =true;
			addChild(joinDacoity_btn);
			
			lookup_btn = new HTipButton(lookupRoom_mc ,"" ,LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIRoomBtnPanel.findRoom"));
			lookup_btn.useBackgoundPos =true;  
			addChild(lookup_btn);
			
			createPveRoom_btn = new HTipButton(creatRoom ,"" ,LanguageMgr.GetTranslation("ddt.roomlist.RoomListIIRoomBtnPanel.createRoom"));
			createPveRoom_btn.useBackgoundPos =true;  
			addChild(createPveRoom_btn);
			
			isClickJoin = true;
			MyTimer = new Timer(1500,0); 
		}
		
		private function initEvent():void
		{
			joinDacoity_btn.addEventListener(MouseEvent.CLICK , __joinDacoityClick);
			lookup_btn.addEventListener(MouseEvent.CLICK , __lookupClick);
			
			createPveRoom_btn.addEventListener(MouseEvent.CLICK , __createPveRoomClick);
			MyTimer.addEventListener(TimerEvent.TIMER , __isCanClick);
		}
		
		
		
		private function __isCanClick(evt:Event):void
		{
			isClickJoin = true;
		}
		
		private function __joinDacoityClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(isClickJoin)
			{
				MyTimer.start();
				isClickJoin = false;
//				SocketManager.Instance.out.sendGameLogin(4);
				SocketManager.Instance.out.sendGameLogin(2,4);
			}
		}
		
		private function __joinChallengeBOSSClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(isClickJoin)
			{
				MyTimer.start();
				isClickJoin = false;
//				SocketManager.Instance.out.sendGameLogin(3);
				SocketManager.Instance.out.sendGameLogin(2,3);
			}
		}
		
		private function __lookupClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			_controller.showFindRoom();
		}
		
		private function __allBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(!_hadGetRoom)
			{
				GameInSocketOut.sendGetAllRoom();
//				SocketManager.Instance.out.sendGetAllRoom();
				_hadGetRoom = true;
			}
			_controller.setRoomShowMode(0);
		}
		
		private function __waitingBtnClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_controller.setRoomShowMode(1);
		}
		
		private function __createPveRoomClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			_controller.showCreateView();
		}
		
		public function dispose():void
		{
			joinDacoity_btn.removeEventListener(MouseEvent.CLICK , __joinDacoityClick);
			lookup_btn.removeEventListener(MouseEvent.CLICK , __lookupClick);
			
			createPveRoom_btn.removeEventListener(MouseEvent.CLICK , __createPveRoomClick);
			MyTimer.removeEventListener(TimerEvent.TIMER , __isCanClick);
			
			joinDacoity_btn.dispose();
			lookup_btn.dispose();
			createPveRoom_btn.dispose();
			
			joinDacoity_btn = null;
			lookup_btn = null;
			createPveRoom_btn = null;
		}

	}
}