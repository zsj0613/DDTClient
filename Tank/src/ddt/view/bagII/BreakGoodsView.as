package ddt.view.bagII
{
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	
	import road.ui.controls.LabelField;
	import road.ui.controls.hframe.HTipFrame;
	import road.ui.manager.TipManager;
	
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.view.cells.BagCell;

	public class BreakGoodsView extends HTipFrame
	{
		private var _countTxt:LabelField;
		private var _cell:BagCell;
		
		public function BreakGoodsView(cell:BagCell)
		{
			showCancel = true;
			setContentSize(260,80);
			alphaGound = true;
			blackGound = false;
			iconVisible = false;
			okFunction = __okClick;
			fireEvent = false;
			okBtnEnable = false;

			_cell = cell;

			titleText = LanguageMgr.GetTranslation("ddt.view.bagII.BreakGoodsView.split");
			
			tipTxt(LanguageMgr.GetTranslation("ddt.view.bagII.BreakGoodsView.num"),LanguageMgr.GetTranslation("ddt.view.bagII.BreakGoodsView.input"));
			//tipTxt(LanguageMgr.GetTranslation("ddt.view.bagII.BreakGoodsView.num"),"请输入拆分数量。");
		
			layou();
			addEvent();
			getInputText.restrict = "0-9";
		}
		
		private function addEvent():void
		{
			getInputText.addEventListener(Event.CHANGE,__input);
		}
		private function removeEvent():void
		{
			getInputText.removeEventListener(Event.CHANGE,__input);
		}
		private function __input(e:Event):void
		{
			if(inputTxt == "")okBtnEnable = false;
			else okBtnEnable = true;
		}
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
		}
		
		private function __okClickCall(e:ComponentEvent):void
		{
			__okClick();
		}
	
		private function __okClick():void
		{
			var n:int = int(inputTxt);
			if(n >0 && n < _cell.itemInfo.Count)
			{
				_cell.dragCountStart(n);
				dispose();
			}
			else if(n == 0)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.BreakGoodsView.wrong2"));
				inputTxt = "";
			}else
			
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.bagII.BreakGoodsView.right"));
				inputTxt = "";
			}
		}
		
		override protected function __addToStage(evt:Event):void
		{
			super.__addToStage(evt);
		}
				
		
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}