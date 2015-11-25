package ddt.view.common
{
	import flash.text.TextFieldAutoSize;
	
	import tank.consortia.accect.ConsortiaEventAsset;
	import ddt.data.ConsortiaEventInfo;

	public class MyConsortiaEventItem extends ConsortiaEventAsset
	{
		/**1.宣战，2.议和，3.结盟，4,解盟，5.捐献**/
		public function MyConsortiaEventItem()
		{
			super();
			init();
		}
		private function init() : void
		{
			this.eventContentTxt.selectable = false;
			this.eventContentTxt.mouseEnabled = false;
			this.eventContentTxt.wordWrap = true;
			this.eventContentTxt.autoSize = TextFieldAutoSize.LEFT;
		}
		
		
		
		
		private var _info : ConsortiaEventInfo;
		public function set info(o : ConsortiaEventInfo) : void
		{
			this._info = o;
			this.eventContentTxt.text = o.Remark;
			switch(o.Type)
			{
				case 1:
				this.stateAsset.gotoAndStop(3);
				break;
				case 2:
				this.stateAsset.gotoAndStop(1);
				break;
				case 5:
				this.stateAsset.gotoAndStop(2);
				break;
				
			}
			
		}
		public function get info() : ConsortiaEventInfo
		{
			return this._info;
		}
		public function dispose() : void
		{
			this._info = null;
			if(this.parent)this.parent.removeChild(this);
			
		}
		
	}
}