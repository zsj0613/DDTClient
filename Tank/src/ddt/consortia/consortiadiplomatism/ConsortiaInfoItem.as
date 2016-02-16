package ddt.consortia.consortiadiplomatism
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import tank.consortia.accect.ConsortiaInfoItemAsset;
	import ddt.consortia.event.ConsortiaDataEvent;
	import ddt.data.ConsortiaInfo;
	import road.manager.SoundManager;

	public class ConsortiaInfoItem extends ConsortiaInfoItemAsset
	{
		private var _info : ConsortiaInfo;
		private var _isSelect : Boolean;
		public function ConsortiaInfoItem()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			initTextField(this.cdrTxt);
			initTextField(this.consortiaNameTxt);
			initTextField(this.countTxt);
			initTextField(this.gradeTxt);
			initTextField(this.levelTxt);
			initTextField(this.richesTxt);
			this.selectAsset.visible = false;
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(selectAsset.x,selectAsset.y,selectAsset.width,selectAsset.height);
			this.graphics.endFill();
			this.buttonMode = true;
			_isSelect       = false;
		}
		private function addEvent() : void
		{
			this.addEventListener(MouseEvent.CLICK,      __onClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
		}
		private function removeEvent() : void
		{
			this.removeEventListener(MouseEvent.CLICK,      __onClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
		}
		private function __onClickHandler(evt : MouseEvent) : void
		{
			SoundManager.Instance.play("008");
			this.dispatchEvent(new ConsortiaDataEvent(ConsortiaDataEvent.SELECT_CLICK_ITEM,this));
		}
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			this.selectAsset.visible = true;
		}
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			this.selectAsset.visible = _isSelect;
		}
		private function initTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		private function upView() : void
		{
			this.cdrTxt.text = _info.ChairmanName;
			this.consortiaNameTxt.text = _info.ConsortiaName;
			this.countTxt.text = String(_info.Count);
			this.gradeTxt.text = String(_info.Repute);
			this.levelTxt.text = String(_info.Level);
			this.richesTxt.text = String(_info.Riches);
		}
		public function set info(o : ConsortiaInfo) : void
		{
			this._info = o;
			upView();
		}
		public function get info() : ConsortiaInfo
		{
			return this._info;
		}
		public function set selectd(b : Boolean) : void
		{
			_isSelect = this.selectAsset.visible = b;
		}
		public function clearItem() : void
		{
			removeEvent();
			this.cdrTxt.text           = "";
			this.consortiaNameTxt.text = "";
			this.countTxt.text         = "";
			this.gradeTxt.text         = "";
			this.levelTxt.text         = "";
			this.richesTxt.text        = "";
			this.buttonMode            = false;
			if(selectAsset.parent)selectAsset.parent.removeChild(selectAsset);
		}
		public function dispose() : void
		{
			removeEvent();
			_info = null;
		}
		
	}
}