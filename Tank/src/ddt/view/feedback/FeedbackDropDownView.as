package ddt.view.feedback
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.feedback.feedbackSubmitTypeItemAsset;
	
	import road.data.DictionaryData;
	import road.ui.controls.SimpleGrid;
	
	import ddt.events.FeedbackDropDownItemEvent;

	public class FeedbackDropDownView extends SimpleGrid
	{
		/**
		 *下拉列表数据源
		 */		
		private var _dataSource:DictionaryData;
		
		public function FeedbackDropDownView(dataSource:DictionaryData, cellWitdh:uint, cellHeight:uint)
		{
			_dataSource=dataSource;
			super(cellWitdh,cellHeight,1);
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			verticalScrollPolicy = ScrollPolicy.AUTO;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			marginHeight = marginWidth = 0;
			cellPaddingHeight = 0;
			
			setEvent();
		}
		
//		override public function set height(value:Number):void
//		{
//			super.cellHeight=value;
//		}
//		
//		override public function set width(value:Number):void
//		{
//			super.cellWidth=value;
//		}
		
		private function setEvent():void
		{
//			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		private function onStageClick(evt:MouseEvent):void
		{
			if(this.parent) this.parent.removeChild(this);
			dispose();
		}
		
		override protected function configUI():void{
			super.configUI();
			creatItems();
		}
		
		private function creatItems():void{
			if(!_dataSource || _dataSource.length<=0) return;
			
			for(var i:int = 0; i < _dataSource.length; i++)
			{
				var text:FeedbackDropDownItem = new FeedbackDropDownItem(_dataSource.list[i]);
				text.addEventListener(MouseEvent.CLICK,mouseClickHandler);
				text.buttonMode = true;
				appendItem(text);
			}
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			var text:FeedbackDropDownItem=event.currentTarget as FeedbackDropDownItem;
			dispatchEvent(new FeedbackDropDownItemEvent(FeedbackDropDownItemEvent.SELECTED, text.dataSource));
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if(stage) stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			
			_dataSource.clear();
			_dataSource=null;
		}
	}
}