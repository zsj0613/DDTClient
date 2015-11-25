package ddt.view.cells
{
	import ddt.data.goods.ItemTemplateInfo;
	
	public interface ICellFactory
	{
		function createBagCell(place:int,info:ItemTemplateInfo = null,showLoading:Boolean = true):ICell;
		function createPersonalInfoCell(place:int,info:ItemTemplateInfo = null,showLoading:Boolean = true):ICell;
	}
}