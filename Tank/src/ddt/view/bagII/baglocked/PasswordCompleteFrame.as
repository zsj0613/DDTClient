package ddt.view.bagII.baglocked
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import game.crazyTank.view.bagII.PasswordCompleteAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.view.bagII.bagStore.BagStore;

	public class PasswordCompleteFrame extends HFrame
	{
		private var _bgAsset:PasswordCompleteAsset;
		private var _completeBtn:HLabelButton;
		private var _type:int;
		
		public function PasswordCompleteFrame()
		{
			super();
			init();
			initEvents();
			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.resetting");
			setContentSize(329,115);
			blackGound = false;
			centerTitle = false;
			alphaGound = true;
		}
		
		private function init():void{

			_bgAsset = new PasswordCompleteAsset;
			_bgAsset.completeBtn.visible = false;
			_completeBtn = new HLabelButton();
			_completeBtn.label = LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.immediatelyComplete");
			_completeBtn.x = _bgAsset.completeBtn.x;
			_completeBtn.y = _bgAsset.completeBtn.y;
			_bgAsset.addChild(_completeBtn);
			
			addContent(_bgAsset);
		}
		
		private function initEvents():void{
			_completeBtn.addEventListener(MouseEvent.CLICK,completeBtnClickHandler);
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
		
		private function completeBtnClickHandler(event:MouseEvent):void{
			SoundManager.Instance.play("008");
			new PasswordProtectionFrame("complete").show();
			close();
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
			removeEventListener(Event.ADDED_TO_STAGE,addtoStageHandler);
			SoundManager.Instance.play("008");
			super.dispose();
		}
		
	}
}