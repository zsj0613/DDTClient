package ddt.shop.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.shopII.BodyBgAsset;
	
	import road.manager.SoundManager;
	
	import ddt.shop.ShopController;
	import ddt.shop.ShopModel;

	public class ShopLeftView extends BodyBgAsset
	{
		private var _controller:ShopController;
		private var _model:ShopModel;
		private var _trydress:ShopTryDressView;
		private var _shopcar:ShopShoppingCar;
		
		public function ShopLeftView(controller:ShopController,model:ShopModel)
		{
			_controller = controller;
			_model = model;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			tabs_btn.gotoAndStop(1);
			tab_pos.visible = false;
			
			_trydress = new ShopTryDressView(_controller,_model);
			_shopcar = new ShopShoppingCar(_controller,_model);
			
			_trydress.x = _shopcar.x = tab_pos.x;
			_trydress.y = _shopcar.y = tab_pos.y;
			
			addChild(_trydress);
			addChild(_shopcar);
			
			_shopcar.visible = false;
			
			trydress_btn.buttonMode = shopcar_btn.buttonMode = true;
		}
		
		private function initEvent():void
		{
			trydress_btn.addEventListener(MouseEvent.CLICK,__tabsClick);
			shopcar_btn.addEventListener(MouseEvent.CLICK,__tabsClick);
		}
		
		private function __tabsClick(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			var s:Sprite = evt.currentTarget as Sprite
			setPanelVisible(s == trydress_btn ? ShopController.TRYPANEL : ShopController.SHOPCAR);
		}
		
		public function setPanelVisible(type:String):void
		{
			_model.leftViewPanel = type;
			if(type == ShopController.TRYPANEL)
			{
				tabs_btn.gotoAndStop(1);
				_trydress.personBody.visible = true;
				_shopcar.visible = false;
			}
			else
			{
				tabs_btn.gotoAndStop(2);
				_trydress.personBody.visible = false;
				_shopcar.visible = true;
				_trydress.changeToShopCarView();
			}
		}
		
		public function dispose():void
		{
			_trydress.dispose();
			_shopcar.dispose();
			_trydress = null;
			_shopcar = null;
			_model = null;
			_controller = null;
		}
	}
}