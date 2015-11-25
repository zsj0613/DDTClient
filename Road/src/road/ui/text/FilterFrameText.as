package road.ui.text
{
	import road.ui.ComponentFactory;
	import road.utils.ObjectUtils;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * 
	 * @author Herman
	 * 支持跳帧的文本 跳帧的实现主要是文本的滤镜不一样
	 * 
	 */	
	public class FilterFrameText extends Text
	{
		public static const P_frameFilters:String = "frameFilters";

		public function FilterFrameText()
		{
			super();
			_currentFrameIndex = 1;
		}

		private var _currentFrameIndex:int;
		private var _filterString:String;
		private var _frameFilter:Array;
		
		override public function dispose():void
		{
			_frameFilter = null;
			super.dispose();
		}
		
		override public function draw():void
		{
			if(_changedPropeties[P_frameFilters])
			{
				setFrame(_currentFrameIndex);
			}
			super.draw();
			
		}
		
		
		public function set filterString(filters:String):void
		{
			if(_filterString == filters) return;
			_filterString = filters;
			frameFilters = ComponentFactory.Instance.creatFilters(_filterString);
		}
		
		public function set frameFilters(filter:Array):void
		{
			if(_frameFilter == filter) return;
			_frameFilter = filter;
			onPropertiesChanged(P_frameFilters);
		}
		
		override public function setFrame(frameIndex:int):void
		{
			if(_frameFilter == null || frameIndex <= 0 || frameIndex > _frameFilter.length)return;
			_field.filters = _frameFilter[frameIndex - 1];
		}
		
		override protected function addChildren():void
		{
			addChild(_field);
		}
		
		override protected function onProppertiesUpdate():void
		{
			super.onProppertiesUpdate();
			setFrame(_currentFrameIndex);
		}
	}
}