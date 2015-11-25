package ddt.view.feedback
{
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.feedback.feedbackSubmitTypeItemAsset;

	public class FeedbackDropDownItem extends feedbackSubmitTypeItemAsset
	{
		/**
		 *数据源 
		 */		
		private var _dataSource:Object;
		public function FeedbackDropDownItem(dataSource:Object)
		{
			_dataSource=dataSource;
			
			initialize();
		}
		
		/**
		 * 初始化运行
		 */		
		protected function initialize():void
		{
			gotoAndStop(1);
			txtText.text=_dataSource.text;
			setEvent();
		}
		
		private function setEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			gotoAndStop(2);
			txtText.text = _dataSource.text;
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			gotoAndStop(1);
			txtText.text=_dataSource.text;
		}
		
		/**
		 * 取得数据源
		 * @return 
		 * text:项文本
		 * value:项值
		 */		
		public function get dataSource():Object
		{
			return _dataSource;
		}
	}
}