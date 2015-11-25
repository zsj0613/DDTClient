package ddt.view.common
{
	import com.trainer.asset.AnswerItemAsset;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import road.ui.controls.HButton.HGlowButton;
	
	public class UserGuideQuestionAnswerView extends HGlowButton
	{
		private var _id : int;
		private var _isSelect : Boolean = false;
		private var _asset:AnswerItemAsset;
		
		public function UserGuideQuestionAnswerView($id : int)
		{
			_asset = new AnswerItemAsset();
			super(_asset,"","");
			_id = $id;
			init();
			addEvent();
		}
		override protected function init() : void
		{
			super.init();
			_asset.contextTxt.mouseEnabled = false;
			_asset.contextTxt.selectable   = false;
			_asset.ItemBgMc.visible        = true;
			_asset.buttonMode              = true;
		}
		public function get IconAsset():MovieClip{
			return _asset.IconAsset;
		}
		override protected function addEvent() : void
		{
			super.addEvent();
			addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
		}
		override protected function removeEvent() : void
		{
			super.removeEvent();
			removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, __mouseOutHandler);
		}
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			_asset.ItemBgMc.visible = true;
		}
		
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			_asset.ItemBgMc.visible = true;
		}
		public function set isSelect(b : Boolean) : void
		{
			_isSelect = b;
			__mouseOutHandler(null);
		}
		public function get isSelect() : Boolean
		{
			return _isSelect;
		}
		public function set title($msg : String) : void
		{
			_asset.contextTxt.text = $msg;
		}
		public function get id() : int
		{
			return _id;
		}
		override public function dispose() : void
		{
			removeEvent();
			if(this.parent)this.parent.removeChild(this);
		}
		
		
	}
}