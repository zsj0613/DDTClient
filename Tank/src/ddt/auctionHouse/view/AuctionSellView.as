package ddt.auctionHouse.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.AuctionHouse.AuctionSellAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.auctionHouse.AuctionState;
	import ddt.auctionHouse.controller.AuctionHouseController;
	import ddt.auctionHouse.event.AuctionHouseEvent;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.DisposeUtils;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	[Event(name = "nextPage",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	[Event(name = "prePage",type = "ddt.auctionHouse.event.AuctionHouseEvent")]
	public class AuctionSellView extends AuctionSellAsset
	{
		
		private var _left:AuctionSellLeftView;
		private var _right:AuctionRightView;
		private  var _controller:AuctionHouseController;
		
		
		private var _cancelBid_btn : HBaseButton;
		
		/**************************
		 *   取消回车键
		 */
		 private var _btClickLock : Boolean;
		
		public function AuctionSellView(controller:AuctionHouseController)
		{
			_controller = controller;
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			_cancelBid_btn = new HBaseButton(cancelBid_btn);
			_cancelBid_btn.useBackgoundPos = true;
			addChild(_cancelBid_btn);
			
			_left = new AuctionSellLeftView();
			addChildAt(_left,0);
			
			_right = new AuctionRightView(AuctionState.SELL);
			addChild(_right);
			_right.x = rightPos_mc.x;
			_right.y = rightPos_mc.y;
			rightPos_mc.visible = false;
		}
		
		private function addEvent():void
		{
			_cancelBid_btn.addEventListener(MouseEvent.CLICK,__cancel);
			addEventListener(Event.REMOVED_FROM_STAGE,__removeStage);
			_right._prePage_btn.addEventListener(MouseEvent.CLICK,__pre);
			_right._nextPage_btn.addEventListener(MouseEvent.CLICK,__next);
			_right.addEventListener(AuctionHouseEvent.SORT_CHANGE,sortChange);
			_right.addEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
			this.addEventListener(Event.ADDED_TO_STAGE, __addToStage);
		}
		
		private function removeEvent():void
		{
			_right.removeEventListener(AuctionHouseEvent.SORT_CHANGE,sortChange);
			_cancelBid_btn.removeEventListener(MouseEvent.CLICK,__cancel);
			removeEventListener(Event.REMOVED_FROM_STAGE,__removeStage);
			_right._prePage_btn.removeEventListener(MouseEvent.CLICK,__pre);
			_right._nextPage_btn.removeEventListener(MouseEvent.CLICK,__next);
			_right.removeEventListener(AuctionHouseEvent.SELECT_STRIP,__selectStrip);
			this.removeEventListener(Event.ADDED_TO_STAGE, __addToStage);
		}
		private function __addToStage(evt : Event) : void
		{
			_cancelBid_btn.enable = false;
			this._left.addStage();
		}
		
		internal function clearLeft():void
		{
			_left.clear();
		}
		
		internal function clearList():void
		{
			_right.clearList();
		}
		internal function hideReady() : void
		{
			this._left.hideReady();
			this._right.hideReady();
		}
		
		internal function addAuction(info:AuctionGoodsInfo):void
		{
			_right.addAuction(info);
			
		}
		
		internal function setPage(start:int,totalCount:int):void
		{
			_right.setPage(start,totalCount);
		}
		
		internal function dispose():void
		{
			removeEvent();
			if(parent)parent.removeChild(this);
			if(_right)_right.dispose();
			_right = null;
			DisposeUtils.disposeHBaseButton(_cancelBid_btn);
			if(_left)_left.dispose();
			_left = null;
			
			_controller = null;
		}
		
		internal function updateList(info:AuctionGoodsInfo):void
		{
			_right.updateAuction(info);
			
		}
		
		private function __cancel(event:MouseEvent):void
		{
			SoundManager.Instance.play("043");
			_btClickLock = true;
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			_cancelBid_btn.enable = false;
			HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellView.cancel"),true,__cancelOk,__cannelNo);
			//ConfirmDialog.show("提示","您确认取消本次拍卖吗?",true,__cancelII);
			
		}
		
		private function __cancelOk() : void
		{
			if(_btClickLock)
			{
				_btClickLock = false;
			}
			else
			{
				return;
			}
			if(_right.getSelectInfo())
			{
				if(_right.getSelectInfo().BuyerName != "")
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellView.Price"));
					return;
				}
				SocketManager.Instance.out.auctionCancelSell(_right.getSelectInfo().AuctionID);
				_right.clearSelectStrip();
			}
			else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellView.Choose"));
			}
			SoundManager.Instance.play("008");
			_cancelBid_btn.enable = false;
		}
		private function __cannelNo() : void
		{
			SoundManager.Instance.play("008");
			_cancelBid_btn.enable = true;
		}
		
		
		
		private function __removeStage(event:Event):void
		{
			_left.clear();
			
		}		
		
		private function __next(event:MouseEvent):void
		{
			SoundManager.Instance.play("047");
			_cancelBid_btn.enable = false;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.NEXT_PAGE));
		}
		
		private function __pre(event:MouseEvent):void
		{
			SoundManager.Instance.play("047");
			_cancelBid_btn.enable = false;
			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.PRE_PAGE));
		}
		
		private function sortChange(e:AuctionHouseEvent):void
		{
//			dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SORT_CHANGE));
			_cancelBid_btn.enable = false;
			_controller.searchAuctionList(1,"",-1,-1,PlayerManager.Instance.Self.ID,-1,_right.sortCondition,_right.sortBy.toString());
		}
		
		internal function searchByCurCondition(currentPage:int,playerID:int = -1):void
		{
			_controller.searchAuctionList(currentPage,"",-1,-1,playerID,-1,_right.sortCondition,_right.sortBy.toString());
		}
		
		private function __selectStrip(event:AuctionHouseEvent):void
		{
			if(_right.getSelectInfo())
			{
				if(_right.getSelectInfo().BuyerName != "")
				{
					_cancelBid_btn.enable = false;
				}
				else
				{
					_cancelBid_btn.enable = true;
				}
			}
		}
		
		public function get Right():AuctionRightView
		{
			return _right;
		}
	}
}