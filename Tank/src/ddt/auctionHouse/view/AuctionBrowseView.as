package ddt.auctionHouse.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.AuctionHouse.AuctionBrowseAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.auctionHouse.controller.AuctionHouseController;
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.data.goods.CateCoryInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	internal class AuctionBrowseView extends AuctionBrowseAsset
	{
		private var _list:BrowseLeftMenuView;
		
		private var _bidMoney:BidMoneyView;
		
		private var _right:AuctionRightView;	
		
		private var _controller:AuctionHouseController;	
		
		/**************************
		 * 取消回车键
		 */
		 private var _btClickLock : Boolean; 
		 
		 private var _bid_btn  : HBaseButton;
		 private var _mouthful_btn : HBaseButton;
		
		/**
		 * 显示的数据是否点搜索按钮得来的数据 
		 */		
		private var _isSearch:Boolean;
	
		public function AuctionBrowseView(controller:AuctionHouseController)
		{
			_controller = controller;
			super();
			initView();
			addEvent();
		}
		
		private function  initView():void
		{	
			
			_bidMoney = new BidMoneyView();
			_bidMoney.x = bidMoneyPos_mc.x;
			_bidMoney.y = bidMoneyPos_mc.y;
			_bidMoney.cannotBid();
			addChild(_bidMoney);
			bidMoneyPos_mc.visible = false;
			
			_right = new AuctionRightView();
			addChild(_right);
			_right.x = rightPos_mc.x;
			_right.y = rightPos_mc.y;
			rightPos_mc.visible = false;
			
			_list = new BrowseLeftMenuView();
			addChild(_list);
			
					
			_bid_btn   = new HBaseButton(bid_btn);
			_bid_btn.useBackgoundPos  = true;
			addChild(_bid_btn);
			
			_mouthful_btn = new HBaseButton(mouthful_btn);
			_mouthful_btn.useBackgoundPos = true;
			addChild(_mouthful_btn);
			
			initialiseBtn();	
		} 
		
		private function initialiseBtn():void
		{
			_mouthful_btn.enable = false;
			_bid_btn.enable = false;
			
			_bidMoney.cannotBid();
		}
		
		private function addEvent():void
		{
			_right._prePage_btn.addEventListener(MouseEvent.CLICK,__pre);
			_right._nextPage_btn.addEventListener(MouseEvent.CLICK,__next);			
			_right.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectRightStrip);
			_right.addEventListener(AuctionHouseEvent.SORT_CHANGE,sortChange);		
			_list.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectLeftStrip);			
			_bid_btn.addEventListener(MouseEvent.CLICK,__bid);
			_mouthful_btn.addEventListener(MouseEvent.CLICK,__mouthFull);			
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);	
			
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_UPDATE,__updateAuction);		
			
		}
		
		private function removeEvent():void
		{
			_right._prePage_btn.removeEventListener(MouseEvent.CLICK,__pre);
			_right._nextPage_btn.removeEventListener(MouseEvent.CLICK,__next);			
			_right.removeEventListener(AuctionHouseEvent.SORT_CHANGE,sortChange);
			_right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectRightStrip);			
			_list.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectLeftStrip);			
			_bid_btn.removeEventListener(MouseEvent.CLICK,__bid);
			_mouthful_btn.removeEventListener(MouseEvent.CLICK,__mouthFull);			
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_UPDATE,__updateAuction);
		}
		
		private function searchByName():void
		{
			var info:ItemTemplateInfo = ItemManager.Instance.getTemplateByName(_list.searchText);
			if(info == null)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.model"),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.modelErrorInfo"),true);
				return;
			}
			_controller.browseTypeChange(null,info.CategoryID);
		}

		internal function addAuction(info:AuctionGoodsInfo):void
		{
			_right.addAuction(info);
//			checkPlayerMoney();
		}
		
		internal function updateAuction(info:AuctionGoodsInfo):void
		{
			_right.updateAuction(info);
			__selectRightStrip(null);
//			checkPlayerMoney();
		}
		
		internal function removeAuction():void
		{
			__searchCondition(null);
		}
		internal function hideReady() : void
		{
			this._right.hideReady();
		}
		internal function clearList():void
		{
			_right.clearList();
		}
		internal function setCategory(value:Array):void
		{
			_list.setCategory(value);
		}
		
		internal function setPage(start:int,totalCount:int):void
		{
			_right.setPage(start,totalCount);
		}
		
		internal function dispose():void
		{
		   removeEvent();
		   DisposeUtils.disposeHBaseButton(_bid_btn);
		   DisposeUtils.disposeHBaseButton(_mouthful_btn);
			if(_list)
			{
				if(_list.parent)_list.parent.removeChild(_list);
				_list.dispose();
				_list = null;
			}
			if(_bidMoney)_bidMoney.dispose();
			_bidMoney = null;
			
			if(_right)_right.dispose();
			_right = null;
			
			_controller = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}	
		
		
		internal function setSelectType(type:CateCoryInfo):void
		{
			initialiseBtn();
			_list.setSelectType(type);
		}	
		
		internal function getLeftInfo():CateCoryInfo
		{
			return _list.getInfo();
		}
		
		internal function setTextEmpty():void
		{
			_list.searchText = "";
		}

		
		internal function getPayType():int
		{
			return -1;
		}
		
		internal function searchByCurCondition(currentPage:int,playerID:int = -1):void
		{
			
			if(playerID != -1){
				_controller.searchAuctionList(currentPage,"",_list.getType(),-1,playerID,-1,_right.sortCondition,_right.sortBy.toString());
				return
			}
//			
			if(_isSearch)
			{
				
				_controller.searchAuctionList(currentPage,_list.searchText,_list.getType(),getPayType(),playerID,-1,_right.sortCondition,_right.sortBy.toString());
			}
			else
			{
				_controller.searchAuctionList(currentPage,_list.searchText,_list.getType(),-1,playerID,-1,_right.sortCondition,_right.sortBy.toString());
//				_list.searchText = "";
			}
			_bidMoney.cannotBid();
		}
		
		private function getBidPrice():int
		{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info)
			{
				return (info.BuyerName == "" ? info.Price : (info.Price + info.Rise));
			}
			else
			{
				return 0;
			}
		}		
		//起始价
		private function getPrice() : int
		{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			return (info ? info.Price : 0);
		}
		//一口价
		private function getMouthful() : int
		{
			
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			return (info ? info.Mouthful : 0);
		} 
		private function __searchCondition(event:MouseEvent):void
		{
			_isSearch = true;
			_list.getInfo() == null ? _controller.browseTypeChangeNull() : _controller.browseTypeChange(_list.getInfo());
		}
		
		private function keyEnterHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
				__searchCondition(null);
		}
		
		private function __next(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
			_bid_btn.enable = false;
			_mouthful_btn.enable = false;
		}
		
		private function __pre(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
			_bid_btn.enable = false;
			_mouthful_btn.enable = false;
		}
		
		
		private function __selectLeftStrip(event:AuctionHouseEvent):void
		{
			_isSearch = false;
			_controller.browseTypeChange(_list.getInfo());
		}	
		
		private function __selectRightStrip(event:AuctionHouseEvent):void
		{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info == null || info.AuctioneerID == PlayerManager.Instance.Self.ID)
			{
				initialiseBtn();
				return;
			}
			if(info.BuyerID == PlayerManager.Instance.Self.ID)
			{
				initialiseBtn();
				_mouthful_btn.enable = ((info.Mouthful == 0 || getMouthful() > PlayerManager.Instance.Self.Money) ? false : true) ;
				return;
			}
			_mouthful_btn.enable = info.Mouthful == 0  ? false : true;
			info.PayType == 0 ? _bidMoney.canGoldBid(getBidPrice()) : _bidMoney.canMoneyBid(getBidPrice());
			_bid_btn.enable = true;
			
		}
		
		private function __bid(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			_btClickLock = true;
			checkPlayerMoney();
			_bid_btn.enable = false;
			if(_bidMoney.getData() > PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				//显示您的点券余额不足，是否充值
			}else{
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					__selectRightStrip(null);
					return;
				}

		    	HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.sure"),true,__bidOk,__cancel);
		    	//ConfirmDialog.show("提示","您确认竞拍该产品吗?",true,__bidII,__cancel);
			}
