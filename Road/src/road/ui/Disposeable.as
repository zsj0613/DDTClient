package road.ui
{
	public interface Disposeable
	{
		/**
		 * 执行清除操作， 方便内存回收
		 */		
		function dispose():void;
	}
}