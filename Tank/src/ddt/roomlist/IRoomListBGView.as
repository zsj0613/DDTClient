package ddt.roomlist
{
	import road.data.DictionaryData;
	
	public interface IRoomListBGView
	{
		function closeSortTip():void;
//		function dispose():void;
		function sortT(items:Array,key:String,value:*):void;
		function updateList():void;
		function get dataList():DictionaryData;
		function get IsPve():Boolean;
	}
}