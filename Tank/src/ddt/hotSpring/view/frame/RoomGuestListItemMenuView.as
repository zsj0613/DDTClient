package ddt.hotSpring.view.frame
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.bitmap.BlackFrameBG;
	import road.ui.manager.TipManager;
	
	import ddt.data.player.PlayerInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;
	
	public class RoomGuestListItemMenuView extends Sprite
	{
		private var _bg:ScaleBitmap;
		private var _playerInfo:PlayerInfo;	
		private var _kickGuest:RoomGuestListItemMenuItemView;
		
		public function RoomGuestListItemMenuView(playerInfo:PlayerInfo)
		{
			_playerInfo=playerInfo;
			
			_bg = new BlackFrameBG();
			_bg.width = 95;
			_bg.height = 35;
			addChildAt(_bg,0);

			var startPos:Number = 10;
			
			_kickGuest = new RoomGuestListItemMenuItemView(LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.exitRoom"));
			_kickGuest.x = 9;
			_kickGuest.y = startPos;
			startPos+=18;
			_kickGuest.addEventListener("menuClick",__menuClick);
			addChild(_kickGuest);
			
			graphics.beginFill(0,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		private function __menuClick(event:Event):void
		{
			if(_playerInfo)
			{
				switch(event.currentTarget)
				{
					case _kickGuest:
						SocketManager.Instance.out.sendHotSpringRoomAdminRemovePlayer(_playerInfo.ID);
						break;
				}
			}
		}
		
		private function __mouseClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			hide();
		}
		
		public function show():void
		{
			TipManager.AddTippanel(this);
			if(stage && parent)
			{
				var pos:Point = parent.globalToLocal(new Point(stage.mouseX,stage.mouseY));
				this.x = pos.x;
				this.y = pos.y;
				
				if(x + 95 > 1000)
				{
					this.x = x - 95;
				}
				if(y + 55 > 600)
				{
					y = 600-55;
				}
			}
		}
		
		public function hide():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function dispose() : void
		{
			if(_kickGuest && _kickGuest.parent)_kickGuest.parent.removeChild(_kickGuest);
			if(_kickGuest)_kickGuest.dispose();
			_kickGuest = null;
			
			if(_bg) _bg.dispose();
			_bg=null;
			
			if(this.parent)this.parent.removeChild(this);
		}
	}
}