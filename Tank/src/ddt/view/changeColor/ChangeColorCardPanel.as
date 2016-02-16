package ddt.view.changeColor
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HFrame;

	public class ChangeColorCardPanel extends HFrame
	{
		private var _view:ChangeColorView;
		public function ChangeColorCardPanel(place:int)
		{
			super();
			showBottom = false;
			showClose = true;
			closeCallBack = __close;
			autoDispose = true;
			initView(place);
		}
		
		private function initView(place:int):void
		{
			setSize(820,500);
			_view = new ChangeColorView(place);
			_view.x = 10;
			_view.y = 35;
			addContent(_view,true);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
		}
		
		private function __keyDown(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ESCAPE)
			{
				SoundManager.Instance.play("008");
				__close();
			}
		}
		
		private function __close():void
		{
			if(parent)parent.removeChild(this);
		}
		override public function dispose():void
		{
			this.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			_view.dispose();
			super.dispose();
		}
	}
}