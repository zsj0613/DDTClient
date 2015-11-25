package ddt.room
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import ddt.data.RoomInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.NPCPairingDialog;
	import tank.room.PickupInfoAsset;

	public class PickupInfoPannel extends PickupInfoAsset
	{
		private var _room:RoomInfo;
		private var _self:RoomPlayerInfo;
		private var _timer:Timer ;
		private var btnZiyou: HFrameButton;
		private var btnGonghui:HFrameButton;
		
		public function PickupInfoPannel(room:RoomInfo,self:RoomPlayerInfo)
		{
			super();
			_room = room;
			_self = self;
			
			btnZiyou = new HFrameButton(mc_ziyou);
			btnZiyou.useBackgoundPos = true;
			addChild(btnZiyou);
			
			btnGonghui = new HFrameButton(mc_gonghui);
			btnGonghui.useBackgoundPos = true;
			addChild(btnGonghui);
			
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,__timer);
			_room.addEventListener(RoomEvent.CHANGED,__update);
			this.btnGonghui.addEventListener(MouseEvent.CLICK,  __selectConsortiaHandler);
			this.btnZiyou.addEventListener(MouseEvent.CLICK,    __selectLibertyHandler);
			__update(null);
			stopPickup();
		}
		private function __selectConsortiaHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				GameInSocketOut.sendGameStyle(1);
			}
		}
		private function __selectLibertyHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				GameInSocketOut.sendGameStyle(0);
			}
		}
		public function startPickup():void
		{
			time_txt.visible = true;
			mc_waiting.visible = true;
			mc_gamestyle.visible = true;
			_timer.start();
			__timer(null);
			if(_room.gameStyle == 2)
			{
				_room.gameStyle = 1;
			}
			btnGonghui.visible = false;
			btnZiyou.visible = false;
		}
		
		public function stopPickup():void
		{
			time_txt.visible = false;
			mc_waiting.visible = false;
			_timer.reset();
			mc_gamestyle.visible = false;
			btnGonghui.visible = true;
			btnZiyou.visible = true;
			if(_alert)_alert.dispose();
		}
		
		private function __update(event:Event):void
		{
			updateButtons();
		}
		
		public function resetTimer():void
		{
			_timer.reset();
		}
		
		private function updateButtons():void
		{
			btnZiyou.enable = true;
			btnGonghui.enable = (_room.gameStyle ==0 ? false : true);
			btnGonghui.mouseEnabled = btnGonghui.enable;
			if(_room.gameMode == 1 && _room.players.length != 1)
			{
				mc_gamestyle.gotoAndStop(2);
				btnZiyou.selected = false;
				btnGonghui.selected = true;
			}else if(_room.gameMode == 4 )
			{
				mc_gamestyle.gotoAndStop(2);
				btnZiyou.selected = false;
				btnGonghui.selected = true;
				if(_room.players.length == 1)
				{
					btnGonghui.enable = false;
				}
			}
			else
			{
				mc_gamestyle.gotoAndStop(1);
				btnZiyou.selected = true;
				btnGonghui.selected = false;
				if(_room.players.length == 1)
				{
					btnGonghui.enable = false;
				}
			}
			if(PlayerManager.selfRoomPlayerInfo.isHost)
			{
				btnZiyou.mouseEnabled   = btnZiyou.mouseChildren   = true;
				btnGonghui.mouseEnabled = btnGonghui.mouseChildren = btnGonghui.enable;
			}
			else
			{
				btnZiyou.mouseEnabled   = btnZiyou.mouseChildren   = false;
				btnGonghui.mouseEnabled = btnGonghui.mouseChildren = false;
			}
		}

		private function __timer(event:Event):void
		{
			var min:uint = _timer.currentCount / 60;
			var sec:uint = _timer.currentCount % 60;
			time_txt.text = (min > 9 ? min.toString() : "0"+min)+":"+(sec > 9 ? sec.toString() : "0"+sec);
			if(_timer.currentCount == 20)
			{
				if(!_self.isHost)
				{
					BellowStripViewII.Instance.goReturnBtn.enable = true;
				}
			}
//			if(_timer.currentCount > 0 && _timer.currentCount % 10 == 0 && _room.gameStyle == 1 && _self.isHost)
			if( _timer.currentCount  == 60 && _room.gameMode == 1 && _self.isHost)
			{
				if(_alert == null)
				{
					_alert = HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.room.PickupPanel.ChangeStyle"),true,__enterFreeStyle,__cancelFreeStyle);
					_alert.contentTextField.y = 45;
				}
			}
			if(_timer.currentCount >= 20)
			{
				dispatchEvent(new RoomEvent(RoomEvent.WAITSEC30));
			}
			if(_timer.currentCount>0 && _timer.currentCount<60 && sec % 40 == 0){
				if(this._room.gameMode == 0)
					displayFightNpc();
			}
		}
		public function displayFightNpc():void{
//			if(!this._self.isHost){
//				return;
//			}
//			TipManager.AddTippanel(new NPCPairingDialog(),true);
		}
		private var _alert:HConfirmDialog;
		private function __enterFreeStyle():void
		{
			_alert = null;
			GameInSocketOut.sendGameStyle(2);
			var msg : ChatData = new ChatData();
			msg.channel = ChatInputView.SYS_TIP;
			msg.msg     = LanguageMgr.GetTranslation("ddt.room.UpdateGameStyle");
			ChatManager.Instance.chat(msg);
		}
		
		private function __cancelFreeStyle():void
		{
			_alert = null;
		}
		
		public function dispose():void
		{
			if(_alert)_alert.dispose();
			_alert= null;
			_timer.removeEventListener(TimerEvent.TIMER,__timer);
			_timer = null;
			this.btnGonghui.removeEventListener(MouseEvent.CLICK,  __selectConsortiaHandler);
			this.btnZiyou.removeEventListener(MouseEvent.CLICK,    __selectLibertyHandler);
			_room.removeEventListener(RoomEvent.CHANGED,__update);
			_room = null;
		}
	}
}