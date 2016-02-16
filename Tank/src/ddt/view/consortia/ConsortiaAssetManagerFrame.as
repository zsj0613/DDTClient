package ddt.view.consortia
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.setTimeout;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	
	import tank.consortia.accect.ConsortiaAssetManager;
	import ddt.data.ConsortiaAssetLevelOffer;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.request.LoadConsortiaAssetRight;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;

	/***
	 * 公会铁匠铺,公会商城使用需要的条件
	 */

	public class ConsortiaAssetManagerFrame extends HConfirmFrame
	{
		
		private var _bgAsset  : ConsortiaAssetManager;
		private var _infoList : Array;
//		private var _offerBtn : HBaseButton;
		private var _assetManager : HFrameButton;
//		private var _model   : ConsortiaModel;
//		private var _contro  : ConsortiaControl;
		private var _valueArray:Array = [100,100,100,100,100,100];
		public function ConsortiaAssetManagerFrame()
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent  = false;
			buttonGape = 100;
//			_contro = $contro;
//			_model = $model;
//			showBottom = false;
			setContentSize(368,410);
			titleText = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.titleText");
			//titleText = "公会设施管理";
			centerTitle = true;
			init();
			addEvent();
			loadConsortiaEquipContrl();
		}
		
		private function init() : void
		{
			_bgAsset = new ConsortiaAssetManager();
			this.addContent(_bgAsset);
			
			if(PlayerManager.Instance.Self.DutyLevel == 1)
			{
				inputText(_bgAsset.shopLevel1);
				inputText(_bgAsset.shopLevel2);
				inputText(_bgAsset.shopLevel3);
				inputText(_bgAsset.shopLevel4);
				inputText(_bgAsset.shopLevel5);
				inputText(_bgAsset.smith);
			}
			else
			{
				DynamicText(_bgAsset.shopLevel1);
				DynamicText(_bgAsset.shopLevel2);
				DynamicText(_bgAsset.shopLevel3);
				DynamicText(_bgAsset.shopLevel4);
				DynamicText(_bgAsset.shopLevel5);
				DynamicText(_bgAsset.smith);
			}
			
//			_offerBtn = new HBaseButton(_bgAsset.consortiaOfferBtn);
//			_offerBtn.useBackgoundPos = true;
//			_bgAsset.addChild(_offerBtn);
			this.okFunction = __okBtnHandler;
			this.closeCallBack = dispose;
			this.cancelFunction = dispose;
			
			
			_assetManager = new HFrameButton(_bgAsset.consortiaTaxBtn);
			_assetManager.useBackgoundPos = true;
			_bgAsset.addChild(_assetManager);
		}
		/**是否管理过公会资产***/
		private static var  consortiaAssetState : Boolean = true;
		public  static var  dispatcher : EventDispatcher = new EventDispatcher();
		public static function setConsortiaAssetState(b : Boolean) : void
		{
			consortiaAssetState = b;
			dispatcher.dispatchEvent(new Event(Event.CHANGE));
		}
		public static function getConsortiaAssetState() : Boolean
		{
			return consortiaAssetState;
		}
		/**加数据**/
		public function loadConsortiaEquipContrl() : void
		{
			var consortiaId : int = PlayerManager.Instance.Self.ConsortiaID;
			new LoadConsortiaAssetRight(consortiaId).loadSync(__resultConsortiaEquipContro);
		}
		private function __resultConsortiaEquipContro(action : LoadConsortiaAssetRight) : void
		{
			if(this.parent)
			{
				__upViewHandler(action.list);
			}
			else
			{
				if(action)action.list = null;
				action = null;
			}
			
		}
		
		
		
		private function __okFunction() : void
		{
			if(PlayerManager.Instance.Self.bagLocked && _checkChange())
			{
				new BagLockedGetFrame().show();
				return;
			}
			
			if(PlayerManager.Instance.Self.DutyLevel == 1)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.okFunction"),true,__ok);
				//HConfirmDialog.show("提示","确认修改!",true,__ok);
			}
			else
			{
				dispose();
			}
		}
		
		private function _checkChange():Boolean
		{
			var shopLevel1 : int = checkInputValue(_bgAsset.shopLevel1);
			var shopLevel2 : int = checkInputValue(_bgAsset.shopLevel2);
			var shopLevel3 : int = checkInputValue(_bgAsset.shopLevel3);
			var shopLevel4 : int = checkInputValue(_bgAsset.shopLevel4);
			var shopLevel5 : int = checkInputValue(_bgAsset.shopLevel5);
			var smithLevel : int = checkInputValue(_bgAsset.smith);
			var arr : Array = [shopLevel1,shopLevel2,shopLevel3,shopLevel4,shopLevel5,smithLevel];
			var bool:Boolean = false;
			for(var i:int = 0 ; i < 6 ; i++)
			{
				if(_valueArray[i] != arr[i])
					bool = true;
			}
			return bool;
		}
		
		private function __ok() : void
		{
			var shopLevel1 : int = checkInputValue(_bgAsset.shopLevel1);
			var shopLevel2 : int = checkInputValue(_bgAsset.shopLevel2);
			var shopLevel3 : int = checkInputValue(_bgAsset.shopLevel3);
			var shopLevel4 : int = checkInputValue(_bgAsset.shopLevel4);
			var shopLevel5 : int = checkInputValue(_bgAsset.shopLevel5);
			var smithLevel : int = checkInputValue(_bgAsset.smith);
			var arr : Array = [shopLevel1,shopLevel2,shopLevel3,shopLevel4,shopLevel5,smithLevel];
			SocketManager.Instance.out.sendConsortiaEquipConstrol(arr);
			dispose();
		}
		private function __addToStageHandler(evt : Event) : void
		{
			if(PlayerManager.Instance.Self.DutyLevel == 1)
			{
				_bgAsset.shopLevel1.stage.focus = _bgAsset.shopLevel1;
			}
			_bgAsset.shopLevel1.text = "100";
			_bgAsset.shopLevel2.text = "100";
			_bgAsset.shopLevel3.text = "100";
			_bgAsset.shopLevel4.text = "100";
			_bgAsset.shopLevel5.text = "100";
			_bgAsset.smith.text      = "100";
			stage.focus = this;
			setTimeout(getFocus,30);
		}
		
		private function getFocus():void
		{
			stage.focus = this;
		}
		
		private function checkInputValue(txt : TextField) : int
		{
			if(txt.text == "")return 0;
			return int(txt.text);
		}
		private function __upViewHandler(arr : Array) : void
		{
			for(var i:int=0;i<arr.length;i++)
			{
				var $info : ConsortiaAssetLevelOffer = arr[i] as ConsortiaAssetLevelOffer;
				if($info.Type == 1)
				{
					switch($info.Level)
					{
						case 1:
						_bgAsset.shopLevel1.text = _valueArray[0] = String($info.Riches);
						break;
						case 2:
						_bgAsset.shopLevel2.text = _valueArray[1] = String($info.Riches);
						break;
						case 3:
						_bgAsset.shopLevel3.text = _valueArray[2] = String($info.Riches);
						break;
						case 4:
						_bgAsset.shopLevel4.text = _valueArray[3] = String($info.Riches);
						break;
						case 5:
						_bgAsset.shopLevel5.text = _valueArray[4] = String($info.Riches);
						break;
					}
				}
				else if($info.Type == 2)
				{
					_bgAsset.smith.text = _valueArray[5] = String($info.Riches);
				}
			}
			
		}
		private function __openOfferFrame(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			new MyConsortiaTax().show();
			dispose();
		}
		private function __okBtnHandler() : void
		{
			SoundManager.Instance.play("008");
			__okFunction();
		}
		
		private function addEvent() : void
		{
			addEventListener(Event.ADDED_TO_STAGE,            __addToStageHandler);
//			_offerBtn.addEventListener(MouseEvent.CLICK,      __openOfferFrame);        
			_assetManager.addEventListener(MouseEvent.CLICK,  __openOfferFrame);   
//			_model.addEventListener(ConsortiaDataEvent.CONSORTIA_ASSET_LEVEL_OFFER,  __upViewHandler);
		}
		private function removeEvent() : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,         __addToStageHandler);
//			_offerBtn.removeEventListener(MouseEvent.CLICK,      __openOfferFrame);     
			_assetManager.removeEventListener(MouseEvent.CLICK,  __openOfferFrame);
//			_model.removeEventListener(ConsortiaDataEvent.CONSORTIA_ASSET_LEVEL_OFFER,  __upViewHandler);
		}
		override public function dispose():void
		{
			removeEvent();
			if(_bgAsset && _bgAsset.parent)_bgAsset.parent.removeChild(_bgAsset);
			_bgAsset = null;
			super.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,true);
			alphaGound = true;
		}
		private function inputText(txt : TextField) : void
		{
			txt.type = TextFieldType.INPUT;
			txt.restrict = "0-9"; 
			txt.maxChars = 8;
		}
		private function DynamicText(txt : TextField) : void
		{
			txt.type = TextFieldType.DYNAMIC;
			txt.restrict = "0-9"; 
			txt.selectable = false;
			txt.mouseEnabled = false;
		}
		
	}
}