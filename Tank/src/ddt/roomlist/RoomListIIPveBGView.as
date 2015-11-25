package ddt.roomlist
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomlistII.PveRoomListIIBGAsset;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.RoomInfo;
	import ddt.data.SimpleRoomInfo;
	import ddt.events.RoomEvent;
	import ddt.manager.BossBoxManager;
	import ddt.manager.DownlandClientManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.common.WaitingView;

	public class RoomListIIPveBGView extends PveRoomListIIBGAsset implements IRoomListBGView
	{
		private var _list:SimpleGrid;
		
		private var _model:IRoomListIIModel;
		
		private var _sortbtns:Array;
		private var _tempDataList:Array;
		
		private var maplist_Btn:HBaseButton;
		private var RoomMode_Btn:HBaseButton;
		private var hardLevel_Btn:HBaseButton;
//		private var _currentSortTipBtn:HBaseButton;
		
		private var _passinput:RoomListIIPassInput;
		private var nextBtn:HBaseButton;
		private var preBtn:HBaseButton;
		
		private var _MapTip:RoomListIIMapSortTipPanel;
		private var _RoomModeTip:RoomListIIRoomModeTipSort;
		private var _hardLevelTip:RoomListIIModeSortTipPanel;
		private var _autoType:int;
		
		private var _boxButton:SmallBoxButton;
		
		private static const PAGE_COUNT:int = 9;
		private static const IS_PVE:Boolean = true;
		private static const SORT_TYPES:Array = ["ID","Name","mapId","roomType","hardLevel","placeCount"];
		
		private var currentPage:int = 1;
		private var currentType:int = 0; //当前类型 0 ID 1房间名称 2地图名称 3房间模式 4是难度等级 5人数
		
		private var refreshTimer:Timer;
		public function RoomListIIPveBGView(model:IRoomListIIModel)
		{
			 _model=model;
			 init();
			 initEvent();
		}
		
		private function init():void
		{
			refreshTimer = new Timer(1500,1);
			refreshTimer.start();
			
			var severName : String = String(ServerManager.Instance.current.Name);	
			var num : int = severName.indexOf("(");
			num = num == -1 ? severName.length : num;
			svrname_txt.text = severName.substr(0,num);
			
			_sortbtns = [];
			for(var i:uint;i<=5;i++)//这里是5
			{
				var titlebt:HBaseButton = new HBaseButton(this["sortBtn"+i]);
				titlebt.useBackgoundPos = true;
				addChild(titlebt);
				_sortbtns.push(titlebt);
			}
			maplist_Btn  = new HBaseButton(maplistBtn);
			maplist_Btn.useBackgoundPos = true;
			addChild(maplist_Btn);
			
			RoomMode_Btn = new HBaseButton(RoomModeBtn);
			RoomMode_Btn.useBackgoundPos = true;
			addChild(RoomMode_Btn);
			
			hardLevel_Btn= new HBaseButton(hardLevelBtn);
			hardLevel_Btn.useBackgoundPos = true;
			addChild(hardLevel_Btn);
			
			nextBtn = new HTipButton(nextBtnAccect,"",LanguageMgr.GetTranslation("nextPage"));
			nextBtn.useBackgoundPos = true;
			addChild(nextBtn);

			preBtn = new HTipButton(preBtnAccect,"",LanguageMgr.GetTranslation("prePage"));
			preBtn.useBackgoundPos = true;
			addChild(preBtn);
			
			_list = new SimpleGrid(615,31);
			_list.verticalScrollPolicy = ScrollPolicy.OFF;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.cellPaddingHeight = 0;
			
			ComponentHelper.replaceChild(this,roomlist_pos,_list);
			
			maptip_pos.visible = RoomMode_pos.visible = hardLevel_pos.visible = false;	
			_MapTip = new RoomListIIMapSortTipPanel(this);
			ComponentHelper.replaceChild(this,maptip_pos,_MapTip);
				
			_RoomModeTip = new RoomListIIRoomModeTipSort(this);
			ComponentHelper.replaceChild(this,RoomMode_pos,_RoomModeTip);
			
			_hardLevelTip = new RoomListIIModeSortTipPanel(this);
			ComponentHelper.replaceChild(this,hardLevel_pos,_hardLevelTip);
			
			_MapTip.visible = _RoomModeTip.visible = _hardLevelTip.visible =false;
			
//			page_txt.text = "1/1";
//			page_txt.mouseEnabled = false;
//			page_txt.selectable = false;
			preBtn.visible = nextBtn.visible = true;
			_tempDataList = currentDataList;
			
			DownlandClientManager.Instance.show(this);
			DownlandClientManager.Instance.setDownlandBtnPos(new Point(downBtnPos.x,downBtnPos.y));
			removeChild(downBtnPos);
			
			if(BossBoxManager.instance.isShowBoxButton())
			{
				_boxButton = new SmallBoxButton();
				_boxButton.x = _smallBoxButton.x;
				_boxButton.y = _smallBoxButton.y;
				BossBoxManager.instance.smallBoxButton = _boxButton;
				addChild(_boxButton);
			}
		}
		
		private function initEvent():void
		{
			_model.getRoomList().addEventListener(DictionaryEvent.ADD,__addRoomItem);
			_model.getRoomList().addEventListener(DictionaryEvent.REMOVE,__removeRoomItem);
			_model.addEventListener(RoomListIIModel.ROOMSHOWMODE_CHANGE,__roomShowModeChange);
			_model.getRoomList().addEventListener(DictionaryEvent.CLEAR,__clearRoomItem);
			for each(var i:RoomInfo in _model.getRoomList())
			{
				i.addEventListener(RoomEvent.CHANGED,__roomUpdate);
			}
			
			for(var j:uint = 0; j<=5/*_sortbtns.length*/ ;j++)
			{
				_sortbtns[j].addEventListener(MouseEvent.CLICK , __sortBtnClick);
			}
			
			maplist_Btn.addEventListener(MouseEvent.CLICK , __showSortTip);
			RoomMode_Btn.addEventListener(MouseEvent.CLICK , __showSortTip);
			hardLevel_Btn.addEventListener(MouseEvent.CLICK , __showSortTip);
			
			nextBtn.addEventListener(MouseEvent.CLICK,__nextClick);
			preBtn.addEventListener(MouseEvent.CLICK,__preClick);
			
			refreshTimer.addEventListener(TimerEvent.TIMER ,__refreshCurrentPage);
		}
		
		private function __refreshCurrentPage(e:TimerEvent):void
		{
			updatePage(currentPage,currentType);
			refreshTimer.stop();
		}
		
		private function __sortBtnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			currentType = _sortbtns.indexOf(evt.currentTarget);
			updatePage(1,currentType,true);
			closeSortTip();
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.DUNGEON_LIST,lookupEnumerate.DUNGEON_LIST_DEFAULT);
		}
		
		private function __showSortTip(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_MapTip.visible && evt.currentTarget != maplist_Btn)
			{
				_MapTip.visible = false;
			}
			if(_RoomModeTip.visible && evt.currentTarget != RoomMode_Btn)
			{
				_RoomModeTip.visible = false;
			}
			if(_hardLevelTip.visible && evt.currentTarget != hardLevel_Btn)
			{
				_hardLevelTip.visible = false;
			}
			if(evt.currentTarget == maplist_Btn)
			{
				_MapTip.visible = _MapTip.visible ? false:true;
			}
			else if(evt.currentTarget == RoomMode_Btn)
			{
				_RoomModeTip.visible = _RoomModeTip.visible ? false:true;
			}
			else// if(evt.currentTarget == hardLevelBtn)
			{
				_hardLevelTip.visible = _hardLevelTip.visible ? false:true;
			}
		}
		
		private function __nextClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(currentPage+1,currentType);
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.DUNGEON_LIST,lookupEnumerate.DUNGEON_LIST_DEFAULT);
		}
		
		private function __nextMoreClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(totalPage,currentType);
		}
		
		private function __preClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(currentPage-1,currentType);
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.DUNGEON_LIST,lookupEnumerate.DUNGEON_LIST_DEFAULT);
		}
		
		private function __preMoreClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(1,currentType);
		}
		
		private function __clearRoomItem(evt:DictionaryEvent):void
		{
			clearList();
		}
		
		private function __addRoomItem(evt:DictionaryEvent):void
		{
			if(_list.itemCount >= PAGE_COUNT) 
			{
				updatePageText();
				updatePageBtnEnable();
				return;
			}
			var info:SimpleRoomInfo = evt.data as SimpleRoomInfo;
			trace(info.ID);
			info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomUpdate);
