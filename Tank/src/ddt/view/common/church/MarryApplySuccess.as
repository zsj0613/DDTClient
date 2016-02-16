package ddt.view.common.church
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	
	import tank.church.MarryApplySuccessAsset;
	import ddt.manager.LanguageMgr;

	public class MarryApplySuccess extends HFrame
	{
		private var _okBtn : HLabelButton;
		private var _info : MarryApplySuccessAsset;
		public function MarryApplySuccess()
		{
			super();
			init();
		}
		private function init():void
		{
			blackGound = false;
			alphaGound = false;
			setSize(455,205);
			_okBtn = new HLabelButton();
			_okBtn.x = Math.floor((this.width - _okBtn.width)/2);
			_okBtn.y = 163;
			_okBtn.label = LanguageMgr.GetTranslation("ok");
			addChild(_okBtn);
			
			center();
			
			_info = new MarryApplySuccessAsset();
			_info.x = (this.width - _info.width)/2;
			_info.y = 40;
			addChild(_info);
			
			_okBtn.addEventListener(MouseEvent.CLICK,__ok);
		}
		
		override protected function __addToStage(e:Event):void
		{
			super.__addToStage(e);
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			SoundManager.Instance.play("008");
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				__ok(null);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_okBtn.removeEventListener(MouseEvent.CLICK,__ok);
			removeEventListener(KeyboardEvent.KEY_DOWN,__onKeyDown);
			_okBtn.dispose();
			_okBtn = null;
		}
		
		private function __ok(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			dispose();
			if(parent)parent.removeChild(this);
		}
	}
}