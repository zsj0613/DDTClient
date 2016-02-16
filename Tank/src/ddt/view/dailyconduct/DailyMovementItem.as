package ddt.view.dailyconduct
{
	import com.dailyconduct.view.MovementInfoItemAsset;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	
	import ddt.data.MovementInfo;
	import ddt.manager.LanguageMgr;

	public class DailyMovementItem extends MovementInfoItemAsset
	{
		public function DailyMovementItem()
		{
			super();
		}
		private function init() : void
		{
			itemBg.visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
			this.addEventListener(MouseEvent.CLICK,      __mouseClickHandler);
			this.titleTxt1.mouseEnabled = false;
			this.titleTxt1.selectable   = false;
			this.titleTxt2.mouseEnabled = false;
			this.titleTxt2.selectable   = false;
			this.buttonMode            = true;
		}
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			this.itemBg.visible = true;
			setText();
		}
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			this.itemBg.visible = _isSelect;
			setText();
			
		}
		private var _isSelect : Boolean = false;
		private function __mouseClickHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			setText();
			this.dispatchEvent(new DailyConductEvent(DailyConductEvent.LINK,_info));
		}
		
		public function set selectState(b : Boolean) : void
		{
			itemBg.visible = b;
			_isSelect      = b;
			setText();
		}
		public function setText() : void
		{
			if(!_info)return;
			if(_isSelect)
			{
				titleTxt1.text = "";
				titleTxt2.text = _info.Title;
			}
			else
			{				
				titleTxt2.text = "";
				titleTxt1.text = _info.Title;
			}
			
		}
		
		private var _info : MovementInfo;
		public function set info(msg : MovementInfo) : void
		{
			_info      = msg;
			setText();
			init();
		}
		public function get info() : MovementInfo
		{
			return _info;
		}
		public function dispose() : void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,  __mouseOverHandler);
			this.removeEventListener(MouseEvent.CLICK,      __mouseClickHandler);
			if(this.parent)this.parent.removeChild(this);
			_info = null;
		}
	}
}