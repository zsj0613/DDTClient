package ddt.room
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.crazyTank.view.roomII.DuplicateDropListAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.SimpleGrid;
	import road.utils.ComponentHelper;
	
	import ddt.data.DungeonInfo;
	import ddt.data.RoomInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.events.RoomEvent;
	import ddt.game.map.MapShowIcon;
	import ddt.manager.GameManager;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MapManager;
	import ddt.manager.ShopManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.view.common.VerticalScaleFrame;

	public class DuplicateInfoPanel extends DuplicateDropListAsset
	{
		private var _list : SimpleGrid;
		private var _room : RoomInfo;
		private var _context : DuplicateContextPane;
		private var _showIcon : MapShowIcon;
		private var _helpBtn  : HTipButton;
		private var _noteBtn  : HTipButton;
		private var _DropList:Array;
		private var _vertic:VerticalScaleFrame;
		private var _isShowIco:Boolean;
		private var _isShowHelp:Boolean;
		private var _isShowDrop:Boolean;
		private var _isShowNote:Boolean;
		private var _missionPic : String;
		public static const OPEN_NOTE:String = "OpenNote";
		public static const OPEN_ROOMSET:String = "OpenRoomSet";
		
		public function DuplicateInfoPanel($room : RoomInfo,$missionPic:String="show1.jpg")
		{
			super();
			_room = $room;
			_missionPic = $missionPic;
			init();
			initEvent()
			__upListHandler(null);
		}
		private function init() : void
		{
			this.helpBtn.gotoAndStop(1);
			this.noteBtn.gotoAndStop(1);
			_helpBtn = new HTipButton(this.helpBtn,"",LanguageMgr.GetTranslation("ddt.room.explanation"));
			_helpBtn.useBackgoundPos = true;
			
			_context = new DuplicateContextPane();
			_context.y = _helpBtn.y + 45;
			_context.x = _helpBtn.x - 196;  
			addChild(_context);
			
			_showIcon = new MapShowIcon(_room.mapId,_missionPic);
			_showIcon.mouseEnabled = false;
			_showIcon.x = 53;
			_showIcon.y = 68;
			addChildAt(_showIcon,0);
			
			_list = new SimpleGrid(50,50,5);
			_list.horizontalScrollPolicy = "0ff";//on
			_list.verticalScrollPolicy   = "auto";
			_list.verticalLineScrollSize = 50;
			var list_pos:Point = caloricPos.localToGlobal(new Point(caloricPos.listPos.x,caloricPos.listPos.y));
			ComponentHelper.replaceChild(caloricPos,caloricPos.listPos,_list);
			caloricPos.addChild(_list);
			
			_noteBtn = new HTipButton(this.noteBtn,"",LanguageMgr.GetTranslation("ddt.room.statistics"));
			_noteBtn.useBackgoundPos = true;
			
			
			addChild(_noteBtn);
			_context.visible = true;
			
			addChild(_helpBtn);
			
			_vertic = new VerticalScaleFrame(caloricPos.DuplicateDropListBG_mc.topFrame,caloricPos.DuplicateDropListBG_mc.middleFrame,caloricPos.DuplicateDropListBG_mc.bottomFame);
			if(getIsHost())
			{
				choicePos.buttonMode = true;
				
			}else
			{
				choicePos.buttonMode = false;
			}
			_isShowIco = false;
		}
		
		public function set btnButtonMode(value:Boolean):void
		{
			choicePos.buttonMode = value;
		}
		
		public function set isShowhelp(value:Boolean):void
		{
			_isShowHelp = value;
			if(_helpBtn)_helpBtn.visible = _isShowHelp;	
			if(bottom_1)bottom_1.visible = _isShowHelp;
		}
		
		public function set isShowIco(value:Boolean):void
		{
			_isShowIco = value;
		}
		
		public function set showDrop(value:Boolean):void
		{
			_isShowDrop = value;
			caloricPos.visible = _isShowDrop;
		}
		
		public function get showDrop():Boolean
		{
			return _isShowDrop;
		}
		
		private function initEvent():void
		{
			addEventListener(Event.ADDED_TO_STAGE,__onAddtoStage);
			_helpBtn.addEventListener(MouseEvent.CLICK , __onOpenHelp);
			_noteBtn.addEventListener(MouseEvent.CLICK , __onOpenNote);
			_room.addEventListener(RoomEvent.CHANGED, __upListHandler);
			this.helpBtn.addEventListener(MouseEvent.MOUSE_OVER , __buttonOver);
			this.noteBtn.addEventListener(MouseEvent.MOUSE_OVER , __buttonOver);
			this.helpBtn.addEventListener(MouseEvent.MOUSE_OUT , __buttonOut);
			this.noteBtn.addEventListener(MouseEvent.MOUSE_OUT , __buttonOut);
			choicePos.addEventListener(MouseEvent.MOUSE_OVER, __showChoiceIco);
			choicePos.addEventListener(MouseEvent.MOUSE_OUT , __cancelChoiceIco);
			choicePos.addEventListener(MouseEvent.CLICK , __ChoiceIcoClick);
		}
		
		private function removeEvent():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__onAddtoStage);
			_helpBtn.removeEventListener(MouseEvent.CLICK , __onOpenHelp);
			_noteBtn.removeEventListener(MouseEvent.CLICK , __onOpenNote);
			_room.removeEventListener(RoomEvent.CHANGED, __upListHandler);
			this.helpBtn.removeEventListener(MouseEvent.MOUSE_OVER , __buttonOver);
			this.noteBtn.removeEventListener(MouseEvent.MOUSE_OVER , __buttonOver);
			this.helpBtn.removeEventListener(MouseEvent.MOUSE_OUT , __buttonOut);
			this.noteBtn.removeEventListener(MouseEvent.MOUSE_OUT , __buttonOut);
			choicePos.removeEventListener(MouseEvent.MOUSE_OVER, __showChoiceIco);
			choicePos.removeEventListener(MouseEvent.MOUSE_OUT , __cancelChoiceIco);
			choicePos.removeEventListener(MouseEvent.CLICK , __ChoiceIcoClick);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMoveHandler);
		}
		
		public function updateDescription(value:String):void
		{
			_context.context = value;
		}
		
		private function __hostLeave(evt:RoomEvent):void
		{
			_room.mapId = 10000;
		}
		
		private function __onAddtoStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,__onAddtoStage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,__mouseMoveHandler);
		}
		
		public function set isShowNote(value:Boolean):void
		{
			_isShowNote = value;
			_noteBtn.visible = _isShowNote;
			bottom_2.visible= _isShowNote;
			_noteBtn.visible = _isShowNote;
//			noteBtn.removeEventListener(MouseEvent.MOUSE_OVER,__buttonOver);
//			noteBtn.addEventListener(MouseEvent.MOUSE_OUT , __buttonOut);
		}
		
		public function set noteEnable(value:Boolean):void
		{
			if(!_noteBtn)return;
			_noteBtn.enable = value;
			if(!value)
			noteBtn.removeEventListener(MouseEvent.MOUSE_OVER,__buttonOver);
			else
			noteBtn.addEventListener(MouseEvent.MOUSE_OVER,__buttonOver);
		}
		
		public function SetMouseMoveListen():void
		{
			if(stage)stage.addEventListener(MouseEvent.MOUSE_MOVE,__mouseMoveHandler);
		}
		
		public function setMouseMoveUnListen():void
		{
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_MOVE,__mouseMoveHandler);
		}
		
		private var _listResizeState:int = 0;
		private function __mouseMoveHandler(event:MouseEvent):void
		{
			var listStartPoint:Point = caloricPos.localToGlobal(new Point(caloricPos.listPos.x,caloricPos.listPos.y));
			var listEndingPoint:Point = new Point(listStartPoint.x+caloricPos.listPos.width,listStartPoint.y+53);
			var listOutspreadPoint:Point = new Point(listStartPoint.x+caloricPos.listPos.width+20,listStartPoint.y+68);
			var listFitStartPoint:Point = new Point(listStartPoint.x-20,listStartPoint.y - 62);
			var sourcePt:Point = new Point(event.stageX,event.stageY);
			if(_listResizeState == 0)
			{
				if(!isOutof2Point(sourcePt,listStartPoint,listEndingPoint))
				{
					_listResizeState = 1;
					__choicePosOver(null);
				}
			}else if(_listResizeState == 1)
			{
				if(isOutof2Point(sourcePt,listFitStartPoint,listOutspreadPoint))
				{
					_listResizeState = 0;
					__choicePosOut(null);
				}
			}
			event.updateAfterEvent();
		}
		
		private function isOutof2Point(soursePt:Point,pt1:Point,pt2:Point):Boolean
		{
			if(soursePt.x < pt1.x || soursePt.x > pt2.x ||
				soursePt.y < pt1.y || soursePt.y > pt2.y)
			{
				return true;
			}
			return false;
		}
		
		private function __showChoiceIco(evt:MouseEvent):void
		{
			if(_room.roomType<2 || !_isShowIco || !getIsHost() || _room.roomState == RoomInfo.STATE_PICKING )return;
			choicePos.choiceIco.visible = true;
//			becloud_mc.visible = true;
		}
		
		private function __cancelChoiceIco(evt:MouseEvent):void
		{
			if(_room.roomType<2 || !_isShowIco || !getIsHost() || _room.mapId == 10000)return;
			choicePos.choiceIco.visible = false;
//			becloud_mc.visible = false;
		}
		
		private function __ChoiceIcoClick(evt:MouseEvent):void
		{
			if(_room.roomType<2 || !_isShowIco || _room.roomState == RoomInfo.STATE_PICKING || !getIsHost())return;
			dispatchEvent(new Event(OPEN_ROOMSET));
		}
		
		private function getIsHost():Boolean
		{
			for(var i:int;i <_room.players.length;i++)
			{
				if(_room.players.list[i].isSelf == true && _room.players.list[i].isHost)
				{
					return true;
				}else
				{
					return false;
				}
			}
			return false;
		}
		
		private function __resizeHander(event:Event):void
		{
			_list.graphics.clear();
			_list.graphics.beginFill(0xff00ff,0);
			_list.graphics.drawRect(-3,-3,_list.width+6,_list.height+8);
			_list.graphics.endFill();
		}
		
		private function __buttonOver(evt:MouseEvent):void
		{
			if(evt.currentTarget.name == "helpBtn" && _isShowHelp)
			{
				helpBtn.gotoAndStop(2);
				SoundManager.instance.play("119");
			}
			else if(_isShowNote)
			{
				noteBtn.gotoAndStop(2);
				SoundManager.instance.play("119");
			}
		}
		
		private function __buttonOut(evt:MouseEvent):void
		{
			if(evt.currentTarget.name == "helpBtn")
			helpBtn.gotoAndStop(1);
			else 
			noteBtn.gotoAndStop(1);
		}

		private function __choicePosOver(evt:Event):void
		{
			if(!_DropList || _DropList.length <= 5)return;
			_vertic.setHeight(150);//150
			caloricPos.DuplicateDropListBG_mc.y = 47;//146
			_list.y=caloricPos.listPos.y-53;
			_list.height = 105;
			_list.graphics.clear();
			_list.graphics.beginFill(0xff00ff,0);
			_list.graphics.drawRect(-30,-45,_list.width+60,_list.height+60);
			_list.graphics.endFill();
		}
		
		private function __choicePosOut(evt:Event):void
		{
			_vertic.setHeight(97);
			caloricPos.DuplicateDropListBG_mc.y = 100;
			_list.y = caloricPos.listPos.y;
			_list.height = 53;
			
			_list.graphics.clear();
			_list.graphics.beginFill(0xff00ff,0);
			_list.graphics.drawRect(-3,-3,_list.width+6,_list.height+8);
			_list.graphics.endFill();
		}
		
		private function __onOpenNote(evt:MouseEvent):void
		{
			SoundManager.instance.play("045");
			dispatchEvent(new Event(OPEN_NOTE));
		}
		
		private function __onOpenHelp(evt : MouseEvent) : void
		{
			SoundManager.instance.play("045");
			_context.switchPane();
		}
		
		private function __upListHandler(evt : RoomEvent = null ) : void
		{
			_DropList = [];
			var info : DungeonInfo = MapManager.getDungeonInfo(_room.mapId);
			clearList();
			isShowNote = true;
	    	isShowhelp = true;
	    	caloricPos.visible = true;
			if(!info)
			{
				if(_room.mapId == 10000)
				{
					if(StateManager.currentStateType == StateType.MISSION_RESULT)return;
					_showIcon.id = _room.mapId;
					isShowNote = false;
			    	isShowhelp = false;
			    	caloricPos.visible = false;
			    	if(_context)_context.affiche_mc.gotoAndStop("in");
				}
				if(_showIcon)
				_showIcon.id = 10000;
				return;
			}
			var templateIds : String = getTemplateIds(_room.hardLevel,info);
			if(templateIds == null || templateIds == "")return;
			_DropList = templateIds.split(",");
			for(var i:int=0;i<_DropList.length;i++)
			{
				var item : DuplicateDropCell = new DuplicateDropCell();
				item.info = getTemplateInfo(_DropList[i]);
				item.width  = 50;
				item.height = 60;
				_list.appendItem(item);
			}
			if(_showIcon.id != info.ID)
			{
				_showIcon.id = info.ID;
			}
			
			if(GameManager.Instance.Current == null)
			{
				if(_context)
				{
					removeChild(_context);
					_context.dispose();
					_context = null;
				}
				_context = new DuplicateContextPane();
				_context.y = _helpBtn.y + 45;
				_context.x = _helpBtn.x - 196;  
				addChild(_context);
				_context.context = info.Description;
			}
			_context.visible = false;
		}
		
		private function getTemplateInfo(id : int) : ItemTemplateInfo
		{
			var shopInfo : ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(id);
			if(shopInfo)return shopInfo.TemplateInfo;
			var itemInfo : InventoryItemInfo = new InventoryItemInfo();
			itemInfo.TemplateID = id;
			itemInfo.IsJudge = true;
			ItemManager.fill(itemInfo);
			return itemInfo;
		}
		//取不同难度的物品掉落表
		private function getTemplateIds(p : int,$info : DungeonInfo) : String
		{
			if(p == 1)
			{
				return $info.NormalTemplateIds;
			}
			else if(p ==2 )
			{
				return $info.HardTemplateIds;
			}
			else if(p == 3)
			{
				return $info.TerrorTemplateIds;
			}
			return $info.SimpleTemplateIds;
		}
		private function clearList() : void
		{
			if(_list)
			{
				for each(var item : DuplicateDropCell in _list.items)
				{
					item.removeEventListener(Event.CHANGE, __choicePosOver);
					item.removeEventListener(Event.COMPLETE, __choicePosOut);
					item.dispose();
					item = null;
				}
				_list.clearItems();
			}
		}
		
		public function dispose() : void
		{
			removeEvent();
			
			clearList();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
			
			if(helpBtn && helpBtn.parent)
			{
				helpBtn.parent.removeChild(helpBtn);
			}
			helpBtn = null;
			
			if(_helpBtn)
			{
				_helpBtn.dispose();
			}
			_helpBtn = null;
			
			if(_noteBtn)
			{
				_noteBtn.dispose();
			}
			_noteBtn = null;
			
			if(_context)
			{
				_context.dispose();
			}
			_context = null;
			
			if(noteBtn && noteBtn.parent)
			{
				noteBtn.parent.removeChild(noteBtn);
			}
			noteBtn = null;
			
			if(_room)
			{
				_room.removeEventListener(RoomEvent.CHANGED, __upListHandler);
			}
			_room = null;

			if(caloricPos && caloricPos.parent)
				caloricPos.parent.removeChild(caloricPos);
			caloricPos = null;
			
			if(choicePos && choicePos.parent)
				choicePos.parent.removeChild(choicePos);
			choicePos = null;
			
			if(_showIcon)
				_showIcon.dispose();
			_showIcon = null;
			
			if(_vertic)
				_vertic.dispose();
			_vertic = null;
			
			_DropList = null;
			
			if(this.parent)
				this.parent.removeChild(this);
		}
		
	}
}