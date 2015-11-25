package ddt.view.common.church
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import tank.church.RejectProposeAsset;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.view.cells.BagCell;
	import ddt.view.cells.PersonalInfoCell;

	public class DialogueRejectPropose extends HConfirmFrame
	{
		private var _asset:RejectProposeAsset;
		private var _cell:BagCell;
		public function DialogueRejectPropose()
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = false;
			
			okFunction = __okClick;
			
			setContentSize(390,135);
			configUI();
		}
		private function configUI():void
		{
			addEventListener(Event.CLOSE,__close);
			
			_asset = new RejectProposeAsset();
			addContent(_asset);
			
			_cell = new PersonalInfoCell(-1);
			_cell.info = ItemManager.Instance.getTemplateById(11105);

			ComponentHelper.replaceChild(_asset,_asset.cell_pos,_cell);
			
		}
		
		public function set info(value:String):void
		{	
//			_asset.name_txt.defaultTextFormat = new TextFormat(null,16,0xff0000,true);
			_asset.name_txt.text = value;
			_asset.name_txt.setTextFormat(new TextFormat(LanguageMgr.GetTranslation("songti"),16,0xff0034,true));
//			_asset.name_txt.setTextFormat(new TextFormat("宋体",16,0xff0034,true));
			_asset.name_txt.filters = [new GlowFilter(0xffffff,1,4,4,10)];
			
			_asset.name_txt.width = _asset.name_txt.textWidth+8
			_asset.rightTxt.width = _asset.rightTxt.textWidth + 10
			
			var totalWidth:Number = _asset.name_txt.width + _asset.rightTxt.width
			
			_asset.name_txt.x = _asset.bottomTxt.x - totalWidth/2
			_asset.rightTxt.x = _asset.name_txt.x + _asset.name_txt.width
			
			UIManager.setChildCenter(this);
			TipManager.AddTippanel(this);
		}
		
		private function __okClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			
//			SocketManager.Instance.out.sendValidateMarry(_proposeTarget.ID);
			
			dispose();
		}
		
		private function __close(evt:Event):void
		{
			SoundManager.instance.play("008");
			dispose();
		}

		override public function dispose():void
		{
			super.dispose();
			if(parent)parent.removeChild(this);
		}
	}
}