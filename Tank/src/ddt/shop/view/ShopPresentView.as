package ddt.shop.view
{
	import fl.controls.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.SimpleTextArea;
	import road.ui.controls.hframe.HFrame;
	import road.utils.ComponentHelper;
	
	import ddt.shop.ShopController;
	
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	
	import webGame.crazyTank.view.shopII.ShopIIPresentBGAsset;

	public class ShopPresentView extends ShopIIPresentBGAsset
	{
		private var _bg:HFrame;
		private var _text:SimpleTextArea;
		private var _playerlist:ShopPlayerListView;
		private var _doSend:Function;
		private var okBtn:HLabelButton;
		private var cancelBtn:HLabelButton;
		private var com_btn:HBaseButton;
		private var _controller:ShopController;
		
		public function ShopPresentView(controller:ShopController)
		{
			_controller = controller;	
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_bg = new HFrame();
			_bg.IsSetFouse = false;
			_bg.setSize(400,436);
			_bg.moveEnable = false;
			addChildAt(_bg,0);
			
			_bg.showClose = false;
			
			okBtnAccect.visible = false;
			cancelBtnAccect.visible = false;
			
			okBtn = new HLabelButton();
			okBtn.x = 30;
			okBtn.y = 393;
			okBtn.label = LanguageMgr.GetTranslation("ok");
			addChild(okBtn);
			cancelBtn = new HLabelButton();
			cancelBtn.x = 262;
			cancelBtn.y = 393;
			cancelBtn.label = LanguageMgr.GetTranslation("cancel");
			addChild(cancelBtn);
			
			com_btn = new HBaseButton(comBtnAccect);
			com_btn.useBackgoundPos = true;
			addChild(com_btn);
			
			_text = new SimpleTextArea();
			_text.setStyle("upSkin",new Sprite());
			ComponentHelper.replaceChild(this,content_pos,_text);
			var t:TextFormat = new TextFormat("Arial",12);
			t.leading = 7;
			_text.maxChars = 200;
			_text.setStyle("textFormat",t);
			
			_playerlist = new ShopPlayerListView(doSelected);
			_playerlist.x = playerlist_pos.x;
			_playerlist.y = playerlist_pos.y;
			addChild(_playerlist);
			playerlist_pos.visible = false;
			_playerlist.visible = false;
			
			name_txt.maxChars = 25;
		}
		
		private function initEvent():void
		{
			com_btn.addEventListener(MouseEvent.CLICK,__comClick);
			okBtn.addEventListener(MouseEvent.CLICK,__okClick);
			cancelBtn.addEventListener(MouseEvent.CLICK,__cancelClick);
			addEventListener(Event.ADDED_TO_STAGE, __addStageHandler);
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
		
		private function __addStageHandler(evt : Event) : void
		{
			name_txt.stage.focus = name_txt;
			stage.focus = this;
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				__cancelClick(null);
			}
		}
		
		private function __comClick(evt:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			evt.stopImmediatePropagation();
			_playerlist.visible = true;
			stage.addEventListener(MouseEvent.CLICK,__stageClick);
		}
		
		private function __stageClick(evt:MouseEvent):void
		{
			if(evt.target is BaseButton)return;
			evt.stopImmediatePropagation();
			_playerlist.visible = false;
		}
		
		private function __okClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			
			var str:String = FilterWordManager.filterWrod(_text.text);//bret 09.8.2
			
			if(name_txt.text == "")
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
				//MessageTipManager.getInstance().show("请设置赠送对象");
				return;
			}
			else if(FilterWordManager.IsNullorEmpty(name_txt.text))
			{
				
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
				//MessageTipManager.getInstance().show("赠送对象不能全部为空格");
				return;
			}
			if(PlayerManager.Instance.Self.bagLocked)
			{
//				HConfirmDialog.show("提示","二级密码尚未解锁，不可进行操作。");
				new BagLockedGetFrame().show();
				return;
			}
			dispose();
			_controller.presentItems(_controller.model.allItems,str,name_txt.text);
			_controller.model.clearAllitems();
		}
		
		private function doSelected(nick:String):void
		{
			name_txt.text = nick;
		}
		
		private function __cancelClick(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			dispose();
		}
		
		public function dispose():void
		{
			stage.removeEventListener(MouseEvent.CLICK,__stageClick);
			okBtn.removeEventListener(MouseEvent.CLICK,__okClick);
			cancelBtn.removeEventListener(MouseEvent.CLICK,__cancelClick);
			removeEventListener(Event.ADDED_TO_STAGE, __addStageHandler);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			if(parent)parent.removeChild(this);
		}
	}
}