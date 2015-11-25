package road.ui.controls.HButton
{
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	public class SimpleButtonFormat implements IButtonFormat
	{
		private var overFormat:TextFormat;
		private var hitFormat:TextFormat;
		private var upFormat:TextFormat;
		private var myColorMatrix_filter:ColorMatrixFilter;
		private var lightingFilter:BitmapFilter;
		private var _textFilter:Array;
		public function SimpleButtonFormat():void
		{
			init();
		}
		
		private function init():void
		{
			
			overFormat = new TextFormat(null,14,0xffffff,true);
			
			overFormat.letterSpacing = 2;
			hitFormat = new TextFormat(null,14,0xffffff,true);
			upFormat = new TextFormat(null,14,0xffffff,true);
			setUpGrayFilter();
			setUpLintingFilter();
		}
		
		private function setUpGrayFilter():void {
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			myColorMatrix_filter = new ColorMatrixFilter(myElements_array);
		}
		
		private function setUpLintingFilter():void
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 25]);// red
			matrix = matrix.concat([0, 1, 0, 0, 25]);// green
			matrix = matrix.concat([0, 0, 1, 0, 25]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			lightingFilter = new ColorMatrixFilter(matrix);   //这里好像是 new BitmapFilter(matrix);
		}
		
		public function setOverFormat(b:HBaseButton):void
		{
			if(b.textField)
			{
				b.textField.defaultTextFormat = overFormat;
			}
			b.filters = [lightingFilter];
		}
		
		public function setOutFormat(b:HBaseButton):void
		{
			if(b.textField)
			{
				b.textField.defaultTextFormat = overFormat;
			}
			b.container.x = 0;
			b.container.y = 0;
			b.filters = null;
		}
		
		public function setDownFormat(b:HBaseButton):void
		{
			if(b.textField)
			{
				b.textField.defaultTextFormat = overFormat;
			}
			b.container.x = 1;
			b.container.y = 1;
			b.filters = [lightingFilter];
		}
		public function setUpFormat(b:HBaseButton):void
		{
			if(b.textField)
			{
				b.textField.defaultTextFormat = overFormat;
			}
			b.container.x = 0;
			b.container.y = 0;
		}
		
		public function setEnable(b:HBaseButton):void
		{
			b.filters = null;
		}
		
		public function setNotEnable(b:HBaseButton):void
		{
			
			b.filters = [myColorMatrix_filter];
		}
		
		public function dispose():void
		{
			overFormat = null;
			hitFormat = null;
			upFormat = null;
			myColorMatrix_filter = null;
			lightingFilter = null;
			_textFilter = null;
		}
		
	}
}