//			if(_model.roomShowMode == 1 && info.isPlaying) return;
//			var item:RoomListIIRoomItemView = new RoomListIIRoomItemView(info);
			var item:RoomListIIPveRoomItemView = new RoomListIIPveRoomItemView(info);
			if(info.isPlaying)			
				_list.appendItem(item);
			else
				_list.appendItemAt(item,0);
			item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
			if(_model.isAddEnd)
			{
				upadteItemPos();
			}
			updatePageText();
			updatePageBtnEnable();
			
		}
		
		private function __removeRoomItem(evt:DictionaryEvent):void
		{
			var info:SimpleRoomInfo = evt.data as SimpleRoomInfo;
			info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomUpdate);
			var item:RoomListIIPveRoomItemView = _list.getItem("ID",info.ID) as RoomListIIPveRoomItemView;
			if(item)
			{
				_list.removeItem(item);
				item.removeEventListener(MouseEvent.CLICK,__itemClick,false);
				item.dispose();
				item = null;
				_tempDataList = currentDataList;
				updateList();
			}
			if(_list.itemCount == 0 && currentPage != 1)
			{
				updatePage(currentPage-1,currentType);
				return;
			}
			updatePageBtnEnable();
			updatePageText();
		}
		
		private function __roomUpdate(evt:Event):void
		{
			var info:SimpleRoomInfo = evt.currentTarget as SimpleRoomInfo;
			var item:RoomListIIPveRoomItemView = _list.getItem("id",info.ID) as RoomListIIPveRoomItemView;
			if(item != null)
			{
				if(_model.roomShowMode == 1 && info.isPlaying)
					_list.removeItem(item);
			}
			else
			{
				if(!(_model.roomShowMode == 1 && info.isPlaying))
				{
					var t:RoomListIIPveRoomItemView = new RoomListIIPveRoomItemView(info);
					_list.appendItem(t);
					t.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
				}
			}
			
			if(_list.itemCount == 0 && currentPage != 1)
			{
				updatePage(currentPage-1,currentType);
				return;
			}
		}
		
		private function __roomShowModeChange(evt:Event):void
		{
			_list.clearItems();
			var roomlist:DictionaryData = _model.getRoomList();
			for each(var i:SimpleRoomInfo in roomlist)
			{
				if(_list.itemCount >PAGE_COUNT) 
				{
					break;
				}
				var item:RoomListIIPveRoomItemView = new RoomListIIPveRoomItemView(i);
				_list.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
			}
			updatePage(1,currentType);
		}
		
		public function closeSortTip():void
		{
			_MapTip.visible = _RoomModeTip.visible = _hardLevelTip.visible =false;
//			_currentSortTipBtn = null;
		}
		
		private function updatePage(page:int,type:int,needSort:Boolean = false):void
		{
			_tempDataList = currentDataList;
			if(page<1) return;
			if(needSort)
			{
				sortDataList(type);
			}
			var roomlist:DictionaryData = _model.getRoomList();
			if(roomlist.length > ((page-1) * PAGE_COUNT))
			{
				currentPage = page;
				updatePageText();
			}else
			{
				return;
			}
			updateList();
			updatePageBtnEnable();
		}
		
		private function updatePageText():void
		{
			if(currentPage >totalPage)
			{
				updatePage(totalPage,currentType);
			}
//			page_txt.text = currentPage+"/"+totalPage.toString();
		}
		
		public function updateList():void
		{
			clearList();
			var roomlist:Array = _tempDataList;
			var j:int = 0;
			for each(var i:SimpleRoomInfo in roomlist)
			{
				if(j< (currentPage-1)*PAGE_COUNT) 
				{
					j++;
					continue;
				}
				if(j> currentPage*PAGE_COUNT) break;
//				if(_model.roomShowMode == 1 && i.isPlaying)continue;
				var item:RoomListIIPveRoomItemView = new RoomListIIPveRoomItemView(i);
				_list.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
				j++;
			}
		}
		
		private function clearList():void
		{
			if(_list)
			{
				for each(var item:RoomListIIPveRoomItemView in _list.items)
				{
					if(!item)return;
					item.dispose();
					item.removeEventListener(MouseEvent.CLICK,__itemClick,false);
					item = null;
				}
				_list.clearItems();
			}
		}
		
		private function updatePageBtnEnable():void
		{
			currentPage = (currentPage < 1 ? 1 : currentPage)
		}
		
		public function sortDataList(type:int):void
		{
			_tempDataList = currentDataList;
			if(type==0 || type==2 || type==3 || type==4 || type==5)
			{
				_tempDataList.sortOn(SORT_TYPES[type],Array.NUMERIC);
				if(_autoType == 0)
					_tempDataList.reverse();
				_autoType = (_autoType == 0 ? 1 : 0);
			}else
			{
				if(_autoType == 1)
				{
					_tempDataList.sortOn(SORT_TYPES[type],Array.CASEINSENSITIVE);
				}
				else
				{
					_tempDataList.sortOn(SORT_TYPES[type],Array.DESCENDING);
				}
				_autoType = (_autoType == 0 ? 1 : 0);
			}
		}
		
		public function sortT(items:Array,key:String,value:*):void
		{
			_tempDataList = items;
			for(var i:int = 0; i < _tempDataList.length; i++)
			{
				if(_tempDataList[i][key] == value)
				{
					_tempDataList.unshift(_tempDataList.splice(i,1)[0]);
				}
			}
		}
		
		public function get dataList():DictionaryData
		{
			return _model.getRoomList();
		}
		
		public function get totalPage():int
		{
			if(currentDataList.length == 0) return 1;
			return Math.ceil(currentDataList.length/PAGE_COUNT);
		}
		
		public function get currentDataList():Array
		{
			if(_model.roomShowMode == 1 && _model.getRoomList().list)
			{
//				var arr : Array = _model.getRoomList().filter("isPlaying",false);
//				var arr2 : Array = _model.getRoomList().filter("isPlaying",true);
//				if(arr && arr2)arr.concat(arr2);
				return _model.getRoomList().filter("isPlaying",false).concat(_model.getRoomList().filter("isPlaying",true));;
			}
			return _model.getRoomList().list;
		}
		
		private var selectItemPos:int;
		private var selectItemID:int;
		
		private function __itemClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			gotoIntoRoom((evt.currentTarget as RoomListIIPveRoomItemView).info);
			getSelectItemPos((evt.currentTarget as RoomListIIPveRoomItemView).ID);
		}
		
		private function getSelectItemPos(id:int):int
		{
			if(!_list)return 0;
			for(var i:int = 0 ; i<_list.items.length ; i++)
			{
				if(!(_list.items[i] as RoomListIIPveRoomItemView))return 0;
				if( (_list.items[i] as RoomListIIPveRoomItemView).ID == id )
				{
					selectItemPos = i;
					selectItemID  = (_list.items[i] as RoomListIIPveRoomItemView).ID;
					return i;
				}
			}
			return 0;
		}
		
		private function getInfosPos(id:int):int
		{
			_tempDataList = currentDataList;
			if(!_tempDataList)return 0;
			for(var i:int = 0 ; i<_tempDataList.length ; i++)
			{
				if( (_tempDataList[i] as SimpleRoomInfo).ID == id )
				{
					return i;
				}
			}
			return 0;
		}
		
		private function upadteItemPos():void
		{
			_tempDataList = currentDataList;
			if(_tempDataList)
			{
				var temInfo:SimpleRoomInfo = _tempDataList[selectItemPos];
				var tempos:int = getInfosPos(selectItemID);
				_tempDataList[selectItemPos] = _tempDataList[tempos];
				_tempDataList[tempos] = temInfo;
				clearList();
				for each(var info:SimpleRoomInfo in _tempDataList)
				{
					if(!info)return;
					var item:RoomListIIPveRoomItemView = new RoomListIIPveRoomItemView(info);
					_list.appendItem(item);
					item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
				}
			}
		}
		
		public function gotoIntoRoom(info:SimpleRoomInfo):void
		{
			SoundManager.instance.play("008");
			SocketManager.Instance.out.sendGameLogin(2,-1,info.ID,"");
		}
		
		public function get IsPve():Boolean
		{
			return true;
		}
		
		public function dispose():void
		{
			_model.getRoomList().removeEventListener(DictionaryEvent.ADD,__addRoomItem);
			_model.getRoomList().removeEventListener(DictionaryEvent.REMOVE,__removeRoomItem);
			_model.removeEventListener(RoomListIIModel.ROOMSHOWMODE_CHANGE,__roomShowModeChange);
			_model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,__clearRoomItem);
			var list :DictionaryData = _model.getRoomList();
			for each(var i:SimpleRoomInfo in list)
			{
				i.removeEventListener(RoomEvent.CHANGED,__roomUpdate);
			}
			list = null;
			
			for each(var item:HBaseButton in _sortbtns)
			{
				item.removeEventListener(MouseEvent.CLICK , __sortBtnClick);
				item.dispose();
			}
			_sortbtns = null;
			
			maplist_Btn.removeEventListener(MouseEvent.CLICK , __showSortTip);
			RoomMode_Btn.removeEventListener(MouseEvent.CLICK , __showSortTip);
			hardLevel_Btn.removeEventListener(MouseEvent.CLICK , __showSortTip);
			
			nextBtn.removeEventListener(MouseEvent.CLICK,__nextClick);
			preBtn.removeEventListener(MouseEvent.CLICK,__preClick);
			
			refreshTimer.removeEventListener(TimerEvent.TIMER ,__refreshCurrentPage);
			refreshTimer.reset();
			refreshTimer = null;
			
			nextBtn.dispose();
			preBtn.dispose();
			
			nextBtn = null;
			preBtn = null;
			
			if(_list)
			{
				for each(var roomitem:RoomListIIPveRoomItemView in _list.items)
				{
					roomitem.removeEventListener(MouseEvent.CLICK,__itemClick,false);
					roomitem.dispose();
					roomitem = null;
				}
				_list.clearItems();
				if(_list.parent)
					_list.parent.removeChild(_list);
			}
			_list = null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
			
			_MapTip.dispose();
			_RoomModeTip.dispose();
			_hardLevelTip.dispose();
			
			_MapTip = null;
			_RoomModeTip = null;
			_hardLevelTip = null;
			
//			_currentSortTipBtn = null;

			DownlandClientManager.Instance.hide();
			_model = null;
			
			if(_passinput)
				_passinput.dispose();
			_passinput = null;
			
			if(parent)
				parent.removeChild(this);
		}

	}
}