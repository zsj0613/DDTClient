package ddt.room
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomII.RoomIIMapSetAsset;
	
	import road.ui.controls.HButton.HTipButton;
	import road.utils.ComponentHelper;
	
	import ddt.data.RoomInfo;
	import ddt.data.player.RoomPlayerInfo;
	import ddt.events.RoomEvent;
	import ddt.game.map.MapBigIcon;
	import ddt.game.map.MapSmallIcon;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.RoomManager;
	
	public class RoomIIMapSet extends RoomIIMapSetAsset
	{
		private var _controller:RoomIIController;
		private var _map:RoomIIMapSetItem;
		private var _self:RoomPlayerInfo;
		private var _room:RoomInfo;
		private var btnSetting : HTipButton;
		private var _mapIcon:MapSmallIcon;
		public var _settingEnable : Boolean = true;//是否显示设置按钮
		
		public function RoomIIMapSet(controller:RoomIIController=null)
		{
			super();
			_controller = controller;
			_self = PlayerManager.selfRoomPlayerInfo;//controller.self;
			_room = RoomManager.Instance.current;//_controller.room;
			init();
			initEvent();
		}
		
		private function init():void
		{
			btnSetting  = new HTipButton(change_btn,"",LanguageMgr.GetTranslation("ddt.room.RoomIIMapSet.room2"));
			btnSetting.useBackgoundPos = true;
			addChild(btnSetting);
			
			_map = new RoomIIMapSetItem();
			
			ComponentHelper.replaceChild(this,map_pos,_map);
			
			_mapIcon = new MapSmallIcon();
			_mapIcon.mouseEnabled = false;
			_mapIcon.x = 10;
			_mapIcon.y = 20;
			addChild(_mapIcon);
			roomModeMc.mouseChildren = roomModeMc.mouseEnabled = false;
			roomPermissionMc.mouseChildren = roomPermissionMc.mouseEnabled = false;
			levelMc.mouseChildren = levelMc.mouseEnabled = false;
			levelMc.gotoAndStop(1);
			this.levelBound_txt.text = "";
			Lv_mc.visible=false;
			if(_room.roomType < 2)
			{
				levelMc.visible = roomModeMc.visible = roomPermissionMc.visible = false;
				roomModeMc.y       = 62;
				roomPermissionMc.x  = 11;
				levelBound_mc.visible = false;
			}
			else if(_room.roomType == 2)
			{
				teammode_mc.visible = false;
				second_mc.visible   = false;
//				roomModeMc.visible  = roomPermissionMc.visible = false;
				levelMc.visible     = true;
				roomModeMc.y       = 85;
				roomPermissionMc.x  = 90;
				levelMc.gotoAndStop(_room.levelLimits);
				levelBound_mc.visible = false;
			}
			else
			{
				roomModeMc.visible  = roomPermissionMc.visible = true;
				teammode_mc.visible = false;
				second_mc.visible   = false;
				levelMc.visible     = false;
//				roomModeMc.y        = 62;
//				roomPermissionMc.x  = 11;
				levelBound_mc.gotoAndStop(1);
				levelBound_mc.mouseChildren = false;
				levelBound_mc.mouseEnabled  = false;
			}
			mapSetFlicker_mc.visible = false;
			__hostChange(null);
			__update(null);
		}
		
		
		private function initEvent():void
		{
			_self.addEventListener(RoomEvent.PLAYER_STATE_CHANGED,__hostChange);
			_room.addEventListener(RoomEvent.CHANGED,__update);
			
			addEventListener(MouseEvent.CLICK,__changeMapClick);
			mapSetFlicker_mc.addEventListener(MouseEvent.CLICK ,__changeMapClick);
		}
		public function mapSetFlicker():void
		{
			if(!mapSetFlicker_mc.visible)
			{
				mapSetFlicker_mc.visible = true;
				mapSetFlicker_mc.play();
			}else
			{
				mapSetFlicker_mc.visible = false;
			}
		}
		
		private function __update(event:Event):void
		{
			_map.setPic(new MapBigIcon(_room.mapId));	
			_mapIcon.id = _room.mapId;
			_mapIcon.visible = _room.mapId != 0;
			second_mc.gotoAndStop(_room.timeType);
			teammode_mc.gotoAndStop(1);
			
			
			if(_room.roomType >= 2)
			{
				roomModeMc.gotoAndStop(_room.roomType-1);
				roomPermissionMc.gotoAndStop(_room.hardLevel+1);
				levelBound_mc.gotoAndStop(_room.hardLevel+1);
				levelMc.gotoAndStop(_room.levelLimits);
			}
			if(_room.roomType == 0)
			{
				second_mc.gotoAndStop(3);
			}
			if(_room.mapId == 10000 && _room.roomType > 2)
			{
				levelBound_mc.visible = roomModeMc.visible = roomPermissionMc.visible = _mapIcon.visible =false;
				Lv_mc.visible=false;
				levelBound_txt.text = "";
			}else if(_room.roomType > 2)
			{
				levelBound_mc.visible = roomModeMc.visible = roomPermissionMc.visible = _mapIcon.visible =true;
				Lv_mc.visible=true;
				levelPhase();
			}
		}
		
		private function levelPhase():void
		{
			if(!_room || !_room.dungeonInfo)return;
			var str:String =  _room.dungeonInfo.AdviceTips;
			if(str)
			{
				var array:Array = str.split("|");
				levelBound_txt.htmlText = "";
				if(_room.hardLevel >= array.length)
				{
					return;
				}else
				{
					this.levelBound_txt.text = array[_room.hardLevel];
				}
			}
		}
	
		private function __changeMapClick(evt:MouseEvent):void
		{
			if(!_controller)return;
			if(_room.roomState == RoomInfo.STATE_PICKING)return;
			if(_self.isHost)
			{
				if(mapSetFlicker_mc.visible)mapSetFlicker_mc.visible = false; 
				if(evt)evt.stopImmediatePropagation();
				_controller.showMapSet();
			}
		}
		
		
		private function __hostChange(evt:RoomEvent):void
		{
            buttonMode = mouseEnabled = btnSetting.visible = false;
            if(_self.isHost)
            {
            	if(_room.roomType >= 1 )
            	{
            		buttonMode = mouseEnabled = btnSetting.visible = _settingEnable;
            	}
            }
			if(_room.roomType >= 2)
			{
				roomModeMc.gotoAndStop(_room.roomType-1);
				roomPermissionMc.gotoAndStop(_room.hardLevel+1);
				levelBound_mc.gotoAndStop(_room.hardLevel+1);
			}
		}
		public function set settingEnable(b : Boolean) : void
		{
			_settingEnable = b;
			buttonMode = mouseEnabled = btnSetting.visible = b;
		}
		
		public function dispose():void
		{
			_mapIcon.dispose();
			_mapIcon = null;
			
			_controller = null;
			if(_map)
			{
				_map.dispose();
				_map = null;
			}
			if(btnSetting)
			{
				btnSetting.dispose();
				btnSetting = null;
			}
			removeEventListener(MouseEvent.CLICK,__changeMapClick);
			_room.removeEventListener(RoomEvent.CHANGED,__update);
			_self.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED,__hostChange);
			mapSetFlicker_mc.removeEventListener(MouseEvent.CLICK ,__changeMapClick);
			if(parent)
				parent.removeChild(this);
		}
	}
}