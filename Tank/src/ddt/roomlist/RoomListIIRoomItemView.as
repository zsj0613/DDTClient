package ddt.roomlist
{
	import flash.events.Event;
	
	import game.crazyTank.view.roomlistII.RoomListItemIIAsset;
	
	import road.ui.controls.ISelectable;
	
	import ddt.data.SimpleRoomInfo;
	import ddt.events.RoomEvent;
	import ddt.game.map.MapSmallIcon;

	public class RoomListIIRoomItemView extends RoomListItemIIAsset implements ISelectable
	{
		private static const MAP_INDEX:Array = [0,1,2,4,5,7,8];
	
		private var _info:SimpleRoomInfo;
		private var _selected:Boolean;
//		private var _mapIcons:MapSmallIcon;
	
		public function RoomListIIRoomItemView(info:SimpleRoomInfo)
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
			
//			_mapIcons = new MapSmallIcon();
//			_mapIcons.x = mapPos.x;
//			_mapIcons.y = mapPos.y;
//			addChild(_mapIcons);
//			mapPos.visible = false;
			roomMode_mc.gotoAndStop(1);
//			time_icon.gotoAndStop(2);
			mode_mc.gotoAndStop(1);
			update();
		}
		
		private function initEvent():void
		{
			_info.addEventListener(RoomEvent.CHANGED,__changed);
		}
		
		private function __changed(event:Event):void
		{
			update();
		}
		
		public function get id():int
		{
			return _info.ID;
		}
		
		public function get roomName():String
		{
			return _info.Name;
		}
		
		public function get mapId():int
		{
			return _info.mapId;
		}
		
		public function get roundType():int
		{
			return _info.timeType;
		}
		
		public function get mode():int
		{
			return _info.gameMode;
		}
		
		public function get playerNum():int
		{
			return _info.placeCount;
		}
		
		public function get roomType():int
		{
			return _info.roomTypeString;
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
		
		protected function update():void
		{
			if(_info)
			{
				if ( _info.roomType == 0 )
				{
					if(_info.isPlaying)
					{
						_selected ? gotoAndStop(2) : gotoAndStop(1);
					}
					else
					{
						_selected ? gotoAndStop(4) : gotoAndStop(3);//[frank 2009-04-10]5,6另外两种背景色
					}
				}
				else
				{
					if(_info.isPlaying)
					{
						_selected ? gotoAndStop(2) : gotoAndStop(1);
					}
					else
					{
						_selected ? gotoAndStop(4) : gotoAndStop(3);
					}
				}
				
				name_txt.text = _info.Name;
				id_txt.text = String(_info.ID);
//				time_icon.gotoAndStop(_info.timeType + 1);
				if(_info.roomType == 0)
				{
					_info.totalPlayer = (_info.totalPlayer > 4) ? (4):(_info.totalPlayer)
					_info.placeCount = 	(_info.placeCount > 4) ? (4):(_info.placeCount)
				}
				count_txt.text = String(_info.totalPlayer) + "/" + String(_info.placeCount);
				lock_mc.visible = _info.IsLocked ? true : false;
//				_mapIcons.id = _info.mapId;
				if(_info.roomType==2) mode_mc.gotoAndStop(_info.hardLevel+2);
				else mode_mc.gotoAndStop(1);
				
				if ( _info.roomType == 0 )roomMode_mc.gotoAndStop(2);
					
				else if(_info.roomType == 1)roomMode_mc.gotoAndStop(1);	
				
				else roomMode_mc.gotoAndStop(3);	
					
				
			}
		}
		
		public function dispose():void
		{
			_info.removeEventListener(RoomEvent.CHANGED,__changed);
			_info = null;
		}
	}
}