//			_bidMoney.cannotBid();
		}
		
		private function __bidOk() : void
		{
			if(_btClickLock)
			_btClickLock = false;
			else
			return;
			
			if(getBidPrice() > _bidMoney.getData()) 
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.Auction")+String(getBidPrice())+LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple"));
				_bid_btn.enable = true;
				return ;	
			}
			else if(_bidMoney.getData() > PlayerManager.Instance.Self.Money)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.Your")+String(_bidMoney.getData())+LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple"));
				return ;
			}
			if(getMouthful() != 0 && _bidMoney.getData() >= getMouthful())
			{
				//输入拍卖价大于或等于一口价
				_btClickLock         = true;
			    _mouthful_btn.enable = false;
			    _bid_btn.enable      = false;
				__mouthFullOk();
				return;
			}
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info)
			{
				SocketManager.Instance.out.auctionBid(info.AuctionID,_bidMoney.getData());
				info = null;
			}
			
		}
		
		//这里是判断玩家手上的钱,是否大于一口价,当前竟价
		private function checkPlayerMoney() : void
		{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			_bid_btn.enable = false;
			_mouthful_btn.enable = false;
			
			if(info == null) return;
			if(info.Mouthful != 0 && getMouthful() <= PlayerManager.Instance.Self.Money)
			_mouthful_btn.enable = true;
			
		}
		
		private function __cancel() : void
		{
			__selectRightStrip(new AuctionHouseEvent(""));
		}

		private function __mouthFull(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			_btClickLock = true;
			_mouthful_btn.enable = false;
			_bid_btn.enable = false;//_bidMoney.getData() <= PlayerManager.Instance.Self.Money;
			if(getMouthful()>PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,__cancel);
				//您的点券不足，是否充值？
			}else{
				if(PlayerManager.Instance.Self.bagLocked)
				{
					new BagLockedGetFrame().show();
					__selectRightStrip(null);
					return;
				}
			    HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.buy"),true,__mouthFullOk,__cancel,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
			    //ConfirmDialog.show("提示","您确认一口价买下该产品吗?",true,__mouthFullII,__cancel);
			}
