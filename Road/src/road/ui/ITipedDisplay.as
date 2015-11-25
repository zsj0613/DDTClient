package road.ui
{
	import road.display.IDisplayObject;

	public interface ITipedDisplay extends IDisplayObject
	{
		/**
		 * 
		 * TIP样式 在创建TIP时，会通过ComponentFactory.Instance.creat方法来创建。
		 * 
		 */
		function get tipStyle():String;
		
		/**
		 * tip用于显示的数据对象
		 */
		function get tipData():Object;
		
		/**
		 * 在前面的优先级高。
		 * 
		 * 例如 tipDirctions="7,0" 组件会优先查找方向7显示是否正常(有没有超出屏幕)
		 * 如果没有超出那么TIP将会以方向7来进行展示，如果方向7显示不正常，那么将会查找0方向
		 * 的显示是否正常，如果显示正常那么将以方向0来进行展示，如果方向0与方向7都显示不正常
		 * 那么将会以优先级最高的那么个也就是方向7来进行展示
		 * 
		 * 具体方向参见 Directions类
		 * 具体显示规则参见ShowTipManager 的 showTip方法
		 */
		function get tipDirctions():String;
		
		/**
		 * TIP 的目标对象与TIP之间的间距
		 */
		function get tipGap():int;
			
		function set tipStyle(value:String):void
		
		function set tipData(value:Object):void
		
		function set tipDirctions(value:String):void
		
		function set tipGap(value:int):void
	}
}