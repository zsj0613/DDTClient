package ddt.auctionHouse.view
{
	import fl.controls.ComboBox;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.AuctionHouse.AuctionObjectAsset;
	import game.crazyTank.view.AuctionHouse.SelectTimeIAsset;
	import game.crazyTank.view.AuctionHouse.SelectTimeIIAsset;
	import game.crazyTank.view.AuctionHouse.SelectTimeIIIAsset;
	import game.crazyTank.view.AuctionHouse.SellLeftAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HYellowGlowButton;
	import road.utils.ComponentHelper;
	
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.manager.ToolTipManager;
	import ddt.utils.DisposeUtils;
	import ddt.utils.StringUtils;
	import ddt.view.cells.DragEffect;
	import ddt.view.common.FastPurchaseGoldBox;

	internal class AuctionSellLeftView extends SellLeftAsset implements IAcceptDrag
	{
		private var _cellGoodsID:int;
		private var _cell:AuctionCellView;
		
		private var _dragArea : AuctionDragInArea;
		
		private var _cellsItems: Array;
		
		private var _bag:BagFrame;
		
		private var _startMoney:TextField;
		/**
		 *  排 卖 时 限
		 */		
		private var _bidTime:ComboBox;

		
		private var _mouthfulM:TextField;
		
		private var _keep:TextField;
		
		private var _selectRate : Number = 1;// 选择保管时间
		private var _bid_btn    : HBaseButton;
		private var _bidTime1   : HYellowGlowButton;
		private var _bidTime2   : HYellowGlowButton;
		private var _bidTime3   : HYellowGlowButton; 
		private var _currentTime : HYellowGlowButton;
		private var _auctionObject : HYellowGlowButton;
		
		public function AuctionSellLeftView()
		{
			initView();
			addEvent();
		}
		
		private function initView():void
		{
			
			_bid_btn           = new HBaseButton(bid_btn);
			_bid_btn.useBackgoundPos = true;
			addChild(_bid_btn);
			_bid_btn.enable     = false;
			name_txt.selectable = false;
			name_txt.mouseEnabled = false;
			
			_bidTime1 = new HYellowGlowButton(new Bitmap(new SelectTimeIAsset(65,30)),"bidTime1","times");
			_bidTime2 = new HYellowGlowButton(new Bitmap(new SelectTimeIIAsset(65,30)),"bidTime2","times");
			_bidTime3 = new HYellowGlowButton(new Bitmap(new SelectTimeIIIAsset(65,30)),"bidTime3","times");
			_auctionObject = new HYellowGlowButton(new Bitmap(new AuctionObjectAsset(198,48)));
			ComponentHelper.replaceChild(this,bidTime1,_bidTime1);
			ComponentHelper.replaceChild(this,bidTime2,_bidTime2);
			ComponentHelper.replaceChild(this,bidTime3,_bidTime3);
			ComponentHelper.replaceChild(this,auctionObject,_auctionObject);
			
			if(_currentTime)_currentTime.revert();
			_bidTime1.currentItem();
			_currentTime = _bidTime1;
			_selectRate = 1;
			
			_cellsItems        = new Array();
			
			_cell              = new AuctionCellView();
//			_cell.x            = goodPos_mc.x;
//			_cell.y            = goodPos_mc.y;
			_cellsItems.push(_cell);
			_cell.buttonMode   = true;
			goodPos_mc.visible = false;
			
			ToolTipManager.addTip(_auctionObject,LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.Choose"),new Point(-35,-40));
			
			_dragArea          = new AuctionDragInArea(_cellsItems);
			addChildAt(_dragArea,0);
			_auctionObject.addChild(_cell);
			_auctionObject.addChild(name_txt);
			name_txt.x = 53;
			name_txt.y = 15;
			
			
			_bag = new BagFrame();
			_startMoney = createText();
			_startMoney.maxChars = 9;
			ComponentHelper.replaceChild(this,startMoneyPos_mc,_startMoney);
			
			_mouthfulM = createText();
			_mouthfulM.maxChars = 9;
			ComponentHelper.replaceChild(this,mouthfulMPos_mc,_mouthfulM);
			
			_keep = createText(TextFieldType.DYNAMIC);
			_keep.selectable = false;
			_keep.autoSize = TextFieldAutoSize.RIGHT;
			ComponentHelper.replaceChild(this,keepPos_mc,_keep);
			
			clear();
//			
			_cell.mouseEnabled = false;
			hot_btn.mouseEnabled = false;
		}
		
		
		private function addEvent():void
		{
			_cell.addEventListener(AuctionCellView.SELECT_BID_GOOD,__setBidGood);
			_cell.addEventListener(Event.CHANGE,__selectGood);
			_bid_btn.addEventListener(MouseEvent.CLICK,__startBid);
			_startMoney.addEventListener(Event.CHANGE,__change);
			_mouthfulM.addEventListener(Event.CHANGE,__change);
			_startMoney.addEventListener(TextEvent.TEXT_INPUT,__textInput);
			_mouthfulM.addEventListener(TextEvent.TEXT_INPUT,__textInputMouth);
			_auctionObject.addEventListener(MouseEvent.CLICK,_onAuctionObjectClicked);
//			
		    _bidTime1.addEventListener(MouseEvent.CLICK,   __selectBidTimeII);
		    _bidTime2.addEventListener(MouseEvent.CLICK,   __selectBidTimeII);
		    _bidTime3.addEventListener(MouseEvent.CLICK,   __selectBidTimeII);
//			_timeButtonItems.addEventListener("change",     __selectBidTimeII);
		}
		private function __selectBidTimeII(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			if(_currentTime != evt.currentTarget)_currentTime.revert();
			switch(evt.currentTarget.name)
			{
				case _bidTime1.name:
				  _currentTime = _bidTime1;
				  _selectRate = 1;
				break;
				case _bidTime2.name:
				  _currentTime = _bidTime2;
				  _selectRate = 2;
				break
				case _bidTime3.name:
				  _currentTime = _bidTime3;
				_selectRate = 3;
				break;
				default :
				  _currentTime = _bidTime1;
				  _selectRate = 1;
			}
			if(_currentTime)_currentTime.currentItem();
			update();
		}
		
		private function removeEvent():void
		{
			_cell.removeEventListener(AuctionCellView.SELECT_BID_GOOD,__setBidGood);
			_cell.removeEventListener(Event.CHANGE,__selectGood);
			_bid_btn.removeEventListener(MouseEvent.CLICK,__startBid);
			_startMoney.removeEventListener(Event.CHANGE,__change);
			_mouthfulM.removeEventListener(Event.CHANGE,__change);
			_startMoney.removeEventListener(TextEvent.TEXT_INPUT,__textInput);
			_mouthfulM.removeEventListener(TextEvent.TEXT_INPUT,__textInputMouth);
			_auctionObject.removeEventListener(MouseEvent.CLICK,_onAuctionObjectClicked);
			
			
		    _bidTime1.removeEventListener(MouseEvent.CLICK,   __selectBidTimeII);
		    _bidTime2.removeEventListener(MouseEvent.CLICK,   __selectBidTimeII);
		    _bidTime3.removeEventListener(MouseEvent.CLICK,   __selectBidTimeII);
			
		}
		
		
		
		
		internal function addStage() : void
		{
            _bidTime1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function dragDrop(effect:DragEffect):void
		{
			_cell.dragDrop(effect);
		}
		
		private function createText(type:String = TextFieldType.INPUT):TextField
		{
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			format.size = 14;
			format.bold = true;
			format.font = "Arial";
			var txt:TextField = new TextField();
			txt.defaultTextFormat = format;
			txt.type = type;
			txt.restrict = "0-9";
			return txt;
		}
		
		internal function clear():void
		{
			name_txt.text = "";
			_startMoney.text = "";
			_mouthfulM.text = "";
			_keep.text = "";
			if(_cell.getSource() && _cell.info)_cell.clearLinkCell();
			_startMoney.mouseEnabled = false;
			_mouthfulM.mouseEnabled = false;
			_bidTime1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//_bag.hide();
		}
		internal function hideReady() : void
		{
			_bag.hide();
		}
		private function update():void
		{
			_keep.text = getKeep();
		}
		
		private function getRate():int
		{
			return this._selectRate;
		}
		
		private function getKeep():String
		{
			if(_selectRate == 1)return "100";
			if(_selectRate == 2)return "200";
			if(_selectRate == 3)return "300";
			return "100";
		}
		
		internal function dispose():void
		{
			removeEvent();
		    DisposeUtils.disposeHBaseButton(_bid_btn);
		    DisposeUtils.disposeHBaseButton(_bidTime1);
		    DisposeUtils.disposeHBaseButton(_bidTime2);
		    DisposeUtils.disposeHBaseButton(_bidTime3);
		    DisposeUtils.disposeHBaseButton(_auctionObject);
			if(parent)parent.removeChild(this);
			if(_cell)_cell.dispose();
			_cell = null;
			if(_bag)_bag.dispose();
			_bag = null;
			if(_startMoney.parent)removeChild(_startMoney);
			_startMoney = null;
			if(_mouthfulM.parent)removeChild(_mouthfulM);
			_mouthfulM = null;
			if(_keep.parent)removeChild(_keep);
			_keep = null;
		}
		private function _onAuctionObjectClicked(evt:Event):void{
			if(_cell.info && _bag.parent){
				_cell.onObjectClicked();
				return;
			}
			__setBidGood(null);
		}
		private function __setBidGood(event:Event):void
		{
			if(_cell && _cell.info) _cellGoodsID=_cell.info.TemplateID;
			
			if(!_cell.info || !_bag.parent){
				_bag.open();
				SoundManager.instance.play("047");
			}
		}
		
		
		
		private function __selectGood(event:Event):void
		{

			
			if(_cell.info)
			{
				initInfo();
				//_bag.hide();
			}
			else
			{
				clear();
				LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.Choose")

				ToolTipManager.addTip(_auctionObject,LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.Choose"),new Point(-35,-40));
				_bid_btn.enable     = false;
			}
		}	
		
		//TODO 取出拍卖物品的信息
		private function initInfo():void
		{
			ToolTipManager.removeTip(_auctionObject);
			name_txt.text = _cell.info.Name;
			_startMoney.mouseEnabled = true;
			_mouthfulM.mouseEnabled = true;
			_bid_btn.enable         = true;
			if(SharedManager.Instance.AuctionInfos!=null&&SharedManager.Instance.AuctionInfos[_cell.info.Name]!=null)
			{
				var obj:Object = SharedManager.Instance.AuctionInfos[_cell.info.Name];
				if(obj)
				{
					_mouthfulM.text = (obj.mouthfulPrice==0?"":obj.mouthfulPrice);
		     		_startMoney.text = obj.startPrice;
		     		switch(obj.time)
		     		{
		     			case 0:
							_bidTime1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			                break;
			            case 1:
							_bidTime2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			                break;
			            case 2:
							_bidTime3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			                break;
			            default:
			                _bidTime1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			                break;
		     		}
				}
			}
			else
			{
				_bidTime1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}	
		
		private function __startBid(event:MouseEvent):void
		{
			SoundManager.instance.play("047");
			if(!_cell.info)
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.ChooseTwo"));
				//MessageTipManager.getInstance().show("请选择要拍卖的物品");
				return;
			}
			if( _startMoney.text == "")
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.Price"));
				//MessageTipManager.getInstance().show("请填写起始价格");
				return;
			}
			if(_mouthfulM.text != "" && _startMoney.text != "")
			{
				if(StringUtils.CompareString(_mouthfulM.text,_startMoney.text) != 1)
				{
					
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.PriceTwo"));
					//MessageTipManager.getInstance().show("一口价不能低于起始价");
					return;
				}
			}
			
			if(Number(_keep.text) > PlayerManager.Instance.Self.Gold){
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
//				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionSellLeftView.storage"));
				//MessageTipManager.getInstance().show("保管费不够");
				return;
			}
			auctionGood();
			
		}
		
		private function auctionGood():void
		{
			if(_cell.info)
			{
				var bagType:int = (_cell.info as InventoryItemInfo).BagType;
				var place:int = (_cell.info as InventoryItemInfo).Place;
				var price:int = Math.floor(Number(_startMoney.text));
				var mouthful:int;
				mouthful = (_mouthfulM.text == "") ? 0 : Math.floor(Number(_mouthfulM.text));
				var validTime:int = _selectRate - 1;//Math.floor(_selectRate/3);
				SocketManager.Instance.out.auctionGood(bagType,place,1,price,mouthful,validTime);
				var obj:Object = {};
				obj.itemName = _cell.info.Name;
				obj.startPrice = price;
				obj.mouthfulPrice = mouthful;
				obj.time = validTime;
				SharedManager.Instance.AuctionInfos[_cell.info.Name] = obj;
				SharedManager.Instance.save();
			}
			
			_bidTime1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			_startMoney.stage.focus = null;
			_mouthfulM.stage.focus = null;
		}
		
		private function __change(event:Event):void
		{
			//在输入1000，删去前面的1，变成000类型数据时，是错误的，所以加验证
			if(Number(_startMoney.text) == 0)
			{
				_startMoney.text = "";
				
			}
			update();
		}
		
		private function __textInput(event:TextEvent):void
		{
			if(Number(_keep.text) + Number(event.text) == 0)
			{
				if(_keep.selectedText.length<=0)
					event.preventDefault();
				
			}
		}
		
		private function __textInputMouth(event:TextEvent):void
		{
			var txt:TextField = event.target  as TextField;
			if(Number(txt.text) + Number(event.text) == 0)
			{
				if(txt.selectedText.length<=0)
					event.preventDefault();
			}
		}
		
		
		private function __timeChange(event:Event):void
		{
			update();
		}
	}
}