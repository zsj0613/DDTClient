package road.ui.tip
{
	import road.display.IDisplayObject;
	public interface ITip extends IDisplayObject
	{
		/**
		 * 
		 * tip的数据
		 * 
		 */		
		function get tipData():Object;
		function set tipData(data:Object):void
	}
}