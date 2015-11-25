package ddt.shop.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	
	import game.crazyTank.view.shopII.GoodsItemAsset;
	
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.ISelectable;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.data.Price;
	import ddt.data.goods.ShopItemInfo;
	import ddt.view.bagII.GoodsTipPanel;
	import ddt.view.cells.BaseCell;
	import ddt.manager.ShopManager;
	
	public class ShopGoodsItem extends BaseCell implements ISelectable
	{
		public static const ADDTOCAR:String = "addtocar";
		
		private var _price:Sprite;
		private var _selected:Boolean;
		private var _isSTipOver:Boolean;
		private var _isBGOver:Boolean;
		private var _shopGoodsTip:GoodsTipPanel;
		
		private var _shopItemInfo:ShopItemInfo;
		
		private var sendToCarBtn:HBaseButton;

		public function ShopGoodsItem()
		{
			
			super(new GoodsItemAsset());
			init();
		}
		
		private function init():void
		{	
			sendToCarBtn = new HBaseButton(_bg["sendtocarBtnAccect"]);
			
			sendToCarBtn.useBackgoundPos = true;
			_bg.mouseChildren = false;
			_bg["name_txt"].text = "";
			_bg["name_txt"].antiAliasType = AntiAliasType.ADVANCED;
			_bg["name_txt"].gridFitType=GridFitType.PIXEL;
			_bg["name_txt"].sharpness = 400;
			_bg["bg_mc"].gotoAndStop(1);

			_bg["name_txt"].mouseEnabled = false;
			
			_bg["priceUnit"].gotoAndStop(1);
			sendToCarBtn.addEventListener(MouseEvent.CLICK,__sendToCarClick,false,0,true);
			addChild(sendToCarBtn);
			_bg["tip_mc"].gotoAndStop(1);
			_bg["tip_mc"].visible = false;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			_bg["bg_mc"].gotoAndStop(_selected ? 3 : checkType());
		}
		
		private function checkType():int{
			if(_shopItemInfo){
				return _shopItemInfo.ShopID == 1 ? 1 : 2;	
			}
			return 1;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set shopItemInfo(value:ShopItemInfo):void
		{
			if(value == null)
			{
				super.info = null;
			}else
			{
				super.info = value.TemplateInfo;
			}
			if(_shopItemInfo)
			{
				_shopItemInfo.removeEventListener(Event.CHANGE,__updateShopItem);
			}
			_shopItemInfo = value;
			if(_info != null)
			{
				_bg["name_txt"].text = String(_info.Name);
				initPrice();
				_bg["sendtocarBtnAccect"].visible = true;
				sendToCarBtn.visible = true;
				buttonMode = true;
				if(_pic)
				{
					_pic.addEventListener(MouseEvent.MOUSE_OVER,__onMouseOver);
					_pic.addEventListener(MouseEvent.ROLL_OUT,__onRollOut);
				}
				if(_shopItemInfo.ShopID == 1)
				{
					_bg["bg_mc"].gotoAndStop(1);
				}else
				{
					_bg["bg_mc"].gotoAndStop(2);
				}	

				_bg["tip_mc"].visible = _shopItemInfo.Label == 0 ? false : true;
				addChild(_bg["tip_mc"]);
				_bg["tip_mc"].gotoAndStop(_shopItemInfo.Label);
				
				_shopItemInfo.addEventListener(Event.CHANGE,__updateShopItem);
			}
			else
			{
				_bg["bg_mc"].gotoAndStop(1);
				_bg["name_txt"].text = "";
				_bg["sendtocarBtnAccect"].visible = false;
				buttonMode = false;
				_bg["tip_mc"].visible = false;
				_bg["priceUnit"].visible = false;
				_bg["priceTxt"].text = "";

			}
			updateCount();
		}
		
		private function __updateShopItem(evt:Event):void
		{
			updateCount();
		}
		
		private function updateCount():void
		{
			if(_shopItemInfo){
				if(_shopItemInfo.Label && _shopItemInfo.Label==6 )
				{
					if(_bg && _bg["tip_mc"] && _bg["tip_mc"]["countTxt"]){
						_bg["tip_mc"]["countTxt"].text  = String(_shopItemInfo.count);
					}
				} 
				else
				{
					if(_bg && _bg["tip_mc"] && _bg["tip_mc"]["countTxt"]){
						_bg["tip_mc"]["countTxt"].text  = "0";
					}
				}
			}
		}
		
		private function initPrice():void
		{
			_bg["priceUnit"].visible = true;
			switch(_shopItemInfo.getItemPrice(1).PriceType)
			{
				case Price.MONEY:
					_bg["priceUnit"].gotoAndStop("money");
					_bg["priceTxt"].text = _shopItemInfo.getItemPrice(1).moneyValue;
					break;
				case Price.GIFT:
					_bg["priceUnit"].gotoAndStop("gift");
					_bg["priceTxt"].text = _shopItemInfo.getItemPrice(1).giftValue;
					break;
				case -5:
					_bg["priceUnit"].gotoAndStop("medal");
					_bg["priceTxt"].text = _shopItemInfo.getItemPrice(1).getOtherValue(EquipType.MEDAL);
					break;
				default:
					break;
			}
		}
		
		private function __sendToCarClick(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			dispatchEvent(new Event(ADDTOCAR));			
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			
		}
		
		public function get shopItemInfo():ShopItemInfo
		{
			return _shopItemInfo;
		}
		
		
		private function __onMouseOver(e:MouseEvent):void
		{
			if(!locked)
			{
				_shopGoodsTip = createTipRenderForShop();
				_isBGOver = true;
				TipManager.setCurrentTarget(_bg["figure_pos"],_shopGoodsTip,4,10);
				if(_shopGoodsTip)
				{
					_shopGoodsTip.mouseEnabled = true;
					_shopGoodsTip.addEventListener(MouseEvent.MOUSE_OVER,ontipOver);
					_shopGoodsTip.addEventListener(MouseEvent.MOUSE_OUT,onTipOut);
					_shopGoodsTip.updatePosition(_bg["figure_pos"]);
				}
			}
		}
		
		private function createTipRenderForShop():GoodsTipPanel
		{
			if(_info)
			{
				return new GoodsTipPanel(_info,true);
			}else
			{
				return null;
			}
		}
		
		private function ontipOver(e:MouseEvent):void
		{
			_isSTipOver = true; 
			removeEventListener(MouseEvent.ROLL_OUT,__onRollOut);
			showTip();
		}
		
		private function onTipOut(e:MouseEvent):void
		{
			_isSTipOver = false;
			addEventListener(MouseEvent.ROLL_OUT,__onRollOut);
			hidetip();
		}
		override protected function onMouseOut(evt:MouseEvent):void
		{
			
		}
		
		private function __onRollOut(e:MouseEvent):void
		{
			_isBGOver = false;
			hidetip();
		}
		
		override public function dispose():void
		{
			if(_pic)
			{
				_pic.removeEventListener(MouseEvent.MOUSE_OVER,__onMouseOver);
				_pic.removeEventListener(MouseEvent.ROLL_OUT,__onRollOut);
			}
			super.dispose();
			
			if(_shopGoodsTip)
			{
				_shopGoodsTip.removeEventListener(MouseEvent.ROLL_OVER,ontipOver);
				_shopGoodsTip.removeEventListener(MouseEvent.ROLL_OUT,onTipOut);
				_shopGoodsTip = null;
			}
		}
		
		private function showTip():void
		{
			if(_isSTipOver || _isBGOver)
			{
				TipManager.setCurrentTarget(_bg["figure_pos"],_shopGoodsTip,4,10);
				_shopGoodsTip.mouseEnabled = true;
			}
		}
		
		private function hidetip():void
		{
			if(!_isSTipOver && !_isBGOver)
			{
				TipManager.setCurrentTarget(null,null);
			}
		}
	}
}