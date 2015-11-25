package ddt.view.changeColor
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.common.changeColorRightViewAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmDialog;
	
	import ddt.data.EquipType;
	import ddt.data.player.BagInfo;
	import ddt.events.ChangeColorCellEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	public class ChangeColorRightView extends changeColorRightViewAsset
	{
		private var _bag:ColorChangeBagListView;
		private var _model:ChangeColorModel;
		private var _changeColorBtn:HBaseButton;
		
		public function ChangeColorRightView(model:ChangeColorModel)
		{
			_model = model;
			init();
		}
		
		private function init():void
		{
			_bag = new ColorChangeBagListView();
			addChild(_bag);
			_bag.move(bag_pos.x,bag_pos.y);
			bag_pos.visible = false;
			_bag.setData(_model.colorEditableBag);
			
			_changeColorBtn = new HBaseButton(changeColorBtn);
			_changeColorBtn.useBackgoundPos = true;
			_changeColorBtn.buttonMode = true;
			addChild(_changeColorBtn);
			_changeColorBtn.enable = false;
			_changeColorBtn.addEventListener(MouseEvent.CLICK,__changeColor);
			_model.addEventListener(ChangeColorCellEvent.SETCOLOR,__updateBtn);
		}
		
		private function __changeColor(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(PlayerManager.Instance.Self.bagLocked)
			{
				new BagLockedGetFrame().show();
				return;
			}
			if(_model.place!=-1)
			{
				sendChangeColor();
				_model.place = -1;//_model的卡片位置重置
			}else if(hasColorCard()!=-1)
			{
				_model.place = hasColorCard();
				sendChangeColor();
				_model.place = -1;//_model的卡片位置重置
			}else
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("ddt.view.changeColor.lackCard",ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue),true,changeColor);
			}
			_changeColorBtn.enable = false;
			
		}
		
		private function hasColorCard():int
		{
			if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.COLORCARD) > 0)
			{
				return PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.COLORCARD).Place;
			}
			return -1;
		}
		
		private function changeColor():void
		{
			if(PlayerManager.Instance.Self.Money<ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
				return;
			}
			sendChangeColor();
		}
		
		private function sendChangeColor():void
		{
			var cardBagType:int = BagInfo.PROPBAG;
			var cardPlace:int = _model.place;
			var itemBagType:int = _model.currentItem.BagType;
			var itemPlace:int = _model.currentItem.Place;
			var color:String = _model.currentItem.Color;
			var skin:String = _model.currentItem.Skin;
			var templateID:int = EquipType.COLORCARD;
			
			SocketManager.Instance.out.sendChangeColor(cardBagType,cardPlace,itemBagType,itemPlace,color,skin,templateID);
			_model.savaItemInfo();
		}
		
		private function __updateBtn(evt:Event):void
		{
			if(!_model.changed)
			{
				_changeColorBtn.enable = false;
			}else
			{
				_changeColorBtn.enable = true;
				_changeColorBtn.buttonMode = true;
			}
		}
		
		public function dispose():void
		{
			_model.removeEventListener(ChangeColorCellEvent.SETCOLOR,__updateBtn);
			_changeColorBtn.removeEventListener(MouseEvent.CLICK,__changeColor);
			_changeColorBtn.dispose();
			_changeColorBtn = null;
			_bag.dispose();
			_bag = null;
			_model=null;
		}

	}
}