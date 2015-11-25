package ddt.consortia.consortiashop
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HOverIconButton;
	import road.ui.controls.hframe.HFrame;
	
	import tank.consortia.accect.ConsortiaShopBgAsset;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ShopManager;
	import ddt.view.consortia.ConsortiaAssetManagerFrame;

	public class ConsortiaShopView extends HFrame
	{
		private var _shopBgAsset  : ConsortiaShopBgAsset;
		private var _currentLvBtn : MovieClip;
		private var _btnItems     : Array;
		private var _list         : ConsortiaShopList;
		private var _assetRightBtn         : HOverIconButton;
		public function ConsortiaShopView()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			this.setContentSize(675,500);
			this.showBottom = false;
			this.fireEvent = false;
			this.titleText = LanguageMgr.GetTranslation("ddt.consortia.consortiashop.ConsortiaShopView.titleText");
			this.moveEnable = false;
			
			_shopBgAsset = new ConsortiaShopBgAsset();
			_shopBgAsset.x = 15;
			addContent(_shopBgAsset,true);
			_shopBgAsset.LVBtnAsset.gotoAndStop(1);
			
			_list = new ConsortiaShopList();
			_shopBgAsset.addChild(_list);
			_list.x = _shopBgAsset.list_pos.x;
			_list.y = _shopBgAsset.list_pos.y;
			_shopBgAsset.removeChild(_shopBgAsset.list_pos);
			_btnItems = [null,_shopBgAsset.LVBtn1,_shopBgAsset.LVBtn2,_shopBgAsset.LVBtn3,_shopBgAsset.LVBtn4,_shopBgAsset.LVBtn5];
			
			_assetRightBtn = new HOverIconButton(_shopBgAsset.consortiaAssetManagerBtn);
			_assetRightBtn.useBackgoundPos = true;
			_shopBgAsset.addChild(_assetRightBtn);
			
			_shopBgAsset.assetManagerEffect.visible = true;
			_shopBgAsset.assetManagerEffect.mouseEnabled = false;
			_shopBgAsset.assetManagerEffect.mouseChildren = false;
			_shopBgAsset.addChild(_shopBgAsset.assetManagerEffect);
			
		}
		public var hasEvent : Boolean = false;
		public function addEvent() : void
		{
			hasEvent = true;
			for(var i:int=1;i<_btnItems.length;i++)
			{
				_btnItems[i].buttonMode = true;
				_btnItems[i].addEventListener(MouseEvent.CLICK,   __selectLvHandler);
			}
			addEventListener(KeyboardEvent.KEY_DOWN,      __onKeyDownd);
			addEventListener(Event.ADDED_TO_STAGE,        __addToStageHandler);
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__changeProperty);
			_assetRightBtn.addEventListener(MouseEvent.CLICK,                 __openAssetManager);
			ConsortiaAssetManagerFrame.dispatcher.addEventListener(Event.CHANGE, __AssetManagerStateChage);
		}
		private function removeEvent() : void
		{
			hasEvent = false;
			for(var i:int=1;i<_btnItems.length;i++)
			{
				_btnItems[i].removeEventListener(MouseEvent.CLICK,   __selectLvHandler);
			}
			removeEventListener(KeyboardEvent.KEY_DOWN,   __onKeyDownd);
			removeEventListener(Event.ADDED_TO_STAGE,     __addToStageHandler);
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__changeProperty);
			_assetRightBtn.removeEventListener(MouseEvent.CLICK,                 __openAssetManager);
			ConsortiaAssetManagerFrame.dispatcher.removeEventListener(Event.CHANGE, __AssetManagerStateChage);
		}
		private function __addToStageHandler(evt : Event) : void
		{
			switchBtn(_shopBgAsset.LVBtn1);
			_shopBgAsset.gold_txt.text  = String(PlayerManager.Instance.Self.Gold);
			_shopBgAsset.money_txt.text = String(PlayerManager.Instance.Self.Money);
			_shopBgAsset.offer_txt.text = String(PlayerManager.Instance.Self.Offer); //功勋值
			_shopBgAsset.assetManagerEffect.visible = !ConsortiaAssetManagerFrame.getConsortiaAssetState();
		}
		private function __AssetManagerStateChage(evt : Event) : void
		{
			_shopBgAsset.assetManagerEffect.visible = !ConsortiaAssetManagerFrame.getConsortiaAssetState();
		}
		protected function __onKeyDownd(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE)
			{
				__closeClick(null);
			}
		}
		override public function close ():void
		{
			removeEvent();
			super.close();
		}
		private function __selectLvHandler(evt : MouseEvent) : void
		{
			if(_currentLvBtn == evt.target)return;
			SoundManager.instance.play("008");
			switchBtn(evt.target as MovieClip);
			
		}
		private function __openAssetManager(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var assetManager : ConsortiaAssetManagerFrame = new ConsortiaAssetManagerFrame();
			assetManager.show();
			_shopBgAsset.assetManagerEffect.visible = false;
			ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
			
		}
		/**按钮状态改变,同时更新列表内容**/
		private function switchBtn(mc : MovieClip) : void
		{
			if(_currentLvBtn)_currentLvBtn.mouseEnabled = true;
			_currentLvBtn = mc;
			_currentLvBtn.mouseEnabled = false;
			var level : Number = Number(_currentLvBtn.name.substr(5,1));
			_shopBgAsset.LVBtnAsset.gotoAndStop(level);
			upLvList(level);
		}
		private function __changeProperty(evt : PlayerPropertyEvent) : void
		{
			if(evt.changedProperties["Money"] || evt.changedProperties["Gold"] || evt.changedProperties["Offer"])
			{
				_shopBgAsset.gold_txt.text  = String(PlayerManager.Instance.Self.Gold);
				_shopBgAsset.money_txt.text = String(PlayerManager.Instance.Self.Money);
				_shopBgAsset.offer_txt.text = String(PlayerManager.Instance.Self.Offer); //功勋值
			}
			else if(evt.changedProperties["ShopLevel"])
			{
				upLvList(_shopLevel);
			}
		}
		private var _shopLevel : int;
		private function upLvList($level : int) : void
		{
			//判断商城等级
			var b : Boolean = PlayerManager.Instance.Self.ShopLevel >= $level ? true : false;
			_list.list(ShopManager.Instance.consortiaShopLevelTemplates($level),$level,b);
			_shopLevel = $level;
			
		}

		override public function dispose():void
		{
			removeEvent();
			if(_list)_list.dispose();_list = null;
			super.dispose();
			if(parent)parent.removeChild(this);
		}
		
	}
}