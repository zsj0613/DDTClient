package ddt.store
{
	import flash.utils.Dictionary;
	
	import ddt.view.cells.BagCell;
	
	/**
	 * @author WickiLA
	 * @time 12/05/2009
	 * @description 铁匠铺的面板的接口
	 * */
	
	public interface IStoreViewBG
	{
		function dragDrop(source:BagCell):void
		function refreshData(items:Dictionary):void
		function updateData():void
		function hide():void
		function show():void
	}
}