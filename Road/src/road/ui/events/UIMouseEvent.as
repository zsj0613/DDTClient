package road.ui.events
{
	import flash.events.MouseEvent;

	public class UIMouseEvent extends MouseEvent
	{
		public static const RIGHT_CLICK:String = "rightClick";
		
		public function UIMouseEvent(type:String,localX:Number= 0, localY:Number=0)
		{
			super(type,true,false, localX, localY);
		}
		
	}
}