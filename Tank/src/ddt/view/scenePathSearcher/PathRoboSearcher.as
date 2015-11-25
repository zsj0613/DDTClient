package ddt.view.scenePathSearcher
{ 

import flash.geom.Point;

import road.utils.Geometry;

/**
 * @author iiley
 */
public class PathRoboSearcher implements PathIPathSearcher {
	
	private static var LEFT:Number = -1;
	private static var RIGHT:Number = 1;
	
	private var step:Number;
	private var maxCount:Number;
	private var maxDistance:Number;
	private var stepTurnNum:Number;
	
	public function PathRoboSearcher(step:Number, maxDistance:Number, num:Number=4){
		this.step = step;
		this.maxDistance = maxDistance;
		maxCount = Math.ceil(maxDistance/step)*2;
		stepTurnNum = num;
	}
	
	/**
	 * 设置路径搜索的角度步数，比如4代表每次转动PI/4搜索，通常这个值在4-8之间就足够了
	 */
	public function setStepTurnNum(num:Number):void{
		stepTurnNum = num;
	}
	
	public function search(from : Point,end : Point,hittest:PathIHitTester) : Array {
		
		var notGoPath:Array = [from, from];
		if(from.equals(end)){
			return notGoPath;
		}
		var leftPath:Array = new Array();
		var rightPath:Array = new Array();
		var left:Boolean = searchWithWish(from, end, hittest, LEFT, leftPath);
		var right:Boolean = searchWithWish(from, end, hittest, RIGHT, rightPath);
		if(left && right)
		{
			if(leftPath.length < rightPath.length)
			{
				return leftPath;
			}
			else
			{
				return rightPath;
			}
		}else if(left){
			return leftPath;
		}else if(right){
			return rightPath;
		}else{
			return notGoPath;
		}
	}
	
	/**
	 * 返回查找到的路径,null表示查找失败
	 */
	private function searchWithWish(from : Point, tto : Point, tester : PathIHitTester, wish:Number, nodes:Array) : Boolean {
		//var endInBlock:Boolean = false;
		//如果终点就在障碍里面
		if(tester.isHit(tto)){
			//endInBlock = true;
			tto = findReversseNearestBlankPoint(from, tto, tester);
			if(tto == null){
				return false;
			}
			//如果起点也在障碍里面，那么简单直接返回这个终点
			if(tester.isHit(from)){
				nodes.push(from);
				nodes.push(tto);
				return true;
			}
		}
		
		//如果起点在障碍里面
		//if(tester.isHit(from) && !endInBlock){
		else if(tester.isHit(from)) 
		{
			//先找到起点到终点直线路径中第一个可行走点
			var midTo:Point = findReversseNearestBlankPoint(tto, from, tester);
			if(midTo == null){
				return false;
			}
			//然后再从此行走点路径搜索
			var midSearch:Boolean = searchWithWish(midTo, tto, tester, wish, nodes);
			if(midSearch){
				nodes.splice(0, 0, from);
				return true;
			}else{
				return false;
			}
		}
		
		//如果距离太远，就直接找第一个快要撞到障碍的地方
		if(Point.distance(from, tto) > maxDistance)
		{
			nodes.push(from);
			tto = findFarestBlankPoint(from, tto, tester);
			if(tto == null){
				return false;
			}
			nodes.push(tto);
			return true;
		}
				
		var aheadSearch:Boolean = doSearchWithWish(from, tto, tester, wish, nodes);
		
		if(!aheadSearch){ //正向查找失败，就直接返回失败
			return false;
		}
		
		//如果节点比较多，那么再反向查找利用反向的末端路经并合正向的开头可以合并的节点
		if(nodes.length > 4){
			var reverseNodes:Array = new Array();
			var success:Boolean = doSearchWithWish(tto, nodes[0], tester, 0-wish, reverseNodes);
			if(success){
				//因为通常倒数第二个节点和最后一个节点之间是一个比较优秀的长节点
				//所以利用反向的倒数第二个节点可以简化正向的若干个节点
				var lastZhuanze:Point = Point(reverseNodes[reverseNodes.length-2]);
				var minReplaceD:Number = step;
				for(var i:Number=1; i<nodes.length-1; i++){
					var rp:Point = Point(nodes[i]);
					if(Point.distance(rp, lastZhuanze) < minReplaceD){
						nodes.splice(1, i, lastZhuanze);
						//trace("Replace index " + i);
						return true;
					}
				}
			}
		}
		return true;
	}
	
	/**
	 * 如果返回null表示查找失败
	 */
	private function findFarestBlankPoint(from:Point, tto:Point, t:PathIHitTester):Point{
		if(t.isHit(from)){//起始点也在障碍内，那只能逆向寻找了
			return findReversseNearestBlankPoint(tto, from, t);
		}
		var heading:Number = countHeading(from, tto);
		var dist:Number = Point.distance(from, tto);
		var lastFrom:Point = from;
		while(!t.isHit(from)){
			lastFrom = from;
			from = Geometry.nextPoint(from, heading, step);
			dist -= step;
			if(dist <= 0){
				return null;
			}
		}
		from = lastFrom;
		var n:Number = 8;
		var turn:Number = Math.PI/n;
		for(var i:Number=1; i<n; i++){
			var tp:Point = Geometry.nextPoint(from, heading+i*turn, step*2);
			if(!t.isHit(tp)){
				return tp;
			}
			tp = Geometry.nextPoint(from, heading-i*turn, step*2);
			if(!t.isHit(tp)){
				return tp;
			}
		}
		return from;
	}
	
	/**
	 * 返回从tto到from直线过程(路径的逆向)中第一个没有撞到障碍的点,null表示查找失败
	 */
	private function findReversseNearestBlankPoint(from:Point, tto:Point, t:PathIHitTester):Point{
		var heading:Number = countHeading(tto, from);
		var dist:Number = Point.distance(tto, from);
		while(t.isHit(tto)){
			tto = Geometry.nextPoint(tto, heading, step);
			dist -= step;
			if(dist <= 0){
				return null;
			}
		}
		var n:Number = 12;
		var turn:Number = Math.PI/n;
		heading += Math.PI;
		for(var i:Number=1; i<n; i++){
			var tp:Point = Geometry.nextPoint(tto, heading+i*turn, step*2);
			if(!t.isHit(tp))
			{
				return tp;
			}
			tp = Geometry.nextPoint(tto, heading-i*turn, step*2);
			if(!t.isHit(tp))
			{
				return tp;
			}
		}
		return tto;
	}
	
	/**
	 * 这里的起点和终点都必须保证不在障碍内
	 */
	private function doSearchWithWish(from : Point, tto : Point, tester : PathIHitTester, wish:Number, nodes:Array) : Boolean 
	{
		nodes.push(from);
		
		var angle:Number = wish*Math.PI/stepTurnNum;
		var startDelta:Number = wish*Math.PI/2;
		var count:Number = 1;
		var maxDistance:Number = step;
		var heading:Number = countHeading(from, tto);
		var lastDistanceToEnd:Number = Point.distance(from, tto);
		
		while((lastDistanceToEnd > maxDistance) && ((count++) < maxCount))
		{
			var headingToEnd:Number = countHeading(from, tto);
			var dir:Number = heading - startDelta;
			var bb:Number = bearing(headingToEnd, dir);
			if((wish>0 && bb<0) || (wish<0 && bb>0)){
				dir = headingToEnd;
			}
			var tp:Point = Geometry.nextPoint(from, dir, step);
			
			var lastFrom:Point = from;
			var distanceToEnd:Number;
			
			if(tester.isHit(tp))
			{
				var finded:Boolean = false;
				for(var i:Number=2; i<stepTurnNum*2; i++)
				{
					dir += angle;
					tp = Geometry.nextPoint(from, dir, step);
					if(!tester.isHit(tp))
					{
						from = tp;
						distanceToEnd = Point.distance(from, tto);
						finded = true;
						break;
					}
				}
				if(!finded)
				{
					trace("cant find one");
					nodes.splice(0);
					return false; //cant find one
				}		
			}
			else
			{
				from = tp;
				distanceToEnd = Point.distance(from, tto);
			}
			if(Math.abs(bearing(heading, dir)) > 0.01){
				nodes.push(lastFrom);
				heading = dir;
			}
			lastDistanceToEnd = distanceToEnd;
		};
		if(count <= maxCount){
			nodes.push(tto);
			return true;
		}
		return false;
	}	
	
	private function countHeading(p1:Point, p2:Point):Number{
		return Math.atan2(p2.y-p1.y, p2.x-p1.x);
	}
	
	private function bearing(base:Number, heading:Number):Number{
		var b:Number = heading - base;
		b = (b + Math.PI*4)%(Math.PI*2);
		if(b < -Math.PI){
			b += Math.PI*2;
		}else if(b > Math.PI){
			b -= Math.PI*2;
		}
		return b;
	}

}

}