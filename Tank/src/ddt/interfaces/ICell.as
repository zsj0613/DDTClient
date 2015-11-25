package ddt.interfaces
{
	import ddt.data.goods.ItemTemplateInfo;
	
	public interface ICell
	{
		function get info():ItemTemplateInfo;
		function get place():int;
	}
}