package ddt.auctionHouse.view
{
	import game.crazyTank.view.AuctionHouse.BuyRightAsset;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.data.auctionHouse.AuctionGoodsInfo;

	internal class AuctionBuyRightView extends BuyRightAsset
	{
		private var _list:SimpleGrid;
		
		private var _strips:Array;
		
		private var _selectStrip:AuctionBuyStripView;
		
		
		public function AuctionBuyRightView()
		{
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			_strips = new Array();
			
			_list = new SimpleGrid();
			_list.setSize(910,343);
//			_list.setSize(910,317);
			_list.cellPaddingHeight = 1;
			_list.horizontalScrollPolicy = "off";
			_list.cellHeight = 51;
			_list.cellWidth = 883;
			addChild(_list);
			_list.move(listPos_mc.x,listPos_mc.y);
			listPos_mc.visible = false;
		}
	
		private function addEvent():void
		{
			
		}
		
		private function removeEvent():void
		{
		}
		
		internal function addAuction(info:AuctionGoodsInfo):void
		{
			var strip:AuctionBuyStripView = new AuctionBuyStripView();
			strip.info = info;
			strip.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
			_strips.push(strip);
			_list.appendItemAt(strip,0);
		}
		
		internal function clearList():void
		{
			_list.clearItems();
			_selectStrip = null;
			for each(var strip:AuctionBuyStripView in _strips)
			{
				strip.dispose();
			}
			_strips = new Array();
		}	
		
		internal function dispose():void
		{
			removeEvent();
			if(_list.parent)removeChild(_list);
			if(_list)_list.clearItems();
			_list = null;
			
			for each(var strip:AuctionBuyStripView in _strips)
			{
				strip.dispose();
				strip.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
				strip = null;
			}
			_strips = null;
		}
		
		internal function getSelectInfo():AuctionGoodsInfo
		{
			if(_selectStrip)
				return _selectStrip.info;
			else
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
					_strips.splice(i,1);
					_list.removeItem(_selectStrip);
					_selectStrip = null;
					break;
				}
				
			}
		}
		
		internal function clearSelectStrip() : void
		{
			for each(var strip:AuctionBuyStripView in _strips)
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
		
		
		internal function updateAuction(info:AuctionGoodsInfo):void
		{
			for each(var strip:AuctionBuyStripView in _strips)
			{
				if(strip.info.AuctionID == info.AuctionID)
				{
					info.BagItemInfo = strip.info.BagItemInfo;
					strip.info = info;
					break;
				}
			}
		}
		
		private function __selectStrip(event:AuctionHouseEvent):void
		{
			if(_selectStrip)
			{
				_selectStrip.isSelect = false;
			}
			var strip:AuctionBuyStripView = event.target as AuctionBuyStripView;
			strip.isSelect = true;
			_selectStrip = strip;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
		}
		
//		internal function setPage(start:int,totalCount:int):void
//		{
//			var end:int
//			start = 1 + 50 * (start - 1);
//			if(start + 49 < totalCount)
//			{
//				end = start + 49;
//			}
//			else
//			{
//				end = totalCount;
//			}
//			if(totalCount == 0)
//			{
//				page_txt.text = "";
//			}
//			else
//			{
//				page_txt.text = "物品 " + start.toString() + "-" + end.toString() + "(总数" + totalCount + ")";
//			}		
//		}	
		
	}
}