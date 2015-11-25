package ddt.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.utils.StringHelper;
	
	import tank.commonII.asset.defyAfficheAsset;
	import ddt.data.RoomInfo;
	import ddt.data.player.SelfInfo;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.manager.SocketManager;
	import ddt.utils.LeavePage;

	public class DefyAfficheView extends HConfirmFrame
	{
		private var _asset:defyAfficheAsset;
		private var _room:RoomInfo;
		private var _str:String;
		public function DefyAfficheView(room:RoomInfo)
		{
			super();
			_room = room;
			init();
			initEvent();
		}
		
		private function init():void
		{
			setSize(285,245);
			blackGound = false;
			alphaGound = false;
			titleText  = LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.affiche");
			okLabel    = LanguageMgr.GetTranslation("ddt.room.RoomIIView2.affirm");
			cancelLabel= LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.cancel");
			showCancel = true;
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			_asset = new defyAfficheAsset();
			_asset.x = 17;
			_asset.y = 40;
			_asset.inputTxt.maxChars = 30;
			_asset.inputTxt.text = "";
			_asset.inputTxt.text = LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.afficheInfo");
			//ddt.view.DefyAfficheView.afficheInfo:胜利简直易如反掌~不服!那就接着来!
			_asset.charNum_txt.text = "12";
			addChild(_asset);
		}
		
		private function initEvent():void
		{
			_asset.inputTxt.addEventListener(TextEvent.TEXT_INPUT ,__texeInput);
			_asset.inputTxt.addEventListener(KeyboardEvent.KEY_DOWN , __texeInput);
			_asset.inputTxt.addEventListener(Event.CHANGE , __texeInput);
//			_asset.inputTxt.addEventListener(TextEvent.TEXT_INPUT,  __inputChange);
		}
		
		private function __texeInput(evt:Event):void
		{
			_asset.charNum_txt.text = String(30 - (_asset.inputTxt.length));
		}
		
		private function __inputChange(evt:Event):void
		{
			StringHelper.checkTextFieldLength(_asset.inputTxt,50);
		}
		
		private function handleString():void
		{
			_str = "";
			_str = "["+PlayerManager.Instance.Self.NickName+"]";
			_str += LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.afficheCaput");
//			_str += "的队伍战胜";
			for(var i:int = 0 ; i < _room.defyInfo[1].length ; i++)
			{
				_str += "[" + _room.defyInfo[1][i]+ "]";
			}
			_str += LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.afficheLast");
//			_str +=  "并发表获胜宣言:";
		}
		
		public function inputCheck():Boolean
		{
			if(_asset.inputTxt.text != "")
			{
				if(FilterWordManager.isGotForbiddenWords(_asset.inputTxt.text,"name"))
				{
					HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"公告中包含非法字符");
					return false;
				}
			}
			return true;
		}
		
		private function __okClick():void
		{
			if(!inputCheck())return;
			HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.DefyAfficheView.hint"),true,sendDefy,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
			return;
		}
		
		private function sendDefy():void
		{
			if(PlayerManager.Instance.Self.Money < 500)
			{
				HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.point"),true,LeavePage.leaveToFill,null,true,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
				//HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),"您的点券不足，是否立即充值？",true,depositAction,null,true,"确   定","取   消");
				return;
			}
			handleString();
			_str += _asset.inputTxt.text;
			SocketManager.Instance.out.sendDefyAffiche(_str);
			__cancelClick();
		}
		
		private function __cancelClick():void
		{
			hide();
			dispose();
		}
		
		override public function show():void
		{
			alphaGound = false;
			TipManager.AddTippanel(this,true);
			alphaGound = true;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_room.defyInfo)_room.defyInfo = null;
			if(_asset)
			{
				_asset.inputTxt.removeEventListener(TextEvent.TEXT_INPUT ,__texeInput);
				_asset.inputTxt.addEventListener(Event.CHANGE , __texeInput);
				_asset.inputTxt.addEventListener(KeyboardEvent.KEY_DOWN , __texeInput);
			}
		}
	}
}