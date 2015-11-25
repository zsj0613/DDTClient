package ddt.interfaces
{
	import ddt.view.cells.DragEffect;
	
	public interface IDragable
	{
		function getSource():IDragable;
		function dragStop(effect:DragEffect):void;
	}
}