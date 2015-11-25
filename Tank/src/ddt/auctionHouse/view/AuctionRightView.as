package ddt.auctionHouse.view
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.AuctionHouse.RightAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	
	import ddt.auctionHouse.AuctionState;
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.auctionHouse.model.AuctionHouseModel;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.manager.LanguageMgr;

	public class AuctionRightView extends RightAsset
	{
		private var _list:SimpleGrid;
		
		public var _strips:Array;
		
		private var _selectStrip:StripView;
		
		private var _currentButtonIndex:uint = 0;
		
		private var _currentIsdown:Boolean = true;
		
		public var _prePage_btn  : HBaseButton;
		public  var _nextPage_btn : HBaseButton;
//		private var _sortBt1 : HBaseButton;
//		private var _sortBt2 : HBaseButton;
//		private var _sortBt3 : HBaseButton;
//		private var _sortBt4 : HBaseButton;
//		private var _sortBt5 : HBaseButton;
		private var _sortBtItems : Array;
		
		private var _state:String = "";
		
		public function AuctionRightView($state:String="")
		{
			_state = $state;
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			_sortBtItems = new Array(5);
			_list = new SimpleGrid();
			_list.horizontalScrollPolicy = "off";
			_list.setSize(681,310);
			_list.cellHeight = 51;
			_list.cellWidth = 651;
			_list.cellPaddingHeight = -1;
			addChild(_list);
			_list.move(listPos_mc.x,listPos_mc.y);
			listPos_mc.visible = false;
			
			_strips = new Array();
			
			for(var i:uint = 0;i<5;i++){
				this["arrowPos"+i].visible = false;
				this["arrowPos"+i].buttonMode = true;
				if(i != 1)
				{
					var item : HBaseButton;
					if(i!=3)
					{
						item = new HBaseButton(this["sort_btn"+i]);
					}else if(_state != AuctionState.SELL)
					{
						item = new HBaseButton(this["sort_btn"+i]);
						this.removeChild(this["sort_btn"+5]);
					}else
					{
						//增加竞标按钮
						item = new HBaseButton(this["sort_btn"+5]);
						this.removeChild(this["sort_btn"+3]);
					}
					_sortBtItems[i] = item;
					item.useBackgoundPos = true;
					addChild(item);
				}
				
			}
			
			this.swapChildren(_sortBtItems[4],downArrow);
			this.swapChildren(upArrow,_sortBtItems[3]);
			
			_prePage_btn = new HBaseButton(prePage_btn);
			_prePage_btn.useBackgoundPos = true;
			addChild(_prePage_btn);
			
			
			_nextPage_btn = new HBaseButton(nextPage_btn);
			_nextPage_btn.useBackgoundPos = true;
			addChild(_nextPage_btn);
			
			_nextPage_btn.enable = false;
			_prePage_btn.enable = false;
			downArrow.visible = false;
			upArrow.visible = false;
//			changeArrow(_currentButtonIndex,_currentIsdown);
		}
		public function addStageInit() : void
		{
			_nextPage_btn.enable = false;
			_prePage_btn.enable = false;
		}
		private function addEvent():void
		{
			for(var i:uint = 0;i<5;i++){
				if(i != 1)
				_sortBtItems[i].addEventListener(MouseEvent.CLICK,sortHandler);
//				this["sort_btn"+i].addEventListener(MouseEvent.CLICK,sortHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:uint = 0;i<5;i++){
				if(i != 1)
				{
					var btn : HBaseButton = _sortBtItems[i] as HBaseButton;
					btn.removeEventListener(MouseEvent.CLICK,sortHandler);
					if(btn && btn.parent)btn.parent.removeChild(btn);
					if(btn)btn.dispose();
					btn = null;
				}
				
//				this["sort_btn"+i].removeEventListener(MouseEvent.CLICK,sortHandler);
			}
		}
		internal function dispose():void
		{
			removeEvent();
			
		    if(_prePage_btn && _prePage_btn.parent)_prePage_btn.parent.removeChild(_prePage_btn);
		    if(_prePage_btn)_prePage_btn.dispose();
		    _prePage_btn = null;
		    if(_nextPage_btn && _nextPage_btn.parent)_nextPage_btn.parent.removeChild(_nextPage_btn);
		    if(_nextPage_btn)_nextPage_btn.dispose();
		    _nextPage_btn = null;
			if(parent)parent.removeChild(this);
			for each(var strip:StripView in _strips)
			{
				strip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
				strip.dispose();
			}
			if(_list.parent)removeChild(_list);
			if(_list)_list.clearItems();
			_list = null;
			_strips = null;
			if(_selectStrip)
			{
				_selectStrip.dispose();
				_selectStrip = null;
			}
		}
		internal function hideReady() : void
		{
			_nextPage_btn.enable = false;
			_prePage_btn.enable = false;
			downArrow.visible = false;
			upArrow.visible = false;
		}
		
		internal function addAuction(info:AuctionGoodsInfo):void
		{
			var strip:StripView = new StripView();
			strip.info = info;
			strip.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
			_strips.push(strip);
			_list.appendItemAt(strip,0);
			_list.verticalScrollPosition = 0;//这行是将滚动条移上去
		}
		
		internal function updateAuction(info:AuctionGoodsInfo):void
		{
			for each(var strip:StripView in _strips)
			{
				if(strip.info.AuctionID == info.AuctionID)
				{
					strip.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
					info.BagItemInfo = strip.info.BagItemInfo;
					strip.info = info;
					break;
				}
			}
			
		}
		
		
		
		internal function getStripCount():int
		{
			return _strips.length;
		}
		private var _startNum   : int   = 0;
		private var _endNum     : int   = 0;
		private var _totalCount : int   = 0;
		internal function setPage(start:int,totalCount:int):void
		{
			var end:int
			start = 1 + AuctionHouseModel.SINGLE_PAGE_NUM * (start - 1);
			if(start + AuctionHouseModel.SINGLE_PAGE_NUM - 1 < totalCount)
			end = start + AuctionHouseModel.SINGLE_PAGE_NUM - 1;
			else
			end = totalCount;
			_startNum = start;
			_endNum   = end;
			_totalCount = totalCount;
			if(totalCount == 0)
			page_txt.text = "";
			else
			page_txt.text = LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionRightView.Object") + start.toString() + "-" + end.toString() + LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionRightView.Total") + totalCount + ")";	
			buttonStatus(start,end,totalCount);		
		}	
		private function upPageTxt() : void
		{
			_endNum --;
			_totalCount --;
			if(_endNum < _startNum)
			page_txt.text = "";
			else
			page_txt.text = LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionRightView.Object") + _startNum.toString() + "-" + _endNum.toString() + LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionRightView.Total") + _totalCount + ")";
		}
		
		private function buttonStatus(start:int,end:int,totalCount:int) : void
		{
			if(start <= 1)
			{
				_prePage_btn.enable = false;
			}
			else
			{
				_prePage_btn.enable = true;
			}
			if(end < totalCount)
			{
				_nextPage_btn.enable = true;
			}
			else
			{
				_nextPage_btn.enable = false;
			}
			_nextPage_btn.alpha = 1;
			_prePage_btn.alpha  = 1;
		}
		
		internal function clearList():void
		{
			_list.clearItems();
			
			_selectStrip = null;
			for each(var strip:StripView in _strips)
			{
				strip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
				strip.dispose();
			}
			_strips = new Array();
			page_txt.text = "";
		}	
		
		internal function getSelectInfo():AuctionGoodsInfo
		{
			if(_selectStrip)
			{
				return _selectStrip.info;
			} 
			return null;
		}
		
		internal function deleteItem():void
		{
			for(var i:int=0;i<_strips.length;i++)
			{
				if(_selectStrip == _strips[i])
				{
					_selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
					_selectStrip.dispose();
					_list.removeItem(_selectStrip);
					_strips.splice(i,1);
			        _selectStrip = null;
			        upPageTxt();
					break;
				}
				
			}
		}
		
		internal function clearSelectStrip() : void
		{
			for each(var strip:StripView in _strips)
			{
				if(_selectStrip == strip)
				{
					_selectStrip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
					_selectStrip.clearSelectStrip();
					_selectStrip = null;
					break;
				}
			}
		}
		internal function setSelectEmpty() : void
		{
			_selectStrip.isSelect = false;
			_selectStrip = null;
			
		}
		
		internal function get sortCondition():int
		{
			return _currentButtonIndex;
		}
		internal function get sortBy():Boolean
		{
			return _currentIsdown
		}
		private function __selectStrip(event:AuctionHouseEvent):void
		{
			var currentStrip:StripView = event.target as StripView;
			for each(var strip:StripView in _strips){
				strip.isSelect = false;
			}
			currentStrip.isSelect = true;
			_selectStrip = currentStrip;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
		}
		
		private function sortHandler(e:MouseEvent):void
		{
			SoundManager.instance.play("047");
//			if(!_list || !_list.items || _list.items.length == 0)return;
// 			var _index:uint = int(e.currentTarget.name.charAt(e.currentTarget.name.length - 1));
 			var _index:uint = int(e.target.name.charAt(e.target.name.length - 1));
			if(_currentButtonIndex == _index){
				changeArrow(_index,!_currentIsdown);
			}else{
				changeArrow(_index,true);
			}
			
		}
		
		private function changeArrow(index:uint,isdown:Boolean):void
		{
			var _index:uint = index;
			if(index==5)
			{
				index = 3;//改更竞标
			}
			if(isdown){
				downArrow.visible = true;
				upArrow.visible = false;
				downArrow.x = this["arrowPos"+index].x;
				downArrow.y = this["arrowPos"+index].y;
				
			}else{
				downArrow.visible = false;
				upArrow.visible = true;
				upArrow.x = this["arrowPos"+index].x;
				upArrow.y = this["arrowPos"+index].y;
			}
			downArrow.mouseChildren = false;
			downArrow.mouseEnabled  = false;
			upArrow.mouseChildren = false;
			upArrow.mouseEnabled  = false;
			_currentIsdown = isdown;
			_currentButtonIndex = _index;
//			if(_list)
//			sortItems(_sortArr[index]);
			AuctionHouseModel.searchType = 3;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SORT_CHANGE));
		}
		
		
		
		/**********************************************************
		 *            新增,用于本地排序
		 * *******************************************************/
		public  var _titleItems : Array;
		private var _ItemsDict  : Dictionary;
		private var _sortArr    : Array = ["Name","Count","ValidDate","AuctioneerName","Price"];
		private function sortItems(title : String) : void
		{
			_titleItems = [];
			_ItemsDict  = new Dictionary(true);
			for(var i:int=0;i<_strips.length;i++)
			{
				_list.removeItem(_strips[i]);
			}
			for each(var strip:StripView in _strips)
			{
				_titleItems.push({ItemID:strip.info.ItemID,Count:strip.info.BagItemInfo.Count,
				AuctioneerName:strip.info.AuctioneerName,ValidDate:strip.info.ValidDate,
				Name:strip.info.BagItemInfo.Name,Price:strip.info.Price});
				_ItemsDict[strip.info.ItemID] = strip;
			}
			_titleItems.sortOn(title,2|1|16);
			if(_currentIsdown)
			_titleItems.reverse();
			for(var j:int=0;j<_titleItems.length;j++)
			{
				_list.appendItem(_ItemsDict[_titleItems[j].ItemID]);
			}
		}
		
	}
}