package ddt.roomlist
{
	import game.crazyTank.view.roomlistII.PveRoomListItemIIAsset;
	
	import road.ui.controls.ISelectable;
	
	import ddt.data.DungeonInfo;
	import ddt.data.MapInfo;
	import ddt.data.SimpleRoomInfo;
	import ddt.events.RoomEvent;
	import ddt.game.map.MapSmallIcon;
	import ddt.manager.MapManager;
	
	public class RoomListIIPveRoomItemView extends PveRoomListItemIIAsset implements ISelectable
	{
		private var _info:SimpleRoomInfo;
		private var _selected:Boolean;
		private var _mapIcons:MapSmallIcon;
		
		public function RoomListIIPveRoomItemView(info:SimpleRoomInfo)
		{
			_info = info; 
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_selected = false;
			mouseChildren = false;
			buttonMode = true;
			doubleClickEnabled = true;
			
			gotoAndStop(4);
			
			_mapIcons = new MapSmallIcon();
			_mapIcons.x = mapPos.x;
			_mapIcons.y = mapPos.y;
			addChild(_mapIcons);
			mapPos.visible = false;
			RoomType_mc.gotoAndStop(1);
			hardLevel_mc.gotoAndStop(1);
			update();
		}
		
		private function initEvent():void
		{
			_info.addEventListener(RoomEvent.CHANGED,__changed);
		}
		
		private function __changed(evt:RoomEvent):void
		{
			update();
		}
		
		public function get ID():int
		{
			return _info.ID;
		}
		
		public function get mapID():int
		{
			return _info.mapId;
		}
		
		public function get mapInfo():MapInfo
		{
			return _info.mapInfo;
		} 
		
		public function get RoomName():String
		{
			return _info.dungeonInfo.Name;
		}
		
		public function get RoomMole():int
		{
			return _info.dungeonInfo.Type;
		}
		
		public function get hardLevel():int
		{
			return _info.hardLevel;
		}
		
		public function get RoomPlayerNum():int
		{
			return _info.totalPlayer;
		}
		
		public function get isLock():Boolean
		{
			return _info.IsLocked;
		}
		
		public function get info():SimpleRoomInfo
		{
			return _info;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			update();
		}
		
		private function update():void
		{
			if(_info)
			{
				if(_info.isPlaying)
				{
					_selected ? gotoAndStop(6) : gotoAndStop(5);
				}
				else
				{
					_selected ? gotoAndStop(4) : gotoAndStop(3);
				}
				if(_info.isPlaying)
				{
					gotoAndStop(1);
				}
				name_txt.text = _info.Name;
				id_txt.text = String(_info.ID);
				count_txt.text = String(_info.totalPlayer) + "/" + String(_info.placeCount);
				lock_mc.visible = _info.IsLocked ? true : false;
//				var pic : Number = 0;
//				var dInfo : DungeonInfo = MapManager.getDungeonInfo(_info.mapId);
//				if(dInfo)pic = Number(dInfo.Pic);
//				int(pic);
				_mapIcons.id = _info.mapId;
				if(_info.mapId == 10000)
				{
					hardLevel_mc.gotoAndStop(1);
				}else
				{
					hardLevel_mc.gotoAndStop(_info.hardLevel+2);
				}
//				if(_info.roomType == 2) RoomType_mc.gotoAndStop(1);
				if(_info.roomType == 3) RoomType_mc.gotoAndStop(2);
				if(_info.roomType == 4) RoomType_mc.gotoAndStop(3);
			}
		}
				
		public function dispose():void
		{
			if(_info)
				_info.removeEventListener(RoomEvent.CHANGED,__changed);
			_info = null;
			
			gotoAndStop(4);
			
			if(_mapIcons)
				_mapIcons.dispose();
			_mapIcons = null;
		}
	}
}