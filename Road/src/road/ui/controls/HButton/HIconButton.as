package road.ui.controls.HButton
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class HIconButton extends HBaseButton
	{
		private var _icon:DisplayObject;
		private static var defaultIconLabelGape:Number = 3;
		public function HIconButton($bg:DisplayObject, $label:String="")
		{
			super($bg, $label);
		}
		
		public function set icon ($icon:DisplayObject):void
		{
			_icon = $icon;
			if(super.textField)
			{
				super.textField.x = _icon.width+defaultIconLabelGape;
			}
			super.container.addChild(_icon);
		}
		
		public function setIconLabelGape ($gape:Number,$point:Point = null):void
		{
			if($point)
			{
				_icon.x = $point.x;
				_icon.y = $point.y;
			}
			if(super.textField)
			{
				super.textField.x = _icon.x+_icon.width+$gape;
			}
		}
		
		public function hideIcon():void
		{
			_icon.visible = false;
		}
		
		public function showIcon():void
		{
			_icon.visible = true;
		}
	}
}