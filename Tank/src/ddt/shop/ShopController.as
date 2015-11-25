package ddt.shop
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import game.crazyTank.view.shopII.ShopIIAsset;
	
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import ddt.shop.view.ShopLeftView;
	import ddt.shop.view.ShopRightView;
	import ddt.shop.view.ShopSaveFigurePanel;
	
	import ddt.data.EquipType;
	import ddt.data.goods.ShopIICarItemInfo;
	import ddt.data.goods.ShopItemInfo;
	import ddt.manager.ChatManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.socket.GameSocketOut;
	import ddt.states.BaseStateView;
	import ddt.states.StateType;
	import ddt.view.common.BellowStripViewII;
	import ddt.view.common.BuggleView;
	
	public class ShopController extends BaseStateView 
	{
		public static const TRYPANEL:String = "try";
		public static const SHOPCAR:String = "car";
		
		private var _container:Sprite;
		private var _shopview:ShopRightView;
		private var _bg:ShopIIAsset;
		private var _body:ShopLeftView;
		private var _model:ShopModel;
		
		private var _shopType:int;
		
		public function ShopController()
		{
		}
		
		override public function enter(prev:BaseStateView,data:Object = null):void
		{
			super.enter(prev);
			
			SocketManager.Instance.out.sendCurrentState(1);
			SocketManager.Instance.out.sendUpdateGoodsCount();
			ChatManager.Instance.state = ChatManager.CHAT_SHOP_STATE;
			
			BuggleView.instance.hide();
			_shopType = int(data);
			init();
			BellowStripViewII.Instance.show();
			BellowStripViewII.Instance.enabled = true;
			BellowStripViewII.Instance.setShopState();
		}
		
		private function init():void
		{
			_model = new ShopModel();
			_container = new Sprite();
			_shopview = new ShopRightView(this);
			_body = new ShopLeftView(this,_model);
			_bg = new ShopIIAsset();
			_container.addChild(_bg);
			ComponentHelper.replaceChild(_bg,_bg.shop_pos,_shopview);
			_body.x = _bg.body_pos.x;
			_body.y = _bg.body_pos.y;
			if(_bg.body_pos.parent) _bg.body_pos.parent.removeChild(_bg.body_pos);
			_bg.addChild(_body);
			_shopview.setType(_shopType);
		}
	
		override public function getView():DisplayObject
		{
			return _container;
		}
		
		override public function getType():String
		{
			return StateType.SHOP;
		}
		
		public function revertToDefault():void
		{
			_model.revertToDefalt();
		}
		
		public function restoreAllItemsOnBody():void
		{
			_model.restoreAllItemsOnBody();
		}
		
		public function showPanel(type:String):void
		{
			_body.setPanelVisible(type);
		}
		
		public function setSelectedEquip(item:ShopIICarItemInfo):void
		{
			_model.setSelectedEquip(item);
		}
		
		public function updateCost():void
		{
			_model.updateCost();
		}
		
		public function loadList(page:int,type:*,sex:int,vouch:Boolean = false):void
		{
			_shopview.setList(ShopManager.Instance.getTemplatesByCategeryId(page,type,8,sex,vouch));
		}
		
		public function addToCar(item:ShopIICarItemInfo):void
		{
			_model.addToShoppingCar(item);
			_body.setPanelVisible(SHOPCAR);
		}
		
		public function removeFromCar(item:ShopIICarItemInfo):void
		{
			_model.removeFromShoppingCar(item);
		}
		
		public function addTempEquip(item:ShopItemInfo):void
		{
			_model.addTempEquip(item);
			_body.setPanelVisible(TRYPANEL);
		}
		
		public function removeTempEquip(item:ShopIICarItemInfo):void
		{
			_model.removeTempEquip(item);
		}
		
		public function restoreAllTredItems():void
		{
			_model.restoreAllTredItems();
		}
		
		public function setFittingModel(sex:Boolean):void
		{
			_shopview.setCurrentSex(sex?1:2);
			_shopview.loadList();
			_model.fittingSex = sex;
			_body.setPanelVisible(TRYPANEL);
		}
		
		override public function leaving(next:BaseStateView):void
		{
			dispose();
			BellowStripViewII.Instance.hide();
			super.leaving(next);
		}
		
		override public function getBackType():String
		{
			return StateType.MAIN;
		}
		
		public function buyItems(list:Array,dressing:Boolean,skin:String = ""):void
		{
			var items:Array = new Array();
			var types:Array = new Array();
			var colors:Array = new Array();
			var dresses:Array = new Array();
			var places:Array = new Array();
			var skins:Array = [];
			for(var i:int = 0; i < list.length; i++)
			{
				var t:ShopIICarItemInfo = list[i];
				
				items.push(t.GoodsID);
				types.push(t.currentBuyType);
				colors.push(t.Color);
				trace(t.TemplateID);
				places.push(t.place);
				if(t.CategoryID == EquipType.FACE)
				{
					skins.push(t.skin);
				}else
				{
					skins.push("");
				}
				dresses.push(dressing ? t.dressing : false);
			}

			SocketManager.Instance.out.sendBuyGoods(items,types,colors,places,dresses,skins);
		}
		
		public function presentItems(list:Array,msg:String,nick:String):void
		{
			var items:Array = new Array();
			var types:Array = new Array();
			var colors:Array = new Array();
			var skins:Array = [];
			for(var i:int = 0; i < list.length; i++)
			{
				var t:ShopIICarItemInfo = list[i];
				items.push(t.GoodsID);
				types.push(t.currentBuyType);
				colors.push(t.Color);
				
				if(t.CategoryID == EquipType.FACE)
				{
					skins.push(_model.currentModel.Skin);
				}else
				{
					skins.push("");
				}
			}
			SocketManager.Instance.out.sendPresentGoods(items,types,colors,msg,nick,skins);
		}
		
		public function get model():ShopModel{
			return _model;
		}
		
		override public function dispose():void
		{
			for each(var obj:Object in ShopManager.countLimitArray){
				obj["currentCount"]=0;
			}
			_model.dispose();
			_model = null;
			_shopview.dispose();
			_shopview = null;
			_body.dispose();
			_body = null;
			if(_bg.parent)_bg.parent.removeChild(_bg);
			_bg = null;
		}
	}
}