package ddt.auctionHouse.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import road.data.DictionaryData;
	
	import ddt.auctionHouse.AuctionState;
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.data.goods.CateCoryInfo;
	
	[Event(name = "changeState",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	[Event(name = "getGoodCategory",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	[Event(name = "deleteAuction",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	[Event(name = "addAuction",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	[Event(name = "updatePage",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	[Event(name = "browseTypeChange",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	public class AuctionHouseModel extends EventDispatcher
	{		
		public static var searchType : int;/**1,查看,2,搜索,3排**/
		public static var SINGLE_PAGE_NUM:int = 100;//单页显示的条目数量
		
		private var _state:String;
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.CHANGE_STATE));
		}
		
		/**
		 * 种类 
		 */		
		private var _categorys:Array = new Array();
		public function get category():Array
		{
			return _categorys.slice(0);
		}
		
		public function set category(value:Array):void
		{
			_categorys = value;
			if(value.length != 0)
			{
				dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.GET_GOOD_CATEGORY));
			}
		}
		
		public function getCatecoryById(id:int):CateCoryInfo
		{
			for each(var info:CateCoryInfo in _categorys)
			{
				if(info.ID == id)
				{
					return info;
				}
			}
			return null;
		}
		
		/**
		 * 我的拍卖数据信息 
		 */		
		private var _myAuctionData:DictionaryData; 
		public function get myAuctionData():DictionaryData
		{
			return _myAuctionData;
		}
		
		public function addMyAuction(info:AuctionGoodsInfo):void
		{
			if(_state == AuctionState.SELL)
			{
				_myAuctionData.add(info.AuctionID,info);
			}
			else if(_state == AuctionState.BROWSE)
			{
				_browseAuctionData.add(info.AuctionID,info);
			}
			else if(_state == AuctionState.BUY)
			{
				_buyAuctionData.add(info.AuctionID,info);
			}
		}
		
		public function clearMyAuction():void
		{
			_myAuctionData.clear();
		}
		
		public function removeMyAuction(info:AuctionGoodsInfo):void
		{
			if(_state == AuctionState.SELL)
			{
				_myAuctionData.remove(info.AuctionID);
			}
			else if(_state == AuctionState.BROWSE)
			{
				_browseAuctionData.remove(info.AuctionID);
			}
			else if(_state == AuctionState.BUY)
			{
				_buyAuctionData.remove(info.AuctionID);
			}
		}
		
		
	
		private var _sellTotal:int;
		public function set sellTotal(value:int):void
		{
			_sellTotal = value;
			dispatchEvent(new  AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
		}
		
		public function get sellTotal():int
		{
			return _sellTotal;
		}
		
		public function get sellTotalPage():int
		{
			return Math.ceil(_sellTotal / 50);
		}
		
		private var _sellCurrent:int;
		public function set sellCurrent(value:int):void
		{
			_sellCurrent = value;
		}
		public function get sellCurrent():int
		{
			return _sellCurrent;
		}
		
		/*
		 *浏览 
		 */
		 private var _browseAuctionData:DictionaryData;
		 public function get browseAuctionData():DictionaryData
		 {
		 	return _browseAuctionData;
		 }
		 
		 public function addBrowseAuctionData(info:AuctionGoodsInfo):void
		 {
		 	_browseAuctionData.add(info.AuctionID,info);
		 }
		 
		public function clearBrowseAuctionData():void
		{
			_browseAuctionData.clear();
		}
		
		public function removeBrowseAuctionData(info:AuctionGoodsInfo):void
		{
			_browseAuctionData.remove(info.AuctionID);
		}
		
		private var _browseTotal:int;
		public function set browseTotal(value:int):void
		{
			_browseTotal = value;
			dispatchEvent(new  AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
		}
		
		public function get browseTotal():int
		{
			return _browseTotal;
		}
		
		public function get browseTotalPage():int
		{
			return Math.ceil(_browseTotal / 50);
		}
		
		private var _browseCurrent:int = 1;
		public function set browseCurrent(value:int):void
		{
			_browseCurrent = value;
		}
		public function get browseCurrent():int
		{
			return _browseCurrent;
		}
		/*浏览类型*/
		private var _currentBrowseGoodInfo:CateCoryInfo;
		public function get currentBrowseGoodInfo():CateCoryInfo
		{
			return _currentBrowseGoodInfo;
		}
		public function set currentBrowseGoodInfo(value:CateCoryInfo):void
		{
			_currentBrowseGoodInfo = value;
			_browseCurrent = 1;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.BROWSE_TYPE_CHANGE));
		}
		
		/*我的竞标信息*/
		private var _buyAuctionData:DictionaryData;
		public function get buyAuctionData():DictionaryData
		{
			return _buyAuctionData;
		}
		
		public function addBuyAuctionData(info:AuctionGoodsInfo):void
		{
			_buyAuctionData.add(info.AuctionID,info);	
		}
		
		public function removeBuyAuctionData(info:AuctionGoodsInfo):void
		{
			_buyAuctionData.remove(info);
		}
		
		public function clearBuyAuctionData():void
		{
			_buyAuctionData.clear();
		}
		
		private var _buyTotal : int;
		public function set buyTotal(value : int) : void
		{
			this._buyTotal = value;
			dispatchEvent(new  AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
		}
		public function get buyTotal() : int
		{
			return this._buyTotal;
		}
		public function get buyTotalPage() : int
		{
			return Math.ceil(_buyTotal / 50);
		}

		private var _buyCurrent : int = 1;
		public function set buyCurrent(value : int) : void
		{
			_buyCurrent = value;
		}
		public function get buyCurrent() : int
		{
			return this._buyCurrent;
		}
		
		
		
		
		public function AuctionHouseModel(target:IEventDispatcher=null)
		{
			super(target);
			_state = AuctionState.BROWSE;
			_myAuctionData = new DictionaryData();
			_browseAuctionData = new DictionaryData();
			_buyAuctionData = new DictionaryData();
		}
		
	
		public function dispose():void
		{
			_categorys = new Array();
			if(_myAuctionData)_myAuctionData.clear();
			_myAuctionData = null;
			if(_browseAuctionData)_browseAuctionData.clear();
			_browseAuctionData = null;
			if(_buyAuctionData)_buyAuctionData.clear();
			_buyAuctionData = null;
		}
	}
}