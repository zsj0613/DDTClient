package ddt.auctionHouse.controller
{
	import road.utils.ClassFactory;
	
	import ddt.auctionHouse.AuctionState;
	import ddt.auctionHouse.IAuctionHouse;
	import ddt.auctionHouse.model.AuctionHouseModel;
	import ddt.auctionHouse.view.AuctionHouseView;
	import ddt.auctionHouse.view.AuctionRightView;
	import ddt.data.auctionHouse.AuctionGoodsInfo;
	import ddt.data.goods.CateCoryInfo;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.request.LoadAuctionListAction;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	/**
	 *	拍卖行的BaseStateView
	 * @author 7 road
	 * 
	 */	
	public class AuctionHouseController extends BaseStateView
	{
		private var _model:AuctionHouseModel;
		
		private var _view:IAuctionHouse;
		
		public function AuctionHouseController()
		{
		}
		
		override public function prepare():void
		{
			super.prepare();
		}
		
		override public function enter(prev:BaseStateView, data:Object=null):void
		{
			super.enter(prev,data);
			_model = new AuctionHouseModel();
			_view = new AuctionHouseView(this,_model);
			_view.show();
			AuctionState.CURRENTSTATE = "browse";//竞标时使用
			_model.category = ItemManager.Instance.categorys;
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.setAuctionHouseState();
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,__updateAuction);
		}
		
		override public function leaving(next:BaseStateView):void
		{
			super.leaving(next);
			dispose();
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.AUCTION_REFRESH,__updateAuction);
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		override public function getType():String
		{
			return StateType.AUCTION;
		}
		
		public function setState(value:String):void
		{
			_model.state = value;
			AuctionState.CURRENTSTATE = value;//竞标时使用
		}

		public function browseTypeChange(info:CateCoryInfo,id:int = -1):void
		{
			var tempInfo:CateCoryInfo;
			if(info == null)
			{
				tempInfo = _model.getCatecoryById(id);
			}
			else
			{
				tempInfo = info;
			}
			_model.currentBrowseGoodInfo = tempInfo;
		}
		
		public function browseTypeChangeNull():void
		{
			_model.currentBrowseGoodInfo = null;
		}

		override public function dispose():void
		{
			super.dispose();
			if(_view)_view.hide();
			_view = null;
			
			if(_model)_model.dispose();
			_model = null;
		}
		
		public  function searchAuctionList(page:int,name:String,type:int,pay:int,userID:int,buyId:int,sortIndex:uint = 0,sortBy:String = "false",Auctions:String=""):void
		{
			if(AuctionHouseModel.searchType == 1)name = "";
			new LoadAuctionListAction(page,name,type,pay,userID,buyId,sortIndex,sortBy,Auctions).loadSync(__searchResult);
			(_view as AuctionHouseView).forbidChangeState();
		}
		

		private function __searchResult(action:LoadAuctionListAction):void
		{
			var list:Array = action.list;
			if(_model.state == AuctionState.SELL)
			{
				_model.clearMyAuction();
				for(var i:int = 0; i < list.length; i ++)
				{
					_model.addMyAuction(list[i]);
				}
				_model.sellTotal = action.total;
			}
			else if(_model.state == AuctionState.BROWSE)
			{
				_model.clearBrowseAuctionData();
				if(list.length == 0)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.controller.AuctionHouseController"));
					//MessageTipManager.getInstance().show("没有该类物品");
				}
				for(var j:int = 0; j < list.length; j ++)
				{
					_model.addBrowseAuctionData(list[j]);
				}
				_model.browseTotal = action.total;
				
			}
			else if(_model.state == AuctionState.BUY)
			{
				var auctionIDs:Array = new Array();
				_model.clearBuyAuctionData();
				for(var k:int = 0; k < list.length; k ++)
				{
					_model.addBuyAuctionData(list[k]);
					auctionIDs.push(list[k].AuctionID);
				}
				_model.buyTotal = action.total;
				SharedManager.Instance.AuctionIDs[PlayerManager.Instance.Self.ID] = auctionIDs;
				SharedManager.Instance.save();
			}
			(_view as AuctionHouseView).allowChangeState();
		}
		
		/**
		 * 更新拍卖信息 
		 * @param event
		 * 
		 */		
		private function __updateAuction(event:CrazyTankSocketEvent):void
		{
			
			event.pkg.depack();
			var info:AuctionGoodsInfo = new AuctionGoodsInfo();
			info.AuctionID = event.pkg.readInt();
			var isExist:Boolean = event.pkg.readBoolean();
			if(isExist)
			{
				info.AuctioneerID = event.pkg.readInt();
				info.AuctioneerName = event.pkg.readUTF();
				info.BeginDate = event.pkg.readDate();
				info.BuyerID = event.pkg.readInt();
				info.BuyerName = event.pkg.readUTF();
				info.ItemID = event.pkg.readInt();
				info.Mouthful = event.pkg.readInt();
				info.PayType = event.pkg.readInt();
				info.Price = event.pkg.readInt();
				info.Rise = event.pkg.readInt();
				info.ValidDate = event.pkg.readInt();
				var item:Boolean = event.pkg.readBoolean();
				if(item)
				{
					var bag:InventoryItemInfo = new InventoryItemInfo();
					bag.Count = event.pkg.readInt();
					bag.TemplateID = event.pkg.readInt();
					bag.AttackCompose = event.pkg.readInt();
					bag.DefendCompose = event.pkg.readInt();
					bag.AgilityCompose = event.pkg.readInt();
					bag.LuckCompose = event.pkg.readInt();
					bag.StrengthenLevel = event.pkg.readInt();
					bag.IsBinds = event.pkg.readBoolean();
					bag.IsJudge = event.pkg.readBoolean();
					bag.BeginDate = event.pkg.readDateString();
					bag.ValidDate = event.pkg.readInt();
					bag.Color = event.pkg.readUTF();
					bag.Skin = event.pkg.readUTF();
					bag.IsUsed = event.pkg.readBoolean();
					var templateInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(bag.TemplateID);
					ClassFactory.copyProperties(templateInfo,bag);
					info.BagItemInfo = bag;
					_model.sellTotal = _model.sellTotal + 1;
				}
				
				_model.addMyAuction(info);
			}
			else
			{
				_model.removeMyAuction(info);
			}
		}
		/* bret 09.8.2 右边视图新加的提示文字 */
		private var _rightView:AuctionRightView;
		public function visibleHelp(rightView:AuctionRightView,frame:int):void
		{
			_rightView = rightView;
			_rightView.help_mc.visible = false;
		}

	}
}