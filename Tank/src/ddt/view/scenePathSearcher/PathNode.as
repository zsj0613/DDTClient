package ddt.view.scenePathSearcher
{
	import flash.geom.Point;
	
	public class PathNode
	{
		//从起点A沿着产生的路径移动到当前节点的预估移动耗费        
		public var costFromStart:int=0;        
		//从当前节点移动到终点B的预估移动耗费       
		public var costToGoal:int=0;        
		//从起点A到终点B的评估耗费       
		public var totalCost:int=0;        
		public var location:Point;        
		public var parent:PathNode;                
		public function equals(node:PathNode):Boolean
		{    
			return node.location.equals(location);                
		}                
		public function toString():String
		{                
			return "x="+location.x+" y="+location.y+" G="+costFromStart                +" H="+costToGoal+" F="+totalCost;        
		}
	}
}