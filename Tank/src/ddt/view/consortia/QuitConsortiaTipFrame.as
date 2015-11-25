package ddt.view.consortia
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import tank.consortia.accect.QuitConsortisTipAsset;
	
	public class QuitConsortiaTipFrame extends HConfirmFrame
	{
		private var _view:QuitConsortisTipAsset;
		private var _message:String
		
		public function QuitConsortiaTipFrame(message:String)
		{
			super();
			_message = message;
			init();
		}
		
		private function init():void
		{

			_view = new QuitConsortisTipAsset();
			_view._meeageText.x = (_view.width - _view._meeageText.width) / 2;
			_view._meeageText.text = _message;
			
			setSize(_view.width,_view.height+40);
			addContent(_view);
			this.showCancel = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(_view) _view = null;
			
			if(this.parent)
				this.parent.removeChild(this);
		}
	}
}





