package ddt.roomlist
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.crazyTank.view.roomlistII.RoomListIIBGAsset;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HTipButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import tank.assets.ScaleBMP_12;
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
	import ddt.utils.DisposeUtils;
	import ddt.view.bossbox.SmallBoxButton;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.WaitingView;
	
	/**
	 * 房间列表模块
	 * @author Administrator
	 * 
	 */	
	public class RoomListIIBGView extends RoomListIIBGAsset implements IRoomListBGView
	{
		private var _list:SimpleGrid;
		private var _model:IRoomListIIModel;
		private var _passinput:RoomListIIPassInput;
		private var _sortbtns:Array;
		private var _sortType:int;
		private var _autoType:int;
//		private var _maptip:RoomListIIMapSortTipPanel;
		private var _modetip:RoomListIIModeSortTipPanel;
		private var _roomModetip:RoomListIIRoomModeTipSort;
		
		private var _boxButton:SmallBoxButton;
		
//		private var map_list_btn:HBaseButton;
//		private var round_list_btn:HBaseButton;
		private var mode_list_btn:HBaseButton;
		private var room_mode_btn:HBaseButton;
		
		private var nextBtn:HBaseButton;
		private var nextMoreBtn:HBaseButton;
		private var preBtn:HBaseButton;
		private var preMoreBtn:HBaseButton;
		
		private static const PAGE_COUNT:int = 9;
		private static const SORT_TYPES:Array = ["ID","Name","roomType","mapId","timeType","gameMode","placeCount"];
		
		private static const IS_PVE:Boolean = false;
		
		private var currentPage:int = 1;
		private var currentType:int = 0;
		
		private var _tempDataList:Array;
		
		private var refreshTimer:Timer;
		
		private var _bottomBMP:ScaleBMP_12;
		
		public function RoomListIIBGView(model:IRoomListIIModel)
		{
			_model = model;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			refreshTimer = new Timer(1500,1);
			refreshTimer.start();
			
			_bottomBMP = new ScaleBMP_12();
			addChildAt(_bottomBMP,0);
			_bottomBMP.x = pos_1.x;
			_bottomBMP.y = pos_1.y-5;
			removeChild(pos_1);
			var severName : String = String(ServerManager.Instance.current.Name);	
			var num : int = severName.indexOf("(");
			num = num == -1 ? severName.length : num;
			svrname_txt.text = severName.substr(0,num);
			
			BellowStripViewII.Instance.enabled = true;
			BellowStripViewII.Instance.visible = true;
		
			_sortbtns = [];
			for(var i:uint;i<5;i++)
			{
				var titlebt:HBaseButton = new HBaseButton(this["sortBtn"+i]);
				titlebt.useBackgoundPos = true;
				addChild(titlebt);
				_sortbtns.push(titlebt);
			}
		
			mode_list_btn = new HBaseButton(patternlistbtn);
			mode_list_btn.useBackgoundPos = true;
			addChild(mode_list_btn);
			
			room_mode_btn = new HBaseButton(roomtypebtn);
			room_mode_btn.useBackgoundPos = true;
			addChild(room_mode_btn);
			
			nextBtn = new HTipButton(nextBtnAccect,"",LanguageMgr.GetTranslation("nextPage"));
			//nextBtn = new HTipButton(nextBtnAccect,"","下一页");
			nextBtn.useBackgoundPos = true;
			addChild(nextBtn);
			
			preBtn = new HTipButton(preBtnAccect,"",LanguageMgr.GetTranslation("prePage"));
			//preBtn = new HTipButton(preBtnAccect,"","上一页");
			preBtn.useBackgoundPos = true;
			addChild(preBtn);
			
			
			
			_list = new SimpleGrid(615,31);
			_list.verticalScrollPolicy = ScrollPolicy.OFF;
			_list.horizontalScrollPolicy = ScrollPolicy.OFF;
			_list.cellPaddingHeight = 0;
			ComponentHelper.replaceChild(this,roomlist_pos,_list);
			_sortType = -1;
			modetip_pos.visible = false;
			_modetip = new RoomListIIModeSortTipPanel(this);
			ComponentHelper.replaceChild(this,modetip_pos,_modetip);
			_roomModetip = new RoomListIIRoomModeTipSort(this);
			ComponentHelper.replaceChild(this,roommode_pos,_roomModetip);
		
			_modetip.visible = _roomModetip.visible = false;
//			page_txt.text = "1/1";
//			page_txt.mouseEnabled = false;
//			page_txt.selectable = false;
			preBtn.visible = nextBtn.visible = true;
			_tempDataList = currentDataList;
			
			DownlandClientManager.Instance.show(this);
			DownlandClientManager.Instance.setDownlandBtnPos(new Point(downBtnpos.x,downBtnpos.y));
			removeChild(downBtnpos);
			
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
			_model.getRoomList().addEventListener(DictionaryEvent.CLEAR,__clearRoomItem);
			_model.addEventListener(RoomListIIModel.ROOMSHOWMODE_CHANGE,__roomShowModeChange);
			for each(var i:RoomInfo in _model.getRoomList())
			{
				i.addEventListener(RoomEvent.CHANGED,__roomUpdate);
			}
			
			for(var j:uint = 0;j<5;j++)
			{
				_sortbtns[j].addEventListener(MouseEvent.CLICK,__sortBtnClick);
			}
			
			mode_list_btn.addEventListener(MouseEvent.CLICK,__showSortTip);
			room_mode_btn.addEventListener(MouseEvent.CLICK, __showSortTip);
			
			nextBtn.addEventListener(MouseEvent.CLICK,__nextClick);
			preBtn.addEventListener(MouseEvent.CLICK,__preClick);
			refreshTimer.addEventListener(TimerEvent.TIMER,__refreshCurrentPage);
		}
		
		private function __foundChallenge():void
		{
			
		}
		
		private function __refreshCurrentPage(e:TimerEvent):void
		{
			updatePage(currentPage,currentType);
			refreshTimer.stop();
		}
	
		private function __nextClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(currentPage+1,currentType);
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_DEFAULT);
		}
		
		private function __preClick(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			updatePage(currentPage-1,currentType);
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_DEFAULT);
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
		
		private function updatePageBtnEnable():void
		{
			currentPage = (currentPage < 1 ? 1 : currentPage)
			nextBtn.visible = true;
//			nextBtn.visible = (totalPage - currentPage)>=1;
		}
		
		public function get totalPage():int
		{
			if(currentDataList.length == 0)
			{
				return 1;
			}
			return Math.ceil(currentDataList.length/PAGE_COUNT);
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
				var item:RoomListIIRoomItemView = new RoomListIIRoomItemView(i);
				_list.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
				j++;
			}
		}
		
		private function clearList():void
		{
			if(_list)
			{
				for each(var item:RoomListIIRoomItemView in _list.items)
				{
					item.dispose();
					item.removeEventListener(MouseEvent.CLICK,__itemClick,false);
					item = null;
				}
				_list.clearItems();
			}
		}
		
		public function get currentDataList():Array
		{
			if(_model.roomShowMode == 1)
			{
				return _model.getRoomList().filter("isPlaying",false).concat(_model.getRoomList().filter("isPlaying",true));
			}
			return _model.getRoomList().list;
		}
		
		
		public function get roomlist():SimpleGrid
		{
			return _list;
		}
		
		private function __sortBtnClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			currentType = _sortbtns.indexOf(evt.currentTarget);
			updatePage(1,currentType,true);
