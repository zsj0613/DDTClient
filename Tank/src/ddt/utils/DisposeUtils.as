package ddt.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import road.ui.controls.HButton.HBaseButton;
	
	public class DisposeUtils
	{
		public static function disposeHBaseButton(hbt : HBaseButton) : void
		{
			if(hbt)
			{
				if(hbt.parent)hbt.parent.removeChild(hbt);
				hbt.dispose();
				hbt = null;
			}
		}
		public static function disposeDisplayObject(mc : DisplayObject) : void
		{
			if(mc)
			{
				if(mc.parent)mc.parent.removeChild(mc);
				mc = null;
			}
		}
	}
}