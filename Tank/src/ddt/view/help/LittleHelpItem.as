package ddt.view.help
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	
	public class LittleHelpItem extends Sprite
	{
		private var _description:MovieClip;
		private var _backFunction:Function;
		private var _btn:HLabelButton;
		public function LittleHelpItem(description:MovieClip,backFunction:Function)
		{
			super();
			_description = description;
			_backFunction = backFunction;
			initView();
		}
		
		private function initView():void
		{
			addChild(_description);
			_btn = new HLabelButton();
			_btn.label = "操作演示";
			_btn.x = 315;
			_btn.y = _description.height + 10;
			addChild(_btn);
			_btn.addEventListener(MouseEvent.CLICK,__click);
		}
		
		private function __click(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			_backFunction();
		}
		
		public function dispose():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,__click);
			removeChild(_description);
			_description = null;
			_btn.dispose();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}