//			_bidMoney.cannotBid();
		}
		
		private function __mouthFullOk() : void
		{
			if(_btClickLock)
			_btClickLock = false;			
			else
			return;
			if(getMouthful() > PlayerManager.Instance.Self.Money)
			{
				_bid_btn.enable = true;
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.Your")+String(getMouthful())+LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple"));
				//MessageTipManager.getInstance().show("你的余额不足"+String(getMouthful())+"点券");
				return ;
			}
			
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info && info.AuctionID && info.Mouthful)
			{
				SocketManager.Instance.out.auctionBid(info.AuctionID,info.Mouthful);
				_right.clearSelectStrip();
				_bidMoney.cannotBid();
			}
			
		}
		
		private function __updateAuction(evt:CrazyTankSocketEvent):void
		{
			var succes:Boolean = evt.pkg.readBoolean();
			if(succes)
			{
				var auctionID:int = evt.pkg.readInt();
				if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
				{
					SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
				}
				SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].push(auctionID);
		    	SharedManager.Instance.save();
			}
		}
		
		private function __addToStage(event:Event):void
		{
			initialiseBtn();
			_bidMoney.cannotBid();
			_right.addStageInit();
		}
		private function sortChange(e:AuctionHouseEvent):void
		{
			__searchCondition(null);
		}
		/* bret 09.8.2 */
		public function get Right():AuctionRightView
		{
			return _right;
		}
	}
}