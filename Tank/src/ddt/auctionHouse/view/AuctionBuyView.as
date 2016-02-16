package ddt.auctionHouse.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.AuctionHouse.AuctionBuyAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	internal class AuctionBuyView extends AuctionBuyAsset
	{
		
		private var _bidMoney:BidMoneyView;
		
		private var _right:AuctionBuyRightView;
		
		/**
		 * 竟价按钮
		 */
		private var _bid_btn          : HBaseButton;
		
		/**
		 * 一品价按钮
		 */
		private var _mouthful_btn     : HBaseButton;
		
		
		/**************************
		 * 取消回车键
		 */
		 private var _btClickLock : Boolean; 
		 
		public function AuctionBuyView()
		{
			initView();
			addEvent();
			
		}
		
		private function initView():void
		{
			_bid_btn      = new HBaseButton(this.bid_btn);
			_mouthful_btn =  new HBaseButton(this.mouthful_btn);
			
			_bid_btn.useBackgoundPos = true;
			_mouthful_btn.useBackgoundPos = true;
			
			_bid_btn.enable = false;
			addChild(_bid_btn);
			addChild(_mouthful_btn);
						
			_bidMoney     = new BidMoneyView();
			_bidMoney.x   = bidMoneyPos_mc.x;
			_bidMoney.y   = bidMoneyPos_mc.y;
			bidMoneyPos_mc.visible = false;
			_bidMoney.cannotBid();
			addChild(_bidMoney);
			
			_right = new AuctionBuyRightView();
			addChild(_right);
			initialiseBtn();
		}
		private function addEvent():void
		{
			_right.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectRightStrip);

			_bid_btn.addEventListener(MouseEvent.CLICK,__bid);
			_mouthful_btn.addEventListener(MouseEvent.CLICK,__mouthFull);
			addEventListener(Event.ADDED_TO_STAGE,__addToStage);
			
			//add
		}
		
		private function __nextPage(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("047");
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
		}
		private function __prePage(evt : MouseEvent)  : void
		{
			SoundManager.Instance.play("047");
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
		}
		
		private function removeEvent():void
		{
			_right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectRightStrip);
			
			_bid_btn.removeEventListener(MouseEvent.CLICK,__bid);
			_mouthful_btn.removeEventListener(MouseEvent.CLICK,__mouthFull);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStage);
		}
		
		private function getBidPrice():int
		{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			var min:int;
			if(info.BuyerName == "")
			{
				min = info.Price;
			}
			else
			{
				min = info.Price + info.Rise;
			}
			return min;
		}	
		internal function hide() : void
		{
			//this._right.hide();
		}
		
		private function initialiseBtn():void
		{
			_mouthful_btn.enable = false;
			this._bid_btn.enable = false;
			//bid_btn.mouseEnabled = false;
			//bidII_btn.visible = true;
			_bidMoney.cannotBid();
		}
		
		internal function dispose():void
		{
			removeEvent();
			if(_mouthful_btn && _mouthful_btn.parent)_mouthful_btn.parent.removeChild(_mouthful_btn);
			if(_mouthful_btn)_mouthful_btn.dispose();
			_mouthful_btn = null;
			if(_bidMoney && _bidMoney.parent)_bidMoney.parent.removeChild(_bidMoney);
			if(_bidMoney)_bidMoney.dispose();
			_bidMoney = null;
			if(_right)_right.dispose();
			_right = null;
			if(parent)parent.removeChild(this);
		}
		
		internal function addAuction(info:AuctionGoodsInfo):void
		{
			_right.addAuction(info);	
		}
		
		internal function removeAuction():void
		{
			_bidMoney.cannotBid();
		}
		
		internal function updateAuction(info:AuctionGoodsInfo):void
		{
			_right.updateAuction(info);
			__selectRightStrip(null);
		}
		
		internal function clearList():void
		{
			_right.clearList();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function __selectRightStrip(event:AuctionHouseEvent):void
		{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info)
			{
				if(info.AuctioneerID == PlayerManager.Instance.Self.ID)
				{
					initialiseBtn();
					return;
				}
				_mouthful_btn.enable = (info.Mouthful == 0 ? false : true);
				_bid_btn.enable = (info.BuyerID == PlayerManager.Instance.Self.ID)?false : true;
				if(info.BuyerID!=PlayerManager.Instance.Self.ID)
				{
					_bidMoney.canMoneyBid(info.Price+info.Rise);
				}
				else
				{
					_bidMoney.cannotBid();
				}
			}
			
		}		
		
		private function __bid(event:MouseEvent):void
		{
			SoundManager.Instance.play("047");
//			_mouthful_btn.enable = false;
			
			//bid_btn.mouseEnabled = false;
			//bidII_btn.visible = true;
			_btClickLock = true;
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				__selectRightStrip(null);
				return;
			}
			this._bid_btn.enable = false;
			HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.sure"),true,__bidII,__cannel);
			//ConfirmDialog.show("提示","您确认竞拍该产品吗?",true,__bidII);
		}
		private function __bidII() : void
		{
			if(_btClickLock)
			{
				_btClickLock = false;
			}
			else
			{
				return ;
			}
			if(getBidPrice() > _bidMoney.getData()) 
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBuyView.price")+String(_bidMoney.getData())+LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBuyView.less")+String(getBidPrice()),true);
				//MessageTipManager.getInstance().show("竞拍价:"+String(_bidMoney.getData())+"小于起拍价与增值之和:"+String(getBidPrice()),true);
				return;	
			}
			if(_bidMoney.getData() > PlayerManager.Instance.Self.Money)
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBuyView.Your")+String(_bidMoney.getData()),true);
				//MessageTipManager.getInstance().show("你的余额不足"+String(_bidMoney.getData()),true);
				return;
			}
			
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info)
			{
			    SocketManager.Instance.out.auctionBid(info.AuctionID,_bidMoney.getData());
			}
		}
		
		private function __mouthFull(event:MouseEvent):void
		{
			SoundManager.Instance.play("047");
			_mouthful_btn.enable = false;
			_bid_btn.enable      = false;
			_btClickLock = true;
			if(PlayerManager.Instance.Self.bagLocked)
			{
				__selectRightStrip(null);
				new BagLockedGetFrame().show();
				return;
			}
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			
			if(info.Mouthful > PlayerManager.Instance.Self.Money)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBuyView.Your")+String(info.Mouthful),true);
				//MessageTipManager.getInstance().show("你的余额不足"+String(_bidMoney.getData()),true);
				return;
			}
			HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.buy"),true,__callMouthFull,__cannel);
			
		}
		private function __callMouthFull():void
		{
			if(_btClickLock)
			{
				_btClickLock = false;
			}
			else
			{
				return;
			}
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info){
				SocketManager.Instance.out.auctionBid(info.AuctionID,info.Mouthful);
				if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] == null)
				{
					SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = [];
				}
				for(var i:int = 0; i<SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].length;i++){
					if(SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID][i]==info.AuctionID){
						SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID].splice(i,1);
					}
				}
				SharedManager.Instance.save();
				_bidMoney.cannotBid();
				_right.clearSelectStrip();
			}	
		}
		private function __cannel() : void{
			var info:AuctionGoodsInfo = _right.getSelectInfo();
			if(info)
			{
				_mouthful_btn.enable = (info.Mouthful == 0 ? false : true);
				_bid_btn.enable = ((info.BuyerID == PlayerManager.Instance.Self.ID) ? false : true);
			}else
			{
				_mouthful_btn.enable = false;
				_bid_btn.enable = false;
			}
		}
		private function __addToStage(event:Event):void
		{
			initialiseBtn();
			_bidMoney.cannotBid();
			
		}
		
//		internal function setPage(start:int,totalCount:int):void
//		{
//			_right.setPage(start,totalCount);
//		}
	}
}