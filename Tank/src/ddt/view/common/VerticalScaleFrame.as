package ddt.view.common
{
	import flash.display.MovieClip;
	/**
	 * 此类只是用于操作纵向的拉伸窗体。
	 *  此对象不包含窗体。也没有addChild窗体中的元素。
	 * 实例化需要三个部分。具体做法参照相关的资源文件
	 */	
	
	public class VerticalScaleFrame
	{
		private var _topFrame:MovieClip;
		private var _middleFrame:MovieClip;
		private var _bottomFrame:MovieClip;
		public function VerticalScaleFrame(topFrame:MovieClip,middleFrame:MovieClip,bottomFrame:MovieClip)
		{
			_topFrame = topFrame;
			_middleFrame = middleFrame;
			_bottomFrame = bottomFrame;
		}
		/**
		 * can't set the width by .height.
		 * must set the width like "frame.setHeight(100)"
		 * 
		 */	
		private var _height:Number = 0;	
		public function setHeight($height:Number):void
		{
			if(_height == $height ) return;
			_height = $height;
			updateSize();
		}
		
		private function updateSize():void
		{
			var height:Number = Math.ceil(_height - (_topFrame.height+_bottomFrame.height));
			_middleFrame.x = _topFrame.x = _bottomFrame.x;
			_middleFrame.y = _topFrame.y+_topFrame.height;
			_middleFrame.height = height;
			_bottomFrame.y = _middleFrame.y+_middleFrame.height;
		}
		
		public function dispose():void
		{
			if(_middleFrame && _middleFrame.parent)_middleFrame.parent.removeChild(_middleFrame);
			if(_topFrame && _topFrame.parent)_topFrame.parent.removeChild(_topFrame);
			if(_bottomFrame && _bottomFrame.parent)_bottomFrame.parent.removeChild(_bottomFrame);
			_topFrame = null;
			_middleFrame = null;
			_bottomFrame = null;
		}

	}
}