//			sortList(_sortbtns.indexOf(evt.currentTarget));
			closeSortTip();
			SocketManager.Instance.out.sendUpdateRoomList(lookupEnumerate.ROOM_LIST,lookupEnumerate.ROOMLIST_DEFAULT);
		}
		
		public function closeSortTip():void
		{
			_roomModetip.visible = _modetip.visible = false;
//			_currentSortTipBtn = null;
		}
		
		private function __showSortTip(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(_roomModetip.visible && evt.currentTarget!= room_mode_btn)
			{
				_roomModetip.visible = false;
			}
//			if(_maptip.visible && evt.currentTarget!= map_list_btn)
//			{
//				_maptip.visible = false;
//			}
			if(_modetip.visible && evt.currentTarget!= mode_list_btn)
			{
				_modetip.visible = false;
			}
//			if(evt.currentTarget == map_list_btn)
//			{
//				_maptip.visible = _maptip.visible ? false:true;
//			}
			else if(evt.currentTarget == mode_list_btn)
			{
				_modetip.visible = _modetip.visible ? false:true;
			}
			else
			{
				_roomModetip.visible = _roomModetip.visible ? false:true;
			}
		}
		
		public function sortDataList(type:int):void
		{
			if(type == 0 || type == 2 || type == 3 || type == 5 || type == 6)
			{
				_tempDataList.sortOn(SORT_TYPES[type],Array.NUMERIC);
				if(_autoType == 0)
					_tempDataList.reverse();
				_autoType = (_autoType == 0 ? 1 : 0);
			}else if(type == 1)
			{
				if(_autoType == 0)
					_tempDataList.sortOn(SORT_TYPES[type],Array.CASEINSENSITIVE);
				else
					_tempDataList.sortOn(SORT_TYPES[type],Array.DESCENDING);
				_autoType = (_autoType == 0 ? 1 : 0);
				
			}else if(type == 4)
			{
				_tempDataList.sortOn(SORT_TYPES[type],Array.NUMERIC);
				sortT(_tempDataList,SORT_TYPES[type],_autoType);
				_autoType++;
				if(_autoType >= 3)
					_autoType = 0;
			}
		}
		
		public function get dataList():DictionaryData
		{
			return _model.getRoomList();
		}

		
		public function sortT(items:Array,key:String,value:*):void
		{
			_tempDataList = items;
			if(key=="hardLevel")
			{
				if(value>=0)
				{
					for(var i:int = 0; i < _tempDataList.length; i++)
					{
						if(_tempDataList[i][key] == value && _tempDataList[i].roomType>1)
						{
							_tempDataList.unshift(items.splice(i,1)[0]);
						}
					}
				}else
				{
					for(var j:int = 0; j < _tempDataList.length; j++)
					{
						if(_tempDataList[j].roomType <= 1)
						{
							_tempDataList.unshift(items.splice(j,1)[0]);	
						}
					}
				}
			}
			else
			{
				for(var k:int = 0; k < _tempDataList.length; k++)
				{
					if(_tempDataList[k][key] == value)
					{
						_tempDataList.unshift(items.splice(k,1)[0]);
					}
				}
			}
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
			info.addEventListener(RoomEvent.ROOMPLACE_CHANGED,__roomUpdate);
			var item:RoomListIIRoomItemView = new RoomListIIRoomItemView(info);
			if(info.isPlaying)			
				_list.appendItem(item);
			else
				_list.appendItemAt(item,0);
			trace(info.ID+"__addRoomItem")
			item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
			if(_model.isAddEnd)
			{
				upadteItemPos();
			}
			updatePageText();
			updatePageBtnEnable();
		}
		
		private function __roomUpdate(evt:Event):void
		{
			var info:SimpleRoomInfo = evt.currentTarget as SimpleRoomInfo;
			var item:RoomListIIRoomItemView = _list.getItem("id",info.ID) as RoomListIIRoomItemView;
			if(item != null)
			{
				if(_model.roomShowMode == 1 && info.isPlaying)
					_list.removeItem(item);
			}
			else
			{
				if(!(_model.roomShowMode == 1 && info.isPlaying))
				{
					var t:RoomListIIRoomItemView = new RoomListIIRoomItemView(info);
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
		
		private function __removeRoomItem(evt:DictionaryEvent):void
		{
			if((evt.data as SimpleRoomInfo).roomType <= 2)
			{
				var item:RoomListIIRoomItemView = _list.getItem("id",(evt.data as SimpleRoomInfo).ID) as RoomListIIRoomItemView;
				if(item)
				{
					_list.removeItem(item);
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
					var item:RoomListIIRoomItemView = new RoomListIIRoomItemView(info);
					_list.appendItem(item);
					item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
				}
			}
		}
		
		private function __clearRoomItem(evt:DictionaryEvent):void
		{
			clearList();
		}
		
		private function __roomShowModeChange(evt:Event):void
		{
			clearList();
			var roomlist:DictionaryData = _model.getRoomList();
			for each(var i:SimpleRoomInfo in roomlist)
			{
				if(_list.itemCount >PAGE_COUNT) 
				{
					break;
				}
				var item:RoomListIIRoomItemView = new RoomListIIRoomItemView(i);
				_list.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,__itemClick,false,0,true);
			}
			
			updatePage(1,currentType);
			
		}
		private var selectItemPos:int;
		private var selectItemID:int;
		private function __itemClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			gotoIntoRoom((evt.currentTarget as RoomListIIRoomItemView).info);
			getSelectItemPos((evt.currentTarget as RoomListIIRoomItemView).id);
		}
		
		private function getSelectItemPos(id:int):int
		{
			if(!_list)return 0;
			for(var i:int = 0 ; i<_list.items.length ; i++)
			{
				if(!(_list.items[i] as RoomListIIRoomItemView))return 0;
				if( (_list.items[i] as RoomListIIRoomItemView).id == id )
				{
					selectItemPos = i;
					selectItemID  = (_list.items[i] as RoomListIIRoomItemView).id;
					return i;
				}
			}
			return 0;
		}
		
		public function gotoIntoRoom(info:SimpleRoomInfo):void
		{
			SoundManager.instance.play("008");
			
			if(info.dungeonInfo && info.dungeonInfo.LevelLimits > PlayerManager.Instance.Self.Grade)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.roomlist.lessLevel",String(info.dungeonInfo.LevelLimits)));
				return ;
			}
				SocketManager.Instance.out.sendGameLogin(1,-1,info.ID,"");
		}
		
		public function get IsPve():Boolean
		{
			return false;
		}
		
		public function dispose():void
		{
			refreshTimer.removeEventListener(TimerEvent.TIMER,__refreshCurrentPage);
			refreshTimer.stop();
			refreshTimer = null;
			
			_model.getRoomList().removeEventListener(DictionaryEvent.ADD,__addRoomItem);
			_model.getRoomList().removeEventListener(DictionaryEvent.REMOVE,__removeRoomItem);
			_model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,__clearRoomItem);
			_model.removeEventListener(RoomListIIModel.ROOMSHOWMODE_CHANGE,__roomShowModeChange);
			for each(var i:SimpleRoomInfo in _model.getRoomList())
			{
				i.removeEventListener(RoomEvent.CHANGED,__roomUpdate);
			}
			
			for(var j:uint = 0;j<5;j++)
			{
				_sortbtns[j].removeEventListener(MouseEvent.CLICK,__sortBtnClick);
				DisposeUtils.disposeHBaseButton(_sortbtns[j]);
			}
			_sortbtns = null;
			
			nextBtn.removeEventListener(MouseEvent.CLICK,__nextClick);
			preBtn.removeEventListener(MouseEvent.CLICK,__preClick);
			
