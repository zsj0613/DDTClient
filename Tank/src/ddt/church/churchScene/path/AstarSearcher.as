package ddt.church.churchScene.path
{
	import flash.geom.Point;

	public class AstarSearcher implements IPathSearcher
	{
		private var open_list : Array;
		private var close_list : Array;
		//路径数组
		private var path_arr : Array;
		//开始点
		private var setOut_point : AstarPoint;
		//目标点
		private	var aim_point : AstarPoint;
		//当前点
		private	var current_point : AstarPoint;
		//步长
		private var step_len : int;
		//检测碰撞
		private var hittest : IHitTester;
		
		//记录最后一点
		private var record_start_point:AstarPoint;
		/*
		 * 
		 */
		public function AstarSearcher(n : int)
		{
			step_len = n;
		}

		public function search(from : Point,end : Point,hittest : IHitTester) : Array 
		{
			
			aim_point=new AstarPoint(end.x,end.y);
			record_start_point=new AstarPoint(from.x,from.y);
			//修改始点坐标
			var xModify:int=0;
			var yModify:int=0;
			if (end.x>from.x) {
				xModify=from.x - (step_len - Math.abs(end.x - from.x) % step_len);
			} else {
				xModify=from.x + (step_len - Math.abs(end.x - from.x) % step_len);
			}
			if (end.y>from.y) {
				yModify=from.y - (step_len - Math.abs(end.y - from.y) % step_len);
			} else {
				yModify=from.y + (step_len - Math.abs(end.y - from.y) % step_len);
			} 
			setOut_point=new AstarPoint(xModify,yModify);
			current_point = setOut_point;
			this.hittest = hittest;
			init();
			//寻找路径
			findPath();
			return path_arr;
		}

		/*
		 * 初始化
		 */
		private function init() : void
		{
			//step_len=20;
			open_list = new Array();
			close_list = new Array();
			path_arr = new Array();
		} 

		/*
		 * 寻找路径
		 */
		private function findPath() : void
		{
			open_list.push(setOut_point);
			//继续的条件
			var goon : Boolean = true;
			while(open_list.length > 0 && goon)
			{
				//从open_list表中取出第一个元素进行散发
				current_point = open_list.shift();
				
				if(current_point.x == aim_point.x && current_point.y == aim_point.y)
				{
					//此条件可改
					//到达终点，结束
					goon = false;
					aim_point=nodes[i];
					aim_point.source_point=current_point;
					break;
				}else
				{
					//产生子结点
					var nodes : Array = new Array();
					nodes = createNode(current_point);
					var g_tmp : Number = 0;
					var f_tmp : Number = 0;
					var h_tmp : Number = 0;
					for(var i:int = 0;i < nodes.length;i++)
					{
						if(nodes[i].x == aim_point.x && nodes[i].y == aim_point.y)
						{
							//此条件可改
							goon = false;
							aim_point=nodes[i];
							aim_point.source_point=current_point;
							//nodes[i].source_point = current_point;
							break;
						}
						if(existInArray(open_list, nodes[i]) == -1 && existInArray(close_list, nodes[i]) == -1)
						{
							//不在open列表和close列表中
							if(!hittest.isHit(nodes[i]))
							{
								//放入open列表
								nodes[i].source_point = current_point;
								g_tmp = getEvaluateG(nodes[i]);
								h_tmp = getEvaluateH(nodes[i]);
								setEvaluate(nodes[i], g_tmp, h_tmp);
								open_list.push(nodes[i]);
							}
						}else if(existInArray(open_list, nodes[i]) != -1)
						{
							//在open 表中
							g_tmp = getEvaluateG(nodes[i]);
							h_tmp = getEvaluateH(nodes[i]);
							f_tmp = g_tmp + h_tmp;
							if(f_tmp < nodes[i].f)
							{
								nodes[i].source_point = current_point;
								setEvaluate(nodes[i], g_tmp, h_tmp);
							}
						}else
						{
							//在close表中
							g_tmp = getEvaluateG(nodes[i]);
							h_tmp = getEvaluateH(nodes[i]);
							f_tmp = g_tmp + h_tmp;
							if(f_tmp < nodes[i].f)
							{
								nodes[i].source_point = current_point;
								setEvaluate(nodes[i], g_tmp, h_tmp);
								open_list.push(nodes[i]);
								//从close表中删除
								close_list.splice(existInArray(close_list, nodes[i]), 1);
							}
						}
					}
				}
				//节点加入close列表，表示已被访问过
				close_list.push(current_point);
				//对open列表进行排序 
				open_list.sortOn("f", Array.NUMERIC);
				if(open_list.length > 30)
				{
					open_list = open_list.slice(0, 30);
				}
			}
			createPath();
		}

		/*
		 * 生成最短路径
		 */
		private function createPath() : void
		{
			var this_point : AstarPoint = new AstarPoint();
			this_point = aim_point;
		
			while(this_point != setOut_point)
			{
				path_arr.unshift(this_point);
				if(this_point.source_point!=null) {
					this_point = this_point.source_point;
				}else{
					path_arr=new Array();
					path_arr.push(record_start_point,record_start_point);
					return;
				}
			}
			path_arr.splice(0,0,record_start_point);
		}

		/*
		 * 设评估值
		 */
		private function setEvaluate(point : AstarPoint,g : Number,h : Number):void
		{
			point.g = g;
			point.h = h;
			point.f = point.g + point.h;
		}

		/*
		 * 获得评估值(不改变值)
		 */
		private function getEvaluateG(point : AstarPoint) : int
		{
			var g_tmp : int = 0;
			if(current_point.x == point.x || current_point.y == point.y)
			{
				g_tmp = 10;
			}else
			{
				g_tmp = 14;
			}
			g_tmp += current_point.g;
			return g_tmp;
		}

		private function getEvaluateH(point : AstarPoint) : int
		{
			
			return Math.abs(aim_point.x - point.x) * 10 + Math.abs(aim_point.y - point.y) * 10;
		}

		/*
		 * 产生子结点
		 */
		private function createNode(point : AstarPoint) : Array
		{
			var arr : Array = new Array();
			arr.push(new AstarPoint(point.x, point.y - step_len));
			arr.push(new AstarPoint(point.x - step_len, point.y));
			arr.push(new AstarPoint(point.x + step_len, point.y));
			arr.push(new AstarPoint(point.x, point.y + step_len));
			
			//增加斜线方向
			arr.push(new AstarPoint(point.x - step_len, point.y - step_len));
			arr.push(new AstarPoint(point.x + step_len, point.y - step_len));
			arr.push(new AstarPoint(point.x - step_len, point.y + step_len));
			arr.push(new AstarPoint(point.x + step_len, point.y + step_len));
			
			return arr;
		} 

		/*
		 * 检测数组中是否有某值相同的元素
		 */
		private function existInArray(arr : Array,point : AstarPoint) : int
		{
			var n : int = -1;
			for(var i : int = 0;i < arr.length;i++)
			{
				if(arr[i].x == point.x && arr[i].y == point.y)
				{
					n = i;
					break;
				}
			}
			return n;
		}
	}
}
