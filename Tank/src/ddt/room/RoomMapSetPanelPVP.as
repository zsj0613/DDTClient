package ddt.room
{
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.roomII.RoomIIMapSetPanelAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_10;
	import tank.assets.ScaleBMP_6;
	import ddt.data.MapInfo;
	import ddt.data.RoomInfo;
	import ddt.game.map.MapBigIcon;
	import ddt.game.map.MapSmallIcon;
	import ddt.game.map.MapSmallMinIcon;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.socket.GameInSocketOut;

    //竟技地图设置
	public class RoomMapSetPanelPVP extends RoomMapSetPanelBase
	{
		private var _list:SimpleGrid;
		private var _pics:Array;
		private var _mapinfolist:Array;
		private var _selectedMap:RoomIIMapItem;
		private var _currentMapInfo: MapInfo;
		private var _currentGameType:int;
		private var _secondType:int;
		private var _mapdescript_txt:TextArea;
		private var _mapIcons:MapSmallIcon;
		private var _asset : RoomIIMapSetPanelAsset;
		private var _bottomBMP1:ScaleBMP_10;
		private var _bottomBMP2:ScaleBMP_6;
		
		public function RoomMapSetPanelPVP(controller:RoomIIController,room:RoomInfo)
		{
			super(controller,room);
		}
		
		override protected function init():void
		{
			super.init();
			_hadChange = false;
			_pics = [];
			
			_bg.setSize(608,510);
			_asset = new RoomIIMapSetPanelAsset();
			addChild(_asset);
			
			_bottomBMP1 = new ScaleBMP_10();
			addChildAt(_bottomBMP1,2);
			_bottomBMP1.x= _asset.pos_1.x +17;
			_bottomBMP1.y= _asset.pos_1.y +32;
			
			_bottomBMP2 = new ScaleBMP_6();
			addChildAt(_bottomBMP2,1);
			_bottomBMP2.x= _asset.pos_1.x+7;
			_bottomBMP2.y= _asset.pos_1.y+3;
			_bottomBMP2.height = 430;
			
			_mapIcons = new MapSmallIcon();
			_mapIcons.x = 365;
			_mapIcons.y = 170; 
			addChild(_mapIcons);
			_confirmBtn.x = _asset.okPos.x;
			_confirmBtn.y = _asset.okPos.y;
			_asset.okPos.visible = false;

			_mapdescript_txt = new TextArea();
			ComponentHelper.replaceChild(_asset,_asset.description_pos,_mapdescript_txt);
			_mapdescript_txt.editable = false;
			_mapdescript_txt.textField.selectable = false;
			_mapdescript_txt.setStyle("upSkin",new Sprite());
			_mapdescript_txt.setStyle("textFormat",new TextFormat("Arial",12));
			_asset.premap_pos.visible=false;
			var i:int = 0;
			_asset.mode1_btn.gotoAndStop(2);
			_asset.mode1_btn.buttonMode = false;
			_asset.mode1_btn.addEventListener(MouseEvent.CLICK,__modeClick);
			_asset.mode4_btn.gotoAndStop(2);
//			mode4_btn.buttonMode = true;
//			mode4_btn.addEventListener(MouseEvent.CLICK,__modeClick);
				
			for(i = 1; i <= 3; i++)
			{
				_asset["second_" + i].gotoAndStop(1);
				_asset["second_" + i].buttonMode = true;
				if (_controller.room.roomType == 0 )
				{
					_asset["second_" + i].filters = [];
				}
				else
				{
					_asset["second_" + i].addEventListener(MouseEvent.CLICK,__secondClick);
				}
			}
			_secondType = _room.timeType;
			_asset["second_" + String(_secondType)].gotoAndStop(2);
			_list = new SimpleGrid(130,49,4);
			_list.cellPaddingWidth = 5;
			_list.cellPaddingHeight = 5;
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			ComponentHelper.replaceChild(_asset,_asset.maplist_pos,_list);
			
			_mapinfolist = MapManager.getListByType(_room.roomType);
			_currentMapInfo = _room.mapInfo;
			
			for each(var j:MapInfo in _mapinfolist)
			{
				if(j.Type !=0 && j.Type != 1 && j.Type != 3)continue;
				if(!j.canSelect)continue;
				var tmp:DisplayObject = new MapSmallMinIcon(j.ID);
				if(tmp == null)continue;
				var item:RoomIIMapItem = new RoomIIMapItem(j,tmp);
				
				if(item.id == _currentMapInfo.ID) item.selected = true;
				if(j.isOpen) 
				{
					_list.appendItem(item);
					if ( _controller.room.roomType== 0 )
					{
						item.filters = [];
					}
					else
					{
						item.addEventListener(MouseEvent.CLICK,__itemClick);
					}
					_pics.push(item);
				}
			}
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			updateSelectedMap();
			_asset.mode1_btn.gotoAndStop(2);
			_asset.mode4_btn.gotoAndStop(2);
			_currentGameType = _room.roomType;
			if(_currentGameType == 1)
				_asset.mode1_btn.gotoAndStop(1);
//			else 
//				mode4_btn.gotoAndStop(1);
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("045");
			var item:RoomIIMapItem = evt.currentTarget as RoomIIMapItem;
			for(var i:int = 0; i < _pics.length; i++)
			{
				_pics[i].selected = false;
			}
			
			item.selected = true;
			_currentMapInfo = item.info as MapInfo;
			//_currentMapInfo.ID = 1030;
			updateSelectedMap();
			_hadChange = true;
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			
		}
		
		private function updateSelectedMap():void
		{
			if(_currentMapInfo == null)return;
			_mapIcons.id = _currentMapInfo.ID;
			
			_mapdescript_txt.text = _currentMapInfo.Description;

			if(_selectedMap != null)
			{
				_asset.removeChild(_selectedMap);
				_selectedMap = null;
			}
			
			_selectedMap = new RoomIIMapItem(_currentMapInfo,new MapBigIcon(_currentMapInfo.ID),"selected");
			_selectedMap.buttonMode = false;
			_selectedMap.x = _asset.premap_pos.x;
			_selectedMap.y = _asset.premap_pos.y;
			_asset.addChild(_selectedMap);
		}
		
		private function __modeClick(evt:MouseEvent):void
		{
			_asset.mode1_btn.gotoAndStop(2);
//			mode4_btn.gotoAndStop(2);
			evt.currentTarget.gotoAndStop(1);
			_currentGameType = Number(evt.currentTarget.name.slice(4,5));
			_hadChange = true;
		}
		
		private function __secondClick(evt:MouseEvent):void
		{
			var index:int = Number(evt.currentTarget.name.slice(7,8));
			_asset["second_" + _secondType].gotoAndStop(1);
			_secondType = index;
			_asset["second_" + _secondType].gotoAndStop(2);
			SoundManager.Instance.play("008");
			_hadChange = true;
		}
		
		override protected function __confirmClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_hadChange)
			{
				_room.isRandMap =  ( _currentMapInfo.ID == 0 ? true : false );

				GameInSocketOut.sendGameRoomSetUp(_currentMapInfo.ID,_currentGameType,_secondType);
			}
			hide();
		}
		
		private function __addToStage(e:Event):void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000,0.8);
			_bg.graphics.drawRect(-500,-500,2000,2000);
			_bg.graphics.endFill();
		}
		
		
		override protected function __onKeyDownd(e : KeyboardEvent) : void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				
				_currentGameType = _room.roomType;
				if(_currentGameType == 1)
				{
					_asset.mode1_btn.gotoAndStop(1);
				}
				else
				{
					_asset.mode1_btn.gotoAndStop(2);
				}
				
				_asset["second_1"].gotoAndStop(1);
				_asset["second_2"].gotoAndStop(1);
				_asset["second_3"].gotoAndStop(1)
				_secondType = _room.timeType;
				_asset["second_" + String(_secondType)].gotoAndStop(2);
				
				_mapIcons.id = 0;
				_mapdescript_txt.text = LanguageMgr.GetTranslation("ddt.manager.MapManager.random");
				for(var i:int = 0; i < _pics.length; i++)
				{
					_pics[i].selected = false;
				}
				_pics[0].selected = true;
				
				if(_selectedMap != null)
				{
					_asset.removeChild(_selectedMap);
					_selectedMap = null;
				}
				_selectedMap = new RoomIIMapItem(_currentMapInfo,new MapBigIcon(0),"selected");
				_selectedMap.buttonMode = false;
				_selectedMap.x = _asset.premap_pos.x;
				_selectedMap.y = _asset.premap_pos.y;
				_asset.addChild(_selectedMap);
				
				hide();
				
			}
		}
		
		override public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			_asset.mode1_btn.removeEventListener(MouseEvent.CLICK,__modeClick);
			
			if(_selectedMap)
				_selectedMap.dispose();
			_selectedMap = null;
			
			if(_mapdescript_txt && _mapdescript_txt.parent)
				_mapdescript_txt.parent.removeChild(_mapdescript_txt);
			_mapdescript_txt = null;
			
			if(_mapIcons)
				_mapIcons.dispose();
			_mapIcons = null;
			
			for(var i:int = 0;i<_pics.length;i++)
			{
				_pics[i].removeEventListener(MouseEvent.CLICK,__itemClick);
				_pics[i].dispose();
				_pics[i] = null;
			}
			_pics = null;
			
			if(_list)
			{
				_list.clearItems();
				if(_list.parent)
					_list.parent.removeChild(_list);
			}
			_list = null;
			
			for(i = 1; i <= 3; i++)
			{
				_asset["second_" + i].filters = null;
				_asset["second_" + i].removeEventListener(MouseEvent.CLICK,__secondClick);
			}
			
			if(_asset && _asset.parent)
				_asset.parent.removeChild(_asset);
			_asset = null;
			
			if(_bottomBMP1 && _bottomBMP1.parent)
				_bottomBMP1.parent.removeChild(_bottomBMP1);
			_bottomBMP1 = null;
			
			if(_bottomBMP2 && _bottomBMP2.parent)
				_bottomBMP2.parent.removeChild(_bottomBMP2);
			_bottomBMP2 = null;
			
			_currentMapInfo = null;
			_mapinfolist = null;
			
			super.dispose();
		}
	}
}