//			round_list_btn.removeEventListener(MouseEvent.CLICK,__showSortTip);
			mode_list_btn.removeEventListener(MouseEvent.CLICK,__showSortTip);
			room_mode_btn.removeEventListener(MouseEvent.CLICK, __showSortTip);
			
//			if(_maptip)
//				_maptip.dispose();
//			_maptip = null;
			
			if(_modetip)
				_modetip.dispose();
			_modetip = null;
			
			if(_roomModetip)
				_roomModetip.dispose();
			_roomModetip = null;
			
			if(_boxButton)
			{
				BossBoxManager.instance.deleteBoxButton();
				_boxButton.dispose();
			}
			_boxButton = null;
			
			
//			if(round_list_btn)
//				round_list_btn.dispose();
//			round_list_btn = null;
			
			if(mode_list_btn)
				mode_list_btn.dispose();
			mode_list_btn = null;
			
			if(room_mode_btn)
				room_mode_btn.dispose();
			room_mode_btn = null;
			
			if(nextBtn)
				nextBtn.dispose();
			nextBtn = null;
			
			if(preBtn)
				preBtn.dispose();
			preBtn = null;
			
			if(preMoreBtn)
				preMoreBtn.dispose();
			preMoreBtn = null;
			
			DownlandClientManager.Instance.hide();
			
			clearList();
			if(_list && _list.parent)
				_list.parent.removeChild(_list);
			_list = null;
		
			if(_passinput)
			{
				_passinput.close();
				_passinput.dispose();
			}
			_passinput = null;
			
			if(_bottomBMP && _bottomBMP.parent)
				_bottomBMP.parent.removeChild(_bottomBMP);
			_bottomBMP = null;
			
			_tempDataList = null;
			_model = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}