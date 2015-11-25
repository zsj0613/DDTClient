package ddt.view.cells
{
	import ddt.interfaces.IAcceptDrag;
	import ddt.interfaces.IDragable;
	
	public class DragEffect
	{
		public static const NONE:String = "none";
		public static const MOVE:String = "move";
		public static const LINK:String = "link";
		public static const SPLIT:String = "split";
		
		public var source:IDragable;
		public var target:IAcceptDrag;
		public var action:String;
		public var data:*
		
		public function get hasAccpeted():Boolean
		{
			return target != null;
		}
		
		public function DragEffect(source:IDragable,data:*,action:String = "none",target:IAcceptDrag = null)
		{
			this.source = source;
			this.target = target;
			this.action = action;
			this.data = data;
		}
		
	}
}