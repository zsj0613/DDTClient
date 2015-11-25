package ddt.view.im
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HTipFrame;
	import road.ui.manager.TipManager;
	import road.utils.StringHelper;
	
	import ddt.manager.ChatManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.chatsystem.ChatEvent;

	public class AddFriendFrame extends HTipFrame
	{
		private var _controller:IMController;
		
		private var currentUnLock:Boolean;

		public function AddFriendFrame(controller:IMController)
		{
			_controller = controller;
			super();
			titleText = LanguageMgr.GetTranslation("ddt.view.im.AddFriendFrame.add");
			this.inputTxtWidth = 130;
			iconVisible = false;
			showCancel = true;
			alphaGound = false;
			blackGound = false;
			fireEvent = false;
			okBtnEnable = false;
			okFunction = __okClick;
			cancelFunction = __cancelClick;
			tipTxt(LanguageMgr.GetTranslation("ddt.view.im.AddFriendFrame.name")+" ",LanguageMgr.GetTranslation("ddt.view.im.AddBlackListFrame.chat"));
			setContentSize(270,112);
			
			this.maxChar = 14;
			layou();
			addEvent();
			getInputText.restrict = "^ ";
			
			tipTxtY = 20;
			tipTxt2.y = 55;
			var format:TextFormat = new TextFormat(LanguageMgr.GetTranslation("ddt.auctionHouse.view.BaseStripView.Font"),12,0x36498d);
			var filter:GlowFilter = new GlowFilter(0xffffff,1,5,5,5,1);
			var filterArray:Array = [];
			filterArray.push(filter);
			tipTxt2.filters = filterArray;
			tipTxt2.setTextFormat(format);
			tipTxt2.x = 36;
		}
		private function addEvent():void
		{
			ChatManager.Instance.output.contentField.addEventListener(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,__onNameClick);
			getInputText.addEventListener(Event.CHANGE,__input);
		}
		
		private function removeEvent():void
		{
			ChatManager.Instance.output.contentField.removeEventListener(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,__onNameClick);
			getInputText.removeEventListener(Event.CHANGE,__input);
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		private function __onNameClick(e:ChatEvent):void
		{
			inputTxt = String(e.data);
			__input(null);
		}
		
		private function __input(e:Event):void
		{
			if(inputTxt != "")okBtnEnable = true;
			else okBtnEnable = false;
		}
		private function __okClick(evt:Event = null):void
		{
			SoundManager.instance.play("008");
			var str:String = FilterWordManager.filterWrod(inputTxt);
			if(!StringHelper.isNullOrEmpty(str))
			{
				_controller.addFriend(inputTxt);
				close();
			}
			else
			{
				inputTxt = "";
				setFocus();
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.im.AddFriendFrame.qingwrite"));
			}
		}
		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			inputTxt = "";
			close();
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			__input(null);
			IMView.IS_SHOW_SUB = true;
			currentUnLock = ChatManager.Instance.lock;
			ChatManager.Instance.lock = false;
		}
		
		override public function close():void
		{
			IMView.IS_SHOW_SUB = false;
			ChatManager.Instance.lock = currentUnLock;
			super.close();
			okBtnEnable = false;
			if(stage)
			{
				stage.focus = null;
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			_controller = null;
			super.dispose();
		}
		
	}
}