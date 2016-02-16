package ddt.view.common
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import game.crazyTank.view.common.BlankCellBgAsset;
	import game.crazyTank.view.storeII.quickBuyAsset;
	
	import road.manager.SoundManager;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.ShopManager;
	import ddt.view.cells.BagCell;
	
	/**
	 * author Stork
	 * time 01/07/2010
	 * description 铁匠铺快捷购买面板视图
	 **/
	 
	public class QuickBuyFrameView extends quickBuyAsset
	{
		private var _stoneNumber:int = 1;
		private var tempNumber:int;
		public var _itemID:int;
		private var _itemTemplateInfo:ItemTemplateInfo;
		private var _cell:BagCell;
		private var _price:int;
		private var _reduceDerial:Boolean = true;
		private var _addDerial:Boolean = true;
		private var _shopItem:ShopItemInfo;
		
		public function QuickBuyFrameView()
		{
			super();
			init();
			initEvents();
		}
		
		public function set ItemID(ID:int):void
		{
			_itemID = ID;
			if(_itemID == EquipType.STRENGTH_STONE4)
			{
				_stoneNumber = 3;
				numText.text = "3"
			}else
			{
				stoneNumber = 1;
				numText.text = "1"
			}
			onNumberChange(null);
			_shopItem = ShopManager.Instance.getMoneyShopItemByTemplateID(_itemID);
			initInfo();
			refreshNumText();
		}
		
		public function get ItemID():int{
			return _itemID;
		}
		
		private function initInfo():void
		{
			_itemTemplateInfo = ItemManager.Instance.getTemplateById(_itemID);
			_cell.info = _itemTemplateInfo;
			if(_cell.info.TemplateID == 11233)
			{
				_cell.x      = 32;
				_cell.y      = 9;
				_cell.width  = 74;
				_cell.height = 73;
			}
		}
		
		private function init():void{
			_cell = new BagCell(0,null,true,new BlankCellBgAsset());
			_cell.x = materialCell.x - 11;
			_cell.y = materialCell.y - 11;
			addChild(_cell);
			reduceBtn.buttonMode = addBtn.buttonMode = true;
			refreshNumText();
			reduceBtn.gotoAndStop(1);
			addBtn.gotoAndStop(1);
			
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.color = 0xffff00;
			tf.bold = true;
			tf.size = 16;
			numText.defaultTextFormat = tf;
		}
		
		private function initEvents():void{
			reduceBtn.addEventListener(MouseEvent.MOUSE_DOWN,reduceMouseDownHandler);
			reduceBtn.addEventListener(MouseEvent.MOUSE_UP,reduceMouseUpHandler);
			reduceBtn.addEventListener(MouseEvent.CLICK,reduceBtnClickHandler);
			addBtn.addEventListener(MouseEvent.CLICK,addBtnClickHandler);
			addBtn.addEventListener(MouseEvent.MOUSE_DOWN,addMouseDownHandler);
			addBtn.addEventListener(MouseEvent.MOUSE_UP,addMouseUpHandler);
			numText.addEventListener(Event.CHANGE,onNumberChange);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
		}
		
		private function removeEvents():void
		{
			reduceBtn.removeEventListener(MouseEvent.MOUSE_DOWN,reduceMouseDownHandler);
			reduceBtn.removeEventListener(MouseEvent.MOUSE_UP,reduceMouseUpHandler);
			reduceBtn.removeEventListener(MouseEvent.CLICK,reduceBtnClickHandler);
			addBtn.removeEventListener(MouseEvent.CLICK,addBtnClickHandler);
			addBtn.removeEventListener(MouseEvent.MOUSE_DOWN,addMouseDownHandler);
			addBtn.removeEventListener(MouseEvent.MOUSE_UP,addMouseUpHandler);
			numText.removeEventListener(Event.CHANGE,onNumberChange);
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			
			numText.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
		}
		
		private function reduceMouseDownHandler(event:MouseEvent):void{
			if(_reduceDerial){
				reduceBtn.x --;
				reduceBtn.y ++;	
			}
		}
		
		private function reduceMouseUpHandler(event:MouseEvent):void{
			if(_reduceDerial){
				reduceBtn.x ++;
				reduceBtn.y --;	
			}
		}
		
		private function addMouseDownHandler(event:MouseEvent):void{
			if(_addDerial){
				addBtn.x ++;
				addBtn.y ++;	
			}
		}
		
		private function addMouseUpHandler(event:MouseEvent):void{
			if(_addDerial){
				addBtn.x --;
				addBtn.y --;	
			}	
		}
		
		private function addtoStageHandler(event:Event):void{
			numText.text = "";
			numText.appendText(String(_stoneNumber));
			stage.focus = numText;
			numText.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
		}
		
		private function focusOutHandler(event:FocusEvent):void{
			stage ? stage.focus = numText : null;
		}
		
		private function reduceBtnClickHandler(event:MouseEvent):void{
			_addDerial = true;
			if(_reduceDerial){
				addBtn.gotoAndStop(1);
				addBtn.buttonMode = true;
				if(this._stoneNumber > 1) {
				SoundManager.Instance.play("008");
				if(this._stoneNumber == 2){
					reduceBtn.gotoAndStop(2);
					reduceBtn.buttonMode = false;
					_reduceDerial = false;
				}
				this._stoneNumber --;
				refreshNumText();
				}
			}	
		}
		
		private function addBtnClickHandler(event:MouseEvent):void{
			_reduceDerial = true;
			if(_addDerial){
				reduceBtn.gotoAndStop(1);
				reduceBtn.buttonMode = true;
				if(this._stoneNumber < 99){
				SoundManager.Instance.play("008");
				if(this._stoneNumber == 98){
					addBtn.gotoAndStop(2);
					addBtn.buttonMode = false;
					_addDerial = false;
				}
				this._stoneNumber ++;
				refreshNumText();
				} 
			}
			
		}
		
		private function refreshNumText():void{
			numText.text = String(_stoneNumber);
			_price = _shopItem == null?0:_shopItem.getItemPrice(1).moneyValue;
			totalText.text = String(_stoneNumber * _price) + LanguageMgr.GetTranslation("ddt.auctionHouse.view.AuctionBrowseView.stipple");
		}
		
		private function onNumberChange(event:Event):void{
			checked();
			if(int(numText.text) > 99 || int(numText.text) < 1){
				refreshNumText();
			}else{
				if(int(numText.text) == 99){
					addBtn.gotoAndStop(2);
					addBtn.buttonMode = false;
					_addDerial = false;
				}
				if(int(numText.text) == 1){
					reduceBtn.gotoAndStop(2);
					reduceBtn.buttonMode = false;
					_reduceDerial = false;
				}
				if(int(numText.text) != 99 && int(numText.text) != 1){
					addBtn.buttonMode = reduceBtn.buttonMode = true;
					_addDerial = _reduceDerial = true;
				}
				_stoneNumber = int(numText.text);
				refreshNumText(); 
			}
		}
		
		private function checked():void{
			if(int(numText.text) >1) reduceBtn.gotoAndStop(1);
			if(int(numText.text) < 99) addBtn.gotoAndStop(1);
		}
		
		public function get stoneNumber():int{
			return _stoneNumber;
		}
		
		public function set stoneNumber(value:int):void{
			_stoneNumber = value;
			numText.text = String(_stoneNumber);
			onNumberChange(null);
			refreshNumText();
		}
		
		public function dispose():void
		{
			removeEvents();
			_cell.dispose();
			_cell = null;
			if(parent) parent.removeChild(this);
		}
		
	}
}