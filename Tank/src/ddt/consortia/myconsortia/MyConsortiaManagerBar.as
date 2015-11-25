package ddt.consortia.myconsortia
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.manager.TipManager;
	
	import ddt.consortia.ConsortiaControl;
	import ddt.consortia.ConsortiaModel;
	import tank.consortia.accect.MyConsortiaManagerBarAsset;
	import ddt.consortia.consortiabank.ConsortiaBankView;
	import ddt.consortia.consortiashop.ConsortiaShopView;
	import ddt.consortia.myconsortia.frame.*;
	import ddt.consortia.request.LoadAuditingList;
	import ddt.data.ConsortiaDutyType;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.data.store.StoreState;
	import tank.fightLibChooseFightLibTypeView.BookShine;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.consortia.ConsortiaAssetManagerFrame;
	import ddt.view.consortia.MyConsortiaTax;

	public class MyConsortiaManagerBar extends MyConsortiaManagerBarAsset
	{
		private var _btnNameItems                      : Array;
		private var _btnsItems                         : Dictionary;
		private var _model                             : ConsortiaModel;
		private var _contro                            : ConsortiaControl;
		private var _enableKeyDown                     : Sprite;
		
		public function MyConsortiaManagerBar($model : ConsortiaModel, $contro : ConsortiaControl)
		{
			super();
			this._model = $model;
			this._contro = $contro;
			init();
			addEvent();
		}
		private function init() : void
		{
			_btnNameItems = ["exitConsortiaBtnAccect","shopBtnAccect","taxBtnAccect","auditingApplyBtnAsset","storeBtnAsset","smithBtnAsset","chairChannelBtn","consortiaAssetManagerBtn"];
			this.taxBtnAccect.shine.visible = false;
			this.shopBtnAccect.shine.visible = false;
			this.storeBtnAsset.shine.visible = false;
			this.smithBtnAsset.shine.visible = false;
			_btnsItems = new Dictionary();
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = new HBaseButton(this[_btnNameItems[i]]);
				btn.useBackgoundPos = true;
				addChild(btn);
				_btnsItems[_btnNameItems[i]] = btn;
			}
			
			initRight();
//			_btnsItems["shopBtnAccect"].enable = false;
			_enableKeyDown = new Sprite();
			TipManager.AddTippanel(_enableKeyDown);
		}
		
		
		private function initRight():void
		{
			var right:int = PlayerManager.Instance.Self.Right;
			/* 退出公会权限 */
			_btnsItems["exitConsortiaBtnAccect"].enable = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._13_Exit);
			/* // 审核申请 */
			_btnsItems["auditingApplyBtnAsset"].enable = ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._1_Ratify);
			_btnsItems["chairChannelBtn"].enable = ConsortiaDutyManager.GetRight(right, ConsortiaDutyType._10_ChangeMan);
			
			
			if(ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._2_Invite))
			{
				//邀请加入
			}
			
			if(ConsortiaDutyManager.GetRight(right,ConsortiaDutyType._3_BanChat))
			{
				/// 禁止/允许发言
			}
			
						
		}
		private function addEvent() : void
		{
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = _btnsItems[_btnNameItems[i]] as HBaseButton;
				btn.addEventListener(MouseEvent.CLICK,    __onClickHandler);
				btn.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
			}
			/*  侦听权限改变*/
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onRightChange);
			_enableKeyDown.parent.addEventListener(KeyboardEvent.KEY_DOWN,   __keyDownHandler);
			
		}
		private function removeEvent() : void
		{
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = _btnsItems[_btnNameItems[i]] as HBaseButton;
				if(btn)
				{
					btn.removeEventListener(MouseEvent.CLICK,    __onClickHandler);
					btn.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
					btn.removeEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
				}
			}
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__onRightChange);
			if(_enableKeyDown.parent)
		    {
		    	_enableKeyDown.parent.removeEventListener(KeyboardEvent.KEY_DOWN,   __keyDownHandler);
		    	_enableKeyDown.parent.removeChild(_enableKeyDown);
		    }
		}
		private function __keyDownHandler(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == Keyboard.ENTER)
			evt.stopPropagation();
		}
		
		private function __onRightChange(e:PlayerPropertyEvent):void
		{
			if(e.changedProperties["Right"])
			{
				initRight();
			}
		}
		
		
		private function __mouseOverHandler(evt:MouseEvent):void {
			var name:String = getName(evt);
			switch(name) {
				case "taxBtnAccect":
					this.taxBtnAccect.shine.visible = true;
					break;
				case "shopBtnAccect":
					this.shopBtnAccect.shine.visible = true;
					break;
				case "storeBtnAsset":
					this.storeBtnAsset.shine.visible = true;
					break;
				case "smithBtnAsset":
					this.smithBtnAsset.shine.visible = true;
					break;
			}
		}
		
		private function __mouseOutHandler(evt:MouseEvent):void {
			var name:String = getName(evt);
			switch(name) {
				case "taxBtnAccect":
					this.taxBtnAccect.shine.visible = false;
					break;
				case "shopBtnAccect":
					this.shopBtnAccect.shine.visible = false;
					break;
				case "storeBtnAsset":
					this.storeBtnAsset.shine.visible = false;
					break;
				case "smithBtnAsset":
					this.smithBtnAsset.shine.visible = false;
					break;
			}
		}
		
		private function __onClickHandler(evt : MouseEvent) : void
		{
			SoundManager.instance.play("008");
			var name:String = getName(evt);
			switch(name)
			{
				case "exitConsortiaBtnAccect":
					__exitConsortiaHandler(evt);
					break;
				case "shopBtnAccect":
					__consortiaShopHandler(evt);
					break;
				case "taxBtnAccect" :
					__consortiaTaxHandler(evt);
					break;
				case "auditingApplyBtnAsset":
					__auditingApplyHandler(evt);
					break;
				case "storeBtnAsset":
					__consortiaBankHandler(evt);
					break;
				case "smithBtnAsset":
					__consortiaStoreHandler(evt);
					break;
				case "chairChannelBtn":
					__chairChannelHandler(evt);
					break;
				case "consortiaAssetManagerBtn":
					__consortiaAssetManagerHandler(evt);
					break;
				
			}
		}
		
		private function getName(evt:MouseEvent):String {
			var name:String = "";
			for(var value:String in _btnsItems) {
				if(_btnsItems[value] == evt.currentTarget) {
					name = value;
					break;
				}
			}
			return name;
		}
		
		
		/*************************************************************
		 *           相应的按键事件处理
		 * **********************************************************/
		private var _exitFrame : ExitConsortiaFrame;
		private function __exitConsortiaHandler(evt : MouseEvent) : void
		{
			if(_exitFrame == null) _exitFrame = new ExitConsortiaFrame(this._model);
			if(_exitFrame.parent)
			{
				_exitFrame.removeEvent();
				_exitFrame.parent.removeChild(_exitFrame);
			}
			else
			{
				TipManager.AddTippanel(_exitFrame,true);
				_exitFrame.addEvent();
			}
		}
		
		/**公会商城**/
		private var _consortiaShop : ConsortiaShopView;
		private function __consortiaShopHandler(evt : MouseEvent) : void
		{
			if(!_consortiaShop)_consortiaShop = new ConsortiaShopView();
			if(_consortiaShop.parent)
			{
				_consortiaShop.dispose();
				if(_consortiaShop.parent)_consortiaShop.parent.removeChild(_consortiaShop);
			}
			else
			{
				if(!_consortiaShop.hasEvent)_consortiaShop.addEvent();
				_consortiaShop.show();
			}
		}
		
		private var _consortiaTax : MyConsortiaTax;
		private function __consortiaTaxHandler(evt : MouseEvent): void
		{
			_consortiaTax = null;
			if(!_consortiaTax)_consortiaTax = new MyConsortiaTax();
			if(_consortiaTax.parent)
			{
				_consortiaTax.removeEvent();
				_consortiaTax.parent.removeChild(_consortiaTax);
			}
			else 
			{
				TipManager.AddTippanel(_consortiaTax,true);
				_consortiaTax.TextInput = "";//bret 09.7.14
				_consortiaTax.addEvent();
				
			}
		}
		
		private var auditingApply : MyConsortiaAuditingApplyList;
		private function __auditingApplyHandler(evt : MouseEvent) : void
		{
			if(auditingApply == null)
			{
				auditingApply = new MyConsortiaAuditingApplyList(_model,_contro);
				auditingApply.visible = false;
				auditingApply.show();
				auditingApply.removeEvent();
				auditingApply.parent.removeChild(auditingApply);
			}
			if(auditingApply.parent)
			{
				auditingApply.removeEvent();
				auditingApply.parent.removeChild(auditingApply);
				
			}
			else 
			{
				auditingApply.addEvent();
				auditingApply.show();
				auditingApply.visible = true;
				_contro.sendGetSelfConsortiaApplyList(PlayerManager.Instance.Self.ConsortiaID);
			}
		}
		
		/**公会银行*/
		private var _consortiaSmith : ConsortiaBankView;
		private function __consortiaBankHandler(evt : MouseEvent) : void
		{
			//		 	if(_consortiaSmith)
			//		 	{
			////		 		_consortiaSmith.dispose();
			//                /**为什么消不干00**/
			//		 		_consortiaSmith = null;
			//		 	}
			if(!_consortiaSmith)_consortiaSmith = new ConsortiaBankView();
			if(_consortiaSmith.parent)
			{
				_consortiaSmith.dispose();
				_consortiaSmith = null;
			}
			else
			{
				_consortiaSmith.show();
			}
		}
		
		/**公会铁匠铺**/
		private function __consortiaStoreHandler(evt : MouseEvent) : void
		{
			StoreState.storeState = StoreState.CONSORTIASTORE;
			StateManager.setState(StateType.CONSORTIASTORE);
		}
		
		private var _chairChannel:ChairChannelFrame;
		private var _chairChannelShow:Boolean = true;
		private function __chairChannelHandler(evt:MouseEvent):void {
			if(_chairChannelShow) {
				evt.stopImmediatePropagation();
				if(!_chairChannel) {
					_chairChannel = new ChairChannelFrame(_model, _contro);
					this.addChild(_chairChannel);
				}
				TipManager.AddTippanel(_chairChannel);
				var pos:Point = parent.localToGlobal(new Point(this.x, this.y));
				_chairChannel.x = pos.x - _chairChannel.width - 15;
				_chairChannel.y = pos.y + 40;
				stage.addEventListener(MouseEvent.CLICK, __closeChairChnnel);
			}
			else {
				if(_chairChannel) {
					_chairChannel.hide();
				}
			}
			_chairChannelShow = _chairChannelShow? false : true;
		}
		private function __closeChairChnnel(e:MouseEvent):void {
			if( e.target != _chairChannel) {
				stage.removeEventListener(MouseEvent.CLICK, __closeChairChnnel);
				if(_chairChannel) {
					_chairChannel.hide();
					_chairChannelShow = true;
				}
			}
		}
		
		private function __consortiaAssetManagerHandler(evt:MouseEvent):void {
			var assetManager:ConsortiaAssetManagerFrame = new ConsortiaAssetManagerFrame();
			assetManager.show();
			ConsortiaAssetManagerFrame.setConsortiaAssetState(true);
		}
		
		private function removeChilds() : void
		{
			if(_consortiaTax)_consortiaTax.dispose();_consortiaTax = null;
			if(auditingApply)auditingApply.dispose();auditingApply = null;
			if(_exitFrame)_exitFrame.dispose();_exitFrame =  null;
			if(_consortiaSmith)_consortiaSmith.dispose();_consortiaSmith = null;
			if(_consortiaShop)_consortiaShop.dispose();_consortiaShop = null;
			if(_chairChannel) _chairChannel.dispose(); _chairChannel = null;
		}

		public function dispose() : void
		{
			removeEvent();
			removeChilds();
			for(var i:int=0;i<_btnNameItems.length;i++)
			{
				var btn : HBaseButton = _btnsItems[_btnNameItems[i]] as HBaseButton;
				if(btn && btn.parent)btn.parent.removeChild(btn);
				if(btn)
				{
					btn.dispose();
					btn = null;
				} 
				delete _btnsItems[_btnNameItems[i]];
			}
			while(numChildren)
			{
				removeChildAt(0);
			}
			_btnNameItems = null;
		    _btnsItems    = null;
		    _enableKeyDown = null;
		}
		
		private function __loadAuditingBack(loader:LoadAuditingList):void
		{
			_model.consortiaApplyList = loader.list;
		}
	}
}