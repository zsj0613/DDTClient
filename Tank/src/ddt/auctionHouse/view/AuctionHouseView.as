package ddt.auctionHouse.view
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.crazyTank.view.AuctionHouse.AuctionAsset;
	
	import road.data.DictionaryEvent;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	
	import ddt.auctionHouse.AuctionState;
	import ddt.auctionHouse.IAuctionHouse;
	import ddt.auctionHouse.controller.AuctionHouseController;
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.auctionHouse.model.AuctionHouseModel;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.DownlandClientManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;

	public class AuctionHouseView extends AuctionAsset implements IAuctionHouse
	{
		private var _model:AuctionHouseModel;
		private var _controller:AuctionHouseController;
		
		private var _browse:AuctionBrowseView;
		
		private var _buy:AuctionBuyView;
		
		private var _sell:AuctionSellView;
		
		private var _isInit:Boolean;
		
		private var _desctrptionFrame:AuctionDescriptionFrame;
		
		public function AuctionHouseView(controller:AuctionHouseController,model:AuctionHouseModel)
		{
			_isInit = true;
			super();
			_model = model;
			_controller = controller;
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			pos_mc.visible = false;
			
			_browse = new AuctionBrowseView(_controller);
			_browse.x = pos_mc.x;
			_browse.y = pos_mc.y;

			_buy = new AuctionBuyView();
			_buy.x = pos_mc.x;
			_buy.y = pos_mc.y;	
			
			_sell = new AuctionSellView(_controller);
			_sell.x = pos_mc.x;
			_sell.y = pos_mc.y;
			
			DownlandClientManager.Instance.show(this);
			DownlandClientManager.Instance.setDownlandBtnPos(new Point(downBtnPos.x,downBtnPos.y));
			removeChild(downBtnPos);
			
			shineMc.visible = shineMc.mouseChildren = shineMc.mouseEnabled = false;
			descriptionBtn.buttonMode = true;
			addChild(shineMc);
			_desctrptionFrame = new AuctionDescriptionFrame();	
			
			update();
			updateAccount();
		}
		
		private function addEvent():void
		{
			title_mc.browse_btn.addEventListener(MouseEvent.CLICK,__browse);
			title_mc.buy_btn.addEventListener(MouseEvent.CLICK,__buy);
			title_mc.sell_btn.addEventListener(MouseEvent.CLICK,__sell);
			
			descriptionBtn.addEventListener(MouseEvent.CLICK,__showDescription);
			descriptionBtn.addEventListener(MouseEvent.MOUSE_OVER,__showShineMc);
			descriptionBtn.addEventListener(MouseEvent.MOUSE_OUT,__hideShineMc);
			
			_model.addEventListener(AuctionHouseEvent.CHANGE_STATE,__changeState);
			_model.addEventListener(AuctionHouseEvent.GET_GOOD_CATEGORY,__getCategory);
			
			_model.myAuctionData.addEventListener(DictionaryEvent.ADD,__addMyAuction);
			_model.myAuctionData.addEventListener(DictionaryEvent.CLEAR,__clearMyAuction);
//			_model.myAuctionData.addEventListener(DictionaryEvent.REMOVE,__removeMyAuction);
			_model.myAuctionData.addEventListener(DictionaryEvent.UPDATE,__updateMyAuction);
			
			_model.browseAuctionData.addEventListener(DictionaryEvent.ADD,__addBrowse);
			_model.browseAuctionData.addEventListener(DictionaryEvent.CLEAR,__clearBrowse);
			//_model.browseAuctionData.addEventListener(DictionaryEvent.REMOVE,__removeBrowse);
			_model.browseAuctionData.addEventListener(DictionaryEvent.UPDATE,__updateBrowse);
			
			_model.buyAuctionData.addEventListener(DictionaryEvent.ADD,__addBuyAuction);
			_model.buyAuctionData.addEventListener(DictionaryEvent.CLEAR,__clearBuyAuction);
			//_model.buyAuctionData.addEventListener(DictionaryEvent.REMOVE,__removeBuyAuction);
			_model.buyAuctionData.addEventListener(DictionaryEvent.UPDATE,__updateBuyAuction);
			
			_model.addEventListener(AuctionHouseEvent.UPDATE_PAGE,__updatePage);
			_model.addEventListener(AuctionHouseEvent.BROWSE_TYPE_CHANGE,__browserTypeChange);
			
			_sell.addEventListener(AuctionHouseEvent.PRE_PAGE,__prePage);
			_sell.addEventListener(AuctionHouseEvent.NEXT_PAGE,__nextPage);
			_sell.addEventListener(AuctionHouseEvent.SORT_CHANGE,__sellSortChange);
			
			_browse.addEventListener(AuctionHouseEvent.PRE_PAGE,__prePage);
			_browse.addEventListener(AuctionHouseEvent.NEXT_PAGE,__nextPage);
			
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__changeMoney);
		}
		
		public function forbidChangeState():void
		{
			title_mc.browse_btn.removeEventListener(MouseEvent.CLICK,__browse);
			title_mc.buy_btn.removeEventListener(MouseEvent.CLICK,__buy);
			title_mc.sell_btn.removeEventListener(MouseEvent.CLICK,__sell);
		}
		
		public function allowChangeState():void
		{
			title_mc.browse_btn.addEventListener(MouseEvent.CLICK,__browse);
			title_mc.buy_btn.addEventListener(MouseEvent.CLICK,__buy);
			title_mc.sell_btn.addEventListener(MouseEvent.CLICK,__sell);
		}
		
		private function removeEvent():void
		{
			title_mc.browse_btn.removeEventListener(MouseEvent.CLICK,__browse);
			title_mc.buy_btn.removeEventListener(MouseEvent.CLICK,__buy);
			title_mc.sell_btn.removeEventListener(MouseEvent.CLICK,__sell);
			
			descriptionBtn.removeEventListener(MouseEvent.CLICK,__showDescription);
			descriptionBtn.removeEventListener(MouseEvent.MOUSE_OVER,__showShineMc);
			descriptionBtn.removeEventListener(MouseEvent.MOUSE_OUT,__hideShineMc);
			
			_model.removeEventListener(AuctionHouseEvent.CHANGE_STATE,__changeState);
			_model.removeEventListener(AuctionHouseEvent.GET_GOOD_CATEGORY,__getCategory);
			
			_model.myAuctionData.removeEventListener(DictionaryEvent.ADD,__addMyAuction);
			_model.myAuctionData.removeEventListener(DictionaryEvent.CLEAR,__clearMyAuction);
//			_model.myAuctionData.removeEventListener(DictionaryEvent.REMOVE,__removeMyAuction);
			_model.myAuctionData.removeEventListener(DictionaryEvent.UPDATE,__updateMyAuction);
			
			_model.browseAuctionData.removeEventListener(DictionaryEvent.ADD,__addBrowse);
			_model.browseAuctionData.removeEventListener(DictionaryEvent.CLEAR,__clearBrowse);
			//_model.browseAuctionData.removeEventListener(DictionaryEvent.REMOVE,__removeBrowse);
			_model.browseAuctionData.removeEventListener(DictionaryEvent.UPDATE,__updateBrowse);
			
			_model.buyAuctionData.removeEventListener(DictionaryEvent.ADD,__addBuyAuction);
			_model.buyAuctionData.removeEventListener(DictionaryEvent.CLEAR,__clearBuyAuction);
			//_model.buyAuctionData.removeEventListener(DictionaryEvent.REMOVE,__removeBuyAuction);
			_model.buyAuctionData.removeEventListener(DictionaryEvent.UPDATE,__updateBuyAuction);
			
			_model.removeEventListener(AuctionHouseEvent.UPDATE_PAGE,__updatePage);
			_model.removeEventListener(AuctionHouseEvent.BROWSE_TYPE_CHANGE,__browserTypeChange);
			
			_sell.removeEventListener(AuctionHouseEvent.PRE_PAGE,__prePage);
			_sell.removeEventListener(AuctionHouseEvent.NEXT_PAGE,__nextPage);
			_sell.removeEventListener(AuctionHouseEvent.SORT_CHANGE,__sellSortChange);
			
			_browse.removeEventListener(AuctionHouseEvent.PRE_PAGE,__prePage);
			_browse.removeEventListener(AuctionHouseEvent.NEXT_PAGE,__nextPage);
			
			
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__changeMoney);
		}
		
		
		private function update():void
		{
			if(_model.state == AuctionState.BROWSE)
			{
				title_mc.gotoAndStop(1);
				title_mc.browse_btn.mouseEnabled = false;
				title_mc.buy_btn.mouseEnabled = true;
				title_mc.sell_btn.mouseEnabled = true;
				addChild(_browse);
				
//				_browse.Right.help_mc.visible = true; //bret 09.8.2
				
				_buy.parent ? removeChild(_buy) : null;
				_sell.parent ? _sell.hideReady() : null;
				_sell.parent ? removeChild(_sell):null;	
				if(_isInit)
				{
					_isInit = false;					
				}	
				else
				{
					_browse.clearList();
//					_browse.searchByCurCondition(_model.browseCurrent);
				}					
			}
			else if(_model.state == AuctionState.BUY)
			{
				title_mc.gotoAndStop(2);
				title_mc.browse_btn.mouseEnabled = true;
				title_mc.buy_btn.mouseEnabled = false;
				title_mc.sell_btn.mouseEnabled = true;
				addChild(_buy);
				_browse.parent ? _browse.hideReady() : null;
				_browse.parent ? removeChild(_browse) : null;
				_sell.parent ? _sell.hideReady() : null;
				_sell.parent ? removeChild(_sell):null;
				
				var AuctionIDs:Array = SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID];
		    	var sAuctionIDs:String="";
		    	if(AuctionIDs && AuctionIDs.length>0)
		    	{
		    		var lth:int=AuctionIDs.length;
		    		sAuctionIDs = AuctionIDs[0].toString();
		    		if(lth>1){
		    		    for(var i:int=1;i<lth;i++)
		    		    {
			     		    //sAuctionIDs+=(","+AuctionIDs[PlayerManager.Instance.Self.ID][i].toString());
							sAuctionIDs+=(","+AuctionIDs[i].toString());
			    	    }
		        	}
	    		}
				if(_model.buyAuctionData.length < 50)
				{
					_controller.searchAuctionList(1,"",-1,-1,-1,PlayerManager.Instance.Self.ID,0,"false",sAuctionIDs);
				}
			}
			else if(_model.state == AuctionState.SELL)
			{
				title_mc.gotoAndStop(3);
				title_mc.browse_btn.mouseEnabled = true;
				title_mc.buy_btn.mouseEnabled = true;
				title_mc.sell_btn.mouseEnabled = false;
				addChild(_sell);
				_controller.visibleHelp(_sell.Right,2);
				_browse.parent ? _browse.hideReady() : null;
				_browse.parent ? removeChild(_browse) : null;
				_buy.parent ? removeChild(_buy) : null;
				if(_model.myAuctionData.length < 50)
				{
					_model.sellCurrent = 1;
					_controller.searchAuctionList(1,"",-1,-1,PlayerManager.Instance.Self.ID,-1);
				}
				
			}
		}
		
		private function updateAccount():void
		{
			account_mc.gold_txt.text = PlayerManager.Instance.Self.Gold;
			account_mc.money_txt.text = PlayerManager.Instance.Self.Money;
		}
		
		public function show():void
		{
			_controller.addChild(this);
			//UIManager.AddDialog(this,false);
		}
		
		public function hide():void
		{
			if(parent)
			{
				_controller.removeChild(this);
				//UIManager.RemoveDialog(this);
			}
			dispose();
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_browse)
			{
				_browse.dispose();
				_browse = null;
			}
			if(_buy)_buy.dispose();
			_buy = null;
			if(_sell)_sell.dispose();
			_sell = null;
			_model = null;
			_controller = null;
			if(_desctrptionFrame)
			{
				_desctrptionFrame.dispose();
			}
			
			DownlandClientManager.Instance.hide();
		}
		
		private function __browse(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			_controller.setState(AuctionState.BROWSE);
		}
		
		private function __buy(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			_controller.setState(AuctionState.BUY);
		}
		
		private function __sell(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			_controller.setState(AuctionState.SELL);
		}
		
		private function __changeState(event:AuctionHouseEvent):void
		{
			update();
		}
		
		private function __getCategory(event:AuctionHouseEvent):void
		{
			_model.browseCurrent = 1;
			_browse.setCategory(_model.category);
//			_controller.browseTypeChangeNull();
		}
		
		private function __showDescription(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_desctrptionFrame.show();
		}
		
		private function __showShineMc(evt:MouseEvent):void
		{
			shineMc.visible = true;
		}
		
		private function __hideShineMc(evt:MouseEvent):void
		{
			shineMc.visible = false;
		}
		
		private function __updatePage(event:AuctionHouseEvent):void
		{
			if(_model.state == AuctionState.SELL)
			{
				_sell.setPage(_model.sellCurrent,_model.sellTotal);
			}
			else if(_model.state == AuctionState.BROWSE)
			{
				_browse.setPage(_model.browseCurrent,_model.browseTotal);
			}
//			else if(_model.state == AuctionState.BUY)
//			{
//				_buy.setPage(_model.buyCurrent,_model.buyTotal);
//			}
		}
		
		private function __prePage(event:AuctionHouseEvent):void
		{
			if(_model.state == AuctionState.SELL)
			{
				if(_model.sellCurrent > 1)
				{
					_model.sellCurrent = _model.sellCurrent - 1;
					_sell.searchByCurCondition(_model.sellCurrent,PlayerManager.Instance.Self.ID);
//					_controller.searchAuctionList(_model.sellCurrent,"",-1,-1,PlayerManager.Instance.Self.ID,-1);
				}
			}
			else if(_model.state == AuctionState.BROWSE)
			{
				if(_model.browseCurrent > 1)
				{
					_model.browseCurrent = _model.browseCurrent - 1;
					_browse.searchByCurCondition(_model.browseCurrent);
//					_controller.searchAuctionList(_model.browseCurrent,"",-1,-1,-1,-1);
				}
			}
		}
		
		private function __nextPage(event:AuctionHouseEvent):void
		{
			if(_model.state == AuctionState.SELL)
			{
				if(_model.sellCurrent < _model.sellTotalPage)
				{
					_model.sellCurrent = _model.sellCurrent + 1;
					
					_sell.searchByCurCondition(_model.sellCurrent,PlayerManager.Instance.Self.ID);
//					_controller.searchAuctionList(_model.sellCurrent,"",-1,-1,PlayerManager.Instance.Self.ID,-1);
				}
			}
			else if(_model.state == AuctionState.BROWSE)
			{
				if(_model.browseCurrent < _model.browseTotalPage)
				{
					_model.browseCurrent = _model.browseCurrent + 1;
					
					_browse.searchByCurCondition(_model.browseCurrent);
//					_controller.searchAuctionList(currentPage,_name.text,_list.getType(),getPayType(),-1,-1);
//					_controller.searchAuctionList(_model.browseCurrent,"",-1,-1,-1,-1);
				}
			}
		}
		
		private function __addMyAuction(event:DictionaryEvent):void
		{
			_sell.addAuction(event.data as AuctionGoodsInfo);
			_sell.clearLeft();
		}
		
		private function __clearMyAuction(event:DictionaryEvent):void
		{
			_sell.clearList();
		}
		
		private function __removeMyAuction(event:DictionaryEvent):void
		{
			_controller.searchAuctionList(_model.sellCurrent,"",-1,-1,PlayerManager.Instance.Self.ID,-1);
		}
		
		private function __updateMyAuction(event:DictionaryEvent):void
		{
			_sell.updateList(event.data as AuctionGoodsInfo);
		}
		
		private function __addBrowse(event:DictionaryEvent):void
		{
			_browse.addAuction(event.data as AuctionGoodsInfo);
			_browse.Right.help_mc.visible = false;
		}
		
		private function __removeBrowse(event:DictionaryEvent):void
		{
			//_browse.removeAuction();
			_browse.searchByCurCondition(_model.browseCurrent);
		}
		
		private function __updateBrowse(event:DictionaryEvent):void
		{
			_browse.updateAuction(event.data as AuctionGoodsInfo);
		}
		
		private function __clearBrowse(event:DictionaryEvent):void
		{
			_browse.clearList();
		}
		
		private function __browserTypeChange(event:AuctionHouseEvent):void
		{
			_browse.setSelectType(_model.currentBrowseGoodInfo);
			_model.browseCurrent = 1;
			_browse.searchByCurCondition(1);
//			_controller.searchAuctionList(1,"",_model.currentBrowseGoodInfo.ID,_browse.getPayType(),-1,-1);
		}
		
		private function __addBuyAuction(event:DictionaryEvent):void
		{
			_buy.addAuction(event.data as AuctionGoodsInfo);
		}
		
		private function __removeBuyAuction(event:DictionaryEvent):void
		{
			_buy.removeAuction();
			_controller.searchAuctionList(_model.browseCurrent,"",-1,-1,-1,PlayerManager.Instance.Self.ID);			
		}
		
		private function __clearBuyAuction(event:DictionaryEvent):void
		{
			_buy.clearList();
		}		
		
		private function __updateBuyAuction(event:DictionaryEvent):void
		{
			_buy.updateAuction(event.data as AuctionGoodsInfo);
		}
		
		private function __changeMoney(event:PlayerPropertyEvent):void
		{
			updateAccount();
		}
		
		private function __sellSortChange(e:AuctionHouseEvent):void
		{
			_browse.searchByCurCondition(_model.sellCurrent,PlayerManager.Instance.Self.ID);
		}
	}
}