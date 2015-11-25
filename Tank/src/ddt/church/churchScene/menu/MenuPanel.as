package ddt.church.churchScene.menu
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import road.BitmapUtil.ScaleBitmap;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.bitmap.BlackFrameBG;
	import road.ui.manager.TipManager;
	
	import ddt.data.ChurchRoomInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.SocketManager;
	
	public class MenuPanel extends Sprite
	{
		private var _info:PlayerInfo;
		
		private var _kickGuest:MenuItem;
		private var _blackGuest:MenuItem;
		
		private var _bg:ScaleBitmap;
		
		public function MenuPanel()
		{
			_bg = new BlackFrameBG();
			_bg.width = 95;
			_bg.height = 55;
			addChildAt(_bg,0);
			
			var startPos:Number = 10;
			
			_kickGuest = new MenuItem(LanguageMgr.GetTranslation("ddt.room.RoomIIPlayerItem.exitRoom"));
			//_kickGuest = new MenuItem("踢出房间");
			_kickGuest.x = 9;
			_kickGuest.y = startPos;
			startPos+=18;
			_kickGuest.addEventListener("menuClick",__menuClick);
			addChild(_kickGuest);
			
			_blackGuest = new MenuItem(LanguageMgr.GetTranslation("ddt.menu.AddBlack"));
			//_blackGuest = new MenuItem("加入黑名单");
			_blackGuest.x = 9;
			_blackGuest.y = startPos;
			startPos+=18;
			_blackGuest.addEventListener("menuClick",__menuClick);
			addChild(_blackGuest);
			
			graphics.beginFill(0,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		public function set playerInfo(value:PlayerInfo):void
		{
			_info = value;
		}
		
		private function __mouseClick(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			hide();
		}
		
		private function __menuClick(event:Event):void
		{
			if(ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_ING)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.menu.MenuPanel.menuClick"));
				return;
			}
			
			if(_info)
			{
				switch(event.currentTarget)
				{
					case _kickGuest:
						SocketManager.Instance.out.sendChurchKick(_info.ID);
						break;
					case _blackGuest:
						SocketManager.Instance.out.sendChurchForbid(_info.ID);
						break;
					default:
						break;
				}
			}
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
			_info = null;
			if(_kickGuest && _kickGuest.parent)_kickGuest.parent.removeChild(_kickGuest);
			if(_kickGuest)_kickGuest.dispose();
			_kickGuest = null;
			if(_blackGuest && _blackGuest.parent)_blackGuest.parent.removeChild(_blackGuest);
			if(_blackGuest)_blackGuest.dispose();
			_blackGuest = null;
			_bg = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}