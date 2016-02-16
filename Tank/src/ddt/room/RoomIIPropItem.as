package ddt.room
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.roomII.RoomIIPropItemAsset;
	
	import road.manager.SoundManager;
	import road.ui.manager.TipManager;
	
	import ddt.data.EquipType;
	import ddt.data.goods.PropInfo;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.socket.GameInSocketOut;
	import ddt.view.common.FastPurchaseGoldBox;
	import ddt.view.common.RoomIIPropTip;
	import ddt.view.items.PropItemView;

	public class RoomIIPropItem extends Sprite
	{
		private var _info:PropInfo;
		private var _container:PropItemView;
		private var _isself:Boolean;
		private var _bg:RoomIIPropItemAsset;
		private var _isselfB:Boolean; //是否显示到道具栏 bret 09.4.30
		/**
		 * 
		 * @param isself  是否自己身上的道具
		 * 
		 */		
		public function RoomIIPropItem(isself:Boolean)
		{
			_isself = isself;
			super();
			configUI();
		}
		
		public override function get width():Number
		{
			return _bg.width;
		}
		
		public override function get height():Number
		{
			return _bg.height;
		}
		
		protected function configUI():void
		{
			_bg = new RoomIIPropItemAsset();
			_bg.figure_pos.visible = false;
			addChild(_bg);
			initEvent();
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.CLICK,__mouseClick);
			addEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		private function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK,__mouseClick);
			removeEventListener(MouseEvent.MOUSE_OVER,__mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,__mouseOut);
		}
		
		public function set info(value:PropInfo):void
		{
			if(_info != null && value != null)
			{
				if(_info.Template == value.Template)return;
			}
			_info = value;
			if(_container != null)
			{
				if(_container.parent)_container.parent.removeChild(_container);
			}
			buttonMode = false;
			if(_info == null)return;
			buttonMode = true;
			_container = new PropItemView(_info);
			addChild(_container);
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			if(_info == null)return;
			var propInfo:PropInfo =  evt.currentTarget._info as PropInfo;
			SoundManager.Instance.play("008");
			if(!_isself && PlayerManager.Instance.Self.Gold < ShopManager.Instance.getShopItemByTemplateIDAndShopID(propInfo.Template.TemplateID,2).getItemPrice(1).goldValue)
			{
				new FastPurchaseGoldBox(LanguageMgr.GetTranslation("ddt.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("ddt.view.GoldInadequate"),EquipType.GOLD_BOX).show();
				return;
			}
			if(_isself)
			{
				TipManager.setCurrentTarget(null,null);
				GameInSocketOut.sendSellProp(_info.Place,ShopManager.Instance.getShopItemByTemplateIDAndShopID(_info.Template.TemplateID,2).GoodsID);
			}
			else
			{
				GameInSocketOut.sendBuyProp(ShopManager.Instance.getShopItemByTemplateIDAndShopID(_info.Template.TemplateID,2).GoodsID);
			}
		}
		
		private function __mouseOver(evt:MouseEvent):void
		{
			var tip:RoomIIPropTip = new RoomIIPropTip(true,false,true);
			tip.update(_info.Template,1);
			TipManager.setCurrentTarget(this,tip,8,8);
		}
		
		private function __mouseOut(evt:MouseEvent):void
		{
			TipManager.setCurrentTarget(null,null);
		}
		
		public function dispose():void
		{
			removeEvent();
			
			if(_container)
				_container.dispose();
			_container = null;
			
			if(_bg && _bg.parent)
				_bg.parent.removeChild(_bg);
			_bg = null;
			
			_info = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}