package ddt.store.view.fusion
{
	import flash.events.Event;
	
	import game.crazyTank.view.storeII.PreviewBgAsset;
	
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.UIManager;
	
	import ddt.store.data.PreviewInfoII;
	
	import ddt.manager.LanguageMgr;
	import ddt.view.bagII.bagStore.BagStore;

	public class PreviewFrameII extends HConfirmFrame
	{
		private var _list : SimpleGrid;
		private var _bg   : PreviewBgAsset;
		public function PreviewFrameII()
		{
			super();
			init();
		}
		private function init() : void
		{
			this.titleText = LanguageMgr.GetTranslation("store.view.fusion.PreviewFrame.preview");
			this.okLabel = LanguageMgr.GetTranslation("ok");
			blackGound = false;
			alphaGound = false;
			this.showCancel = false;
			this.setContentSize(267,216);
			
			_bg = new PreviewBgAsset();
			this.addContent(_bg);
			_list = new SimpleGrid(133,93,1);
			_list.setSize(267,186);
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy   = "off";
			this.addContent(_list);
			this.okFunction = hide;
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}
		
		public function set items($list : Array) : void
		{
			for(var i:int=0;i<$list.length;i++)
			{
				var item : PreviewItem = new PreviewItem();
				item.info = $list[i] as PreviewInfoII;
				_list.appendItem(item);
			}
		}
		public function clearList() : void
		{
			for(var i:int=(_list.getItems().length-1);i>0;i--)
			{
				var item : PreviewItem = _list.getItemAt(i) as PreviewItem;
				item.dispose();
			}
			_list.clearItems();
		}
		
		override public function show():void
		{
			//TipManager.AddTippanel(this,true);
			UIManager.AddDialog(this);
		}
		
		override public function dispose() : void
		{
			clearList();
			this.removeChild(_list);
			this.removeChild(_bg);
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function removeFromStageHandler(event:Event):void{
			BagStore.Instance.reduceTipPanelNumber();
		}
		
		
	}
}