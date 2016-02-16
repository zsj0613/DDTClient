package ddt.room
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	
	import game.crazyTank.view.roomII.DuplicatePreviewAsset;
	import game.crazyTank.view.roomII.DuplicateRoomSetPanelAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_5;
	import tank.assets.ScaleBMP_6;
	import ddt.data.DungeonInfo;
	import ddt.data.RoomInfo;
	import ddt.data.player.SelfInfo;
	import ddt.game.map.MapBigIcon;
	import ddt.game.map.MapSmallIcon;
	import ddt.game.map.MapSmallMinIcon;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.common.DuplicatePreview;

	//夺宝，BOSS地图设置
	public class RoomMapSetPanelDuplicate extends RoomMapSetPanelBase
	{
		private var _list:SimpleGrid;
		private var _pics:Array;
		private var _mapinfolist:Array;
		private var _selectedMap:RoomIIMapItem;
		private var _currentMapInfo: DungeonInfo;
		private var _currentRoomType:int;
		
		private var _permissionType : int;
		
		private var _mapdescript_txt:TextArea;
		
		private var _mapIcons:MapSmallIcon;
		private var myColorMatrix_filter:ColorMatrixFilter;
		private var _currentPermissionBtn : MovieClip;
		private var _asset : DuplicateRoomSetPanelAsset;
		private var _bottomBMP1:ScaleBMP_5;
		private var _bottomBMP2:ScaleBMP_6;
		private var _mapIsSelected:Boolean;
		private var _duplicatePreview:DuplicatePreview;
		private var _duplicatePreBg	 :DuplicatePreviewAsset;
		
		//private static const PREVIEW_ID:int = 4;
		
		public function RoomMapSetPanelDuplicate(controller:RoomIIController,room:RoomInfo)
		{
			super(controller,room);
		}
		
		override protected function init():void
		{
			super.init();
			myColorMatrix_filter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			_hadChange = false;
			_mapIsSelected = false;
			_pics = [];
			_bg.setSize(608,590);
			_bg.x = 32;
			
			_asset = new DuplicateRoomSetPanelAsset();
			addChild(_asset);
			
			_bottomBMP2 = new ScaleBMP_6();
			addChildAt(_bottomBMP2,1);
			_bottomBMP2.x = _asset.pos_1.x;
			_bottomBMP2.y = _asset.pos_1.y;
			
			_bottomBMP1 = new ScaleBMP_5();
			addChildAt(_bottomBMP1,2);
			_bottomBMP1.x = _asset.pos_1.x+9;
			_bottomBMP1.y = _asset.pos_1.y+20;
			
			_asset.removeChild(_asset.pos_1);
			
			_mapIcons = new MapSmallIcon();
			_mapIcons.x = 365;
			_mapIcons.y = 170; 
			addChild(_mapIcons);
			
			_confirmBtn.x = _asset.okPos.x;
			_confirmBtn.y = _asset.okPos.y;
			_asset.okPos.visible = false;
			
			_asset.modeMc_1.buttonMode = true;
			_asset.modeMc_2.buttonMode = true;
			
			//if(!false)
			//{
			//	_asset.modeMc_2.filters = [myColorMatrix_filter];
			//	_asset.modeMc_2.mouseChildren = false;
			//	_asset.modeMc_2.mouseEnabled  = false;
			//}
			_mapdescript_txt = new TextArea();
			_mapdescript_txt.mouseEnabled=false;
			_mapdescript_txt.editable = false;
			_mapdescript_txt.textField.selectable = false;
			_mapdescript_txt.textField.mouseEnabled=false;
			ComponentHelper.replaceChild(_asset,_asset.description_pos,_mapdescript_txt);
			_mapdescript_txt.setStyle("upSkin",new Sprite());
			_mapdescript_txt.setStyle("textFormat",new TextFormat("Arial",12));
			_asset.premap_pos.visible = false;
			
			var i:int = 0;
			for(i = 1; i <= 4; i++)
			{
				_asset["Permission_" + i].gotoAndStop(1);
				_asset["Permission_" + i].buttonMode = false;
				_asset["Permission_" + i].filters = [myColorMatrix_filter];
			}
			_permissionType = -1;
			_list = new SimpleGrid(130,49,4);
			_list.cellPaddingWidth = 5;
			_list.cellPaddingHeight = 5;
			_list.verticalScrollPolicy = ScrollPolicy.ON;
			ComponentHelper.replaceChild(_asset,_asset.maplist_pos,_list);
			_currentMapInfo = _room.dungeonInfo;
			if(_currentMapInfo)
			{
				_hadChange = true;
				if(_permissionType != -2)
				{
					_permissionType = _room.hardLevel+1;
					_asset["Permission_" + _permissionType].gotoAndStop(4);
					_currentPermissionBtn = _asset["Permission_" + _permissionType];
				}
			}
			//if(_currentRoomType == 3)
			//{
			//	_permissionType =1;
			//	permissionEnable();
			//	_hadChange = true;
			//}
		}
		
		private function __addToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,             __addToStage);
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000,0.8);
			_bg.graphics.drawRect(-500,-500,2000,2000);
			_bg.graphics.endFill();
			initView();
		}
		private function initView() : void
		{
			currentRoomType(_room.roomType);
			if(_permissionType != -1&&_permissionType != -2)
				permissionBtnStatus(_permissionType);
			if(_currentMapInfo)
			{
				setPermissionBtnPos(_currentMapInfo);
			}
		}
		private function __itemClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("045");
			var item:RoomIIMapItem = evt.currentTarget as RoomIIMapItem;
			{
				if(item.info is DungeonInfo)
				{
					if((item.info as DungeonInfo).LevelLimits > PlayerManager.Instance.Self.Grade)
					{
						MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomMapSetPanelDuplicate.clew",(item.info as DungeonInfo).LevelLimits));
						return;
					}
				}
			}
			
			
			if(_list)
			{
				for(var j:int=0;j<_list.items.length;j++)
					_list.items[j].stopFlicker();
			}
			_permissionType = -2;
			
			permissionEnable();
			
			for(var i:int = 0; i < _pics.length; i++)
			{
				_pics[i].selected = false;
			}
			
			item.selected = true;
			_currentMapInfo = item.info as DungeonInfo;
			updateSelectedMap();
			_asset.Permission_1.filters = null;
			_mapIsSelected = true;
			setPermissionBtnPos(_currentMapInfo);
			checkEnable(_currentMapInfo.ID,1);
			checkEnable(_currentMapInfo.ID,2);
			checkEnable(_currentMapInfo.ID,3);

		}
		
		private function duplicatePreviewOK():void
		{
			if(_duplicatePreBg && _duplicatePreBg.parent)
			{
				_duplicatePreBg.parent.removeChild(_duplicatePreBg);
			}
			_duplicatePreBg=null;
			if(_duplicatePreview)
			{
				_duplicatePreview.dispose();
				_duplicatePreview.close();
			}
			_duplicatePreview=null;
		}
		
		private function setPermissionBtnPos(info:DungeonInfo):void
		{
			_asset.Permission_1.visible = true;
			_asset.Permission_2.visible = true;
			_asset.Permission_3.visible = true;
			_asset.Permission_4.visible = true;
			for(var i:int=1;i<=4;i++)
			{
				_asset["Permission_"+i].gotoAndStop(1);
			}			
			switch(info.ID){
				default:
					_asset.Permission_1.visible = false;
					_asset.Permission_3.visible = false;
					_asset.Permission_4.visible = false;	
					_asset.Permission_2.x = 280;
					break;
			}
		}
		
		private function __selectModeHandler(evt : MouseEvent) : void
		{
			var mode : int = _currentRoomType;
			if(evt.currentTarget == _asset.modeMc_1)
			{
				mode = 4;
			}
			else if(evt.currentTarget == _asset.modeMc_2)
			{
				mode = 3;
			}
			if(mode == _currentRoomType)return;
			
			_mapinfolist = MapManager.getListByType(mode);
			
			if(_mapinfolist.length == 0)
				
				return;
			//			_currentMapInfo = _mapinfolist[0] as DungeonInfo;
			//			if(!_currentMapInfo)return;
			
			_currentMapInfo = null;
			_permissionType = -2;
			
			//_hadChange = false;
			
			_mapIsSelected = false;
			
			permissionEnable()
			
			currentRoomType(mode);
			
			//			permissionBtnStatus(1);
			SoundManager.Instance.play("008");
			//if(_currentRoomType == 3)
			//{
			//	_permissionType =1;
			//	permissionEnable();
				_hadChange = true;
			//}
		}
		private function currentRoomType($roomType:int) : void
		{
			if(_currentRoomType == $roomType)return;
			_currentRoomType = $roomType
			if($roomType == 4)
			{
				_asset.modeMc_1.gotoAndStop(2);
				_asset.modeMc_2.gotoAndStop(1);
			}
			else
			{
				_asset.modeMc_1.gotoAndStop(1);
				_asset.modeMc_2.gotoAndStop(2);
			}
			upMapList();
		}
		
		//显示地图列表
		private function upMapList() : void
		{
			clearList();
			_mapinfolist = MapManager.getListByType(_currentRoomType);
			if(_mapinfolist.length == 0)return;
			for each(var j: DungeonInfo in _mapinfolist)
			{
				if(j.Type != 3 && j.Type != 4)continue;
				//				var tmp:DisplayObject = new MapBigIcon(int(Number(j.Pic)));
				var tmp:DisplayObject = new MapSmallMinIcon(int(j.ID));
				if(tmp == null)continue;
				var item:RoomIIMapItem = new RoomIIMapItem(j,tmp);
				if(_currentMapInfo && item.id == _currentMapInfo.ID) item.selected = true;
				if(!_currentMapInfo && item.id == 10000)
				{
					item.selected = true;
					_currentMapInfo = item.info as DungeonInfo;
				}
				if(j.isOpen) 
				{
					
					if(item.id == 10000)
					{
						continue;
					}
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
			updateSelectedMap();
			
		}
		
		private function mapFlicker():void
		{
			if(_list)
			{
				for(var i:int=0;i<_list.items.length;i++)
					_list.items[i].flicker();
			}
		}
		
		private function permissionFlicker():void
		{
			
			for(var i:int=1;i<=4;i++)
			{
				if(_asset["Permission_"+i].filters.length == 0)
				{
					_asset["Permission_"+i].play();
				}
			}
		}
		
		private function clearList() : void
		{
			for each(var item : RoomIIMapItem in _list)
			{
				item.removeEventListener(MouseEvent.CLICK,__itemClick);
				item.dispose();
			}
			_list.clearItems();
		}
		
		//当前选中的难度
		private function permissionBtnStatus(index : int) : void
		{
			_permissionType = index;
			for(var i:int=1;i<=4;i++)
			{
				_asset["Permission_"+i].gotoAndStop(1);
			}
			if(_currentPermissionBtn)
			{
				_currentPermissionBtn.gotoAndStop(1);
			}
			_currentPermissionBtn = _asset["Permission_" + index] as MovieClip;
			if(_currentPermissionBtn && _currentPermissionBtn.filters.length == 0)
			{
				_currentPermissionBtn.gotoAndStop(4);
			}
		}
		private function permissionEnable() : void
		{
			for(var i:int=1;i<=4;i++)
			{
				if(_asset["Permission_"+i].visible){
					_asset["Permission_"+i].filters = [myColorMatrix_filter];
					_asset["Permission_"+i].gotoAndStop(1);
				}
			}
		}
		private function permissionNoEnable() : void
		{
			for(var i:int=1;i<=4;i++)
			{
				if(_asset["Permission_"+i].visible){
					_asset["Permission_"+i].filters = null;
					_asset["Permission_"+i].gotoAndStop(1);
					_asset["Permission_"+i].mouseChildren  = true;
					_asset["Permission_"+i].mouseEnabled   = true;
					_asset["Permission_"+i].buttonMode     = true;
				}
			}
		}
		//难度按钮的显示情况
		private function upPermissionStatus(mapId : int) : void
		{
			_asset.Permission_1.visible = true;
			checkEnable(mapId,0);
			checkEnable(mapId,1);
			checkEnable(mapId,2);
			checkEnable(mapId,3);
		}
		
		/**
		 * 传入地图的ID和相应的难度，
		 * 以检查是否有相应的权限
		 */
		private function checkEnable(mapid : int,index : int)  : void
		{
			var self : SelfInfo = PlayerManager.Instance.Self;
			var btn : MovieClip = _asset["Permission_"+String(index+1)] as MovieClip;
			if(!btn)return;
			if(!self.getPveMapPermission(mapid,index)|| !checkTemplateIds(index))
			{
				btn.filters = [myColorMatrix_filter];
				btn.mouseChildren  = false;
				btn.mouseEnabled   = false;
				btn.buttonMode     = false;
			}
			else
			{
				btn.filters       = null;
				btn.mouseChildren = true;
				btn.mouseEnabled  = true;
				btn.buttonMode    = true;
			}
			self = null;
		}
		
		//掉落为空时，该难度不可玩
		private function checkTemplateIds(index : int) : Boolean
		{
			if(!_currentMapInfo)return false;
			var temp : String = "";
			if(index == 0)
			{
				temp = _currentMapInfo.SimpleTemplateIds;
				if(temp == "" || temp == null)
				{
					return false;
				}
			}
			else if(index == 1)
			{
				temp = _currentMapInfo.NormalTemplateIds;
				if(temp == "" || temp == null)
				{
					return false;
				}
			}
			else if(index == 2)
			{
				temp = _currentMapInfo.HardTemplateIds;
				if(temp == "" || temp == null)
				{
					return false;
				}
			}
			else if(index == 3)
			{
				temp = _currentMapInfo.TerrorTemplateIds;
				if(temp == "" || temp == null)
				{
					return false;
				}
			}
			return true;
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			for(var i:int=1;i<=4;i++)
			{
				_asset["Permission_"+i].addEventListener(MouseEvent.CLICK,   __PermissionClickHandler);
			}
			_asset.modeMc_1.addEventListener(MouseEvent.CLICK, __selectModeHandler);
			_asset.modeMc_2.addEventListener(MouseEvent.CLICK, __selectModeHandler);
			addEventListener(Event.ADDED_TO_STAGE,             __addToStage);
		}
		
		private function clealPreMap() : void
		{
			_mapdescript_txt.text = "";
			if(_selectedMap != null)
			{
				this.removeChild(_selectedMap);
				_selectedMap.dispose();
				_selectedMap = null;
			}
			_mapIcons.id = -1;
		}
		
		private function updateSelectedMap():void
		{
			clealPreMap();
			if(!_currentMapInfo)return;
			//			_mapIcons.id = int(Number(_currentMapInfo.Pic));
			_mapIcons.id = int(_currentMapInfo.ID);
			_mapdescript_txt.text = _currentMapInfo.Description;
			_selectedMap = new RoomIIMapItem(_currentMapInfo,new MapBigIcon(_mapIcons.id),"selected");
			_selectedMap.buttonMode = false;
			_selectedMap.x = _asset.premap_pos.x;
			_selectedMap.y = _asset.premap_pos.y;
			this.addChild(_selectedMap);
			
			if(_currentMapInfo)
			{
				if(_currentRoomType == 4)
				{
					upPermissionStatus(_currentMapInfo.ID);
				}
				else if(_currentRoomType == 3)
				{
					_asset.Permission_1.filters = null;
					_asset.Permission_1.gotoAndStop(1);
					_asset.Permission_1.mouseChildren  = true;
					_asset.Permission_1.mouseEnabled   = true;
					_asset.Permission_1.buttonMode     = true;
					checkEnable(_currentMapInfo.ID,1);
					checkEnable(_currentMapInfo.ID,2);
					checkEnable(_currentMapInfo.ID,3);
				}
			}
			//			else permissionEnable();
		}
		
		
		private function __PermissionClickHandler(evt:MouseEvent):void
		{
			var index:int = Number(evt.currentTarget.name.slice(11,12));
			_permissionType = index;
			_hadChange = true;
			permissionBtnStatus(_permissionType);
			SoundManager.Instance.play("008");
		}
		
		override protected function __confirmClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_hadChange && _currentMapInfo && _permissionType!=-1 && _permissionType!=-2 && _currentMapInfo.ID != 10000)
			{
				_room.isRandMap =  ( _currentMapInfo.ID == 0 ? true : false );
				if(_room.dungeonInfo &&_room.dungeonInfo == _currentMapInfo && _room.roomType == _currentRoomType && _room.hardLevel+1 == _permissionType)
				{
					_controller.setingAchieve = true;
					hide();
					return;
				}
				GameInSocketOut.sendGameRoomSetUp(_currentMapInfo.ID,_currentRoomType,1/**时间参数，副本设置中无用*/,_permissionType-1);
				_controller.setingAchieve = true;
				hide();
			}else if(!_mapIsSelected || _currentMapInfo.ID == 10000)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomMapSetPanelDuplicate.choiceMap"));
				mapFlicker();
			}
			if((_permissionType == -1 && _mapIsSelected) || (_permissionType ==-2 && _mapIsSelected))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.room.RoomMapSetPanelDuplicate.choicePermissionType"));
				permissionFlicker();
			}
		}
		
		
		
		
		override protected function __onKeyDownd(e : KeyboardEvent) : void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				_permissionType = _room.hardLevel+1;
				_currentRoomType = -1;
				
				hide();
				
			}
		}
		
		override public function dispose():void
		{
			_asset.modeMc_1.removeEventListener(MouseEvent.CLICK, __selectModeHandler);
			_asset.modeMc_2.removeEventListener(MouseEvent.CLICK, __selectModeHandler);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			
			if(_duplicatePreBg && _duplicatePreBg.parent)
			{
				_duplicatePreBg.parent.removeChild(_duplicatePreBg);
			}
			_duplicatePreBg=null;
			if(_duplicatePreview)
			{
				_duplicatePreview.dispose();
				_duplicatePreview.close();
			}
			_duplicatePreview=null;
			
			if(_selectedMap)
				_selectedMap.dispose();
			_selectedMap = null;
			
			if(_mapdescript_txt && _mapdescript_txt.parent)
				_mapdescript_txt.parent.removeChild(_mapdescript_txt);
			_mapdescript_txt = null;
			
			if(_mapIcons)
				_mapIcons.dispose();
			_mapIcons = null;
			
			for(i = 1; i <= 4; i++)
			{
				_asset["Permission_" + i].filters = null;
				_asset["Permission_" + i].gotoAndStop(1);
				_asset["Permission_" + i].buttonMode = true;
				_asset["Permission_" + i].removeEventListener(MouseEvent.CLICK,__PermissionClickHandler);
			}
			
			for(var i:int = 0;i<_pics.length;i++)
			{
				_pics[i].removeEventListener(MouseEvent.CLICK,__itemClick);
				_pics[i].dispose();
				_pics[i] = null;
			}
			_pics = null;
			
			_list.clearItems();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
			
			if(_asset)
			{
				if(_asset.modeMc_2)
					_asset.modeMc_2.filters = null;
				if(_asset.parent)
					_asset.parent.removeChild(_asset);
			}
			_asset = null;
			
			if(_bottomBMP1 && _bottomBMP1.parent)
				_bottomBMP1.parent.removeChild(_bottomBMP1);
			_bottomBMP1 = null;
			
			if(_bottomBMP2 && _bottomBMP2.parent)
				_bottomBMP2.parent.removeChild(_bottomBMP2);
			_bottomBMP2 = null;
			
			myColorMatrix_filter = null;
			_currentPermissionBtn = null;
			_currentMapInfo = null;
			_mapinfolist = null;
			super.dispose();
		}
	}
}