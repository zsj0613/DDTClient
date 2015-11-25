package ddt.consortia.club
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import tank.consortia.accect.ConsortiaItemAsset;
	import ddt.data.ConsortiaInfo;

	public class ConsortiaItem extends ConsortiaItemAsset
	{
		private var _info : ConsortiaInfo;
		private var _select : Boolean;
		private var _isApply:Boolean; //bret 09.6.16
		public function ConsortiaItem()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			setTextField(consortiaNameTxt);
			setTextField(cdrTxt);
			setTextField(consortiaPrestigeTxt);
			setTextField(levelTxt);
			setTextField(numberTxt);
			
			this.selectBg.visible       = false;
			this.selectBg.mouseEnabled  = false;
			_select = false;
			this.buttonMode = true;
			_isApply = false;
		}
		private function addEvent() : void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);	
		}
		private function __mouseOverHandler(evt : MouseEvent) : void
		{
			this.selectBg.visible       = true;
		}
		private function __mouseOutHandler(evt : MouseEvent) : void
		{
			this.selectBg.visible       = this._select;
		}
		
		private function upView() : void
		{
			this.consortiaNameTxt.text = _info.ConsortiaName;
			this.cdrTxt.text = _info.ChairmanName;
			this.numberTxt.text = String(_info.Count);
			this.levelTxt.text = String(_info.Level);
			this.consortiaPrestigeTxt.text = String(_info.Honor);
			
		}
		
		private function setTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		private function selectStyle() : void
		{
			this.selectBg.visible = _select; 
		}
		public function dispose() : void
		{
			_info = null;
			this.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
			if(this.parent)this.parent.removeChild(this);
//			_select = null;
		}
		
		public function set status(b : Boolean) : void
		{
			if(!b)
			{
				this.alpha = .5;
				this.removeEventListener(MouseEvent.MOUSE_OVER, __mouseOverHandler);
			    this.removeEventListener(MouseEvent.MOUSE_OUT,  __mouseOutHandler);
			    if(selectBg.parent)selectBg.parent.removeChild(selectBg);
			    this.buttonMode = false;
			}
		}
		public function set selectStatus(b : Boolean) : void
		{
			_select = b;
			selectStyle();
		}
		public function set info(data : ConsortiaInfo) : void
		{
			this._info = data;
			upView();
		}
		public function get info() : ConsortiaInfo
		{
			return this._info;
		}
		/* 是否申请过选中公会 */
		public function set isApply(b:Boolean):void
		{
			_isApply = b;
		}
		public function get isApply():Boolean
		{
			return _isApply;
		}
	}
}