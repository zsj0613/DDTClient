package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.NonePswDelAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.bagII.BagEvent;
	import ddt.view.bagII.bagStore.BagStore;

	public class NoneProtectionDelFrame extends HFrame
	{
		private var _bgAsset:NonePswDelAsset;
		private var _delBtn:HLabelButton;
		
		public function NoneProtectionDelFrame()
		{
			super();
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.deletePassword");
			setContentSize(267,140);
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
			init();
			initEvents();
		}
		
		private function init():void{
			_bgAsset = new NonePswDelAsset();
			_delBtn = new HLabelButton();
			_delBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.sureToDelete");
			
			_delBtn.x = _bgAsset.delBtn.x;
			_delBtn.y = _bgAsset.delBtn.y;
			
			_bgAsset.addChild(_delBtn);
			_bgAsset.delBtn.visible = false;
			
			_bgAsset.textInput.restrict = "A-Z a-z 0-9";
			
			addContent(_bgAsset);
//			_bgAsset.leftTimes.text = String(PlayerManager.Instance.Self.leftTimes);
//			checkLeftTimes();
		}
		
		private function initEvents():void{
			_delBtn.addEventListener(MouseEvent.CLICK,mouseClickHandler);
			PlayerManager.Instance.Self.addEventListener(BagEvent.AFTERDEL,delSuccessHandler);
			addEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
		}
		
		private function addtoStageHandler(event:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			BagStore.Instance.passwordOpen = false;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ESCAPE){
				removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
				close();
			}
		}
		
		private function mouseClickHandler(event:MouseEvent):void{
			SoundManager.Instance.play("008");
			if(_bgAsset.textInput.text == ""){
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.inputOriginalPassword"));
				return;
			}
			SocketManager.Instance.out.sendBagLocked(_bgAsset.textInput.text,4);
//			PlayerManager.Instance.Self.leftTimes--;
//			refreshLeftTimes();
		}
		
//		private function refreshLeftTimes():void{
//			_bgAsset.leftTimes.text = String(PlayerManager.Instance.Self.leftTimes);
//			if(PlayerManager.Instance.Self.leftTimes < 1){
//				_bgAsset.delBtn.enabled = false;	
//			}
//		}
		
		private function delSuccessHandler(event:BagEvent):void{
			close();
			new PasswordCompleteFrame().show();
		}
		
		override public function close():void{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			super.close();
			dispose();
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		override public function dispose():void{
			SoundManager.Instance.play("008");
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			_delBtn.removeEventListener(MouseEvent.CLICK,mouseClickHandler);
			PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL,delSuccessHandler);
			super.dispose();
			BagStore.Instance.passwordOpen = true;
		}
		
		/**
		 *  检查剩余操作数目 为0 则把按钮置灰
		 */
//		 private function checkLeftTimes():void{
//		 	PlayerManager.Instance.Self.leftTimes == 0 ? (_delBtn.enable = false) : null;
//		 }
		
	}
}