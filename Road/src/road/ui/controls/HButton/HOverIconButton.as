package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class HOverIconButton extends HBaseButton
	{
		public function HOverIconButton($bg:DisplayObject, $label:String="")
		{
			super($bg, $label);
			if(_bg &&  _bg["mouseover"])_bg["mouseover"].visible = false;
		}
		override protected function outHandler(evt:MouseEvent):void
		{
		   if(_bg &&  _bg["mouseover"])_bg["mouseover"].visible = false;
		}
		override protected function overHandler(evt:MouseEvent):void
		{
		   if(_bg &&  _bg["mouseover"])_bg["mouseover"].visible = true;
		}
	}
}