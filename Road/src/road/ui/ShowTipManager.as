package road.ui
{
	import road.display.IDisplayObject;
	import road.toplevel.StageReferance;
	import road.ui.tip.ITip;
	import road.utils.Directions;
	import road.utils.DisplayUtils;
	import road.utils.ObjectUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	public final class ShowTipManager
	{
		public static const StartPoint:Point = new Point(0,0);
		private static var _instance:ShowTipManager;

		public static function get Instance():ShowTipManager
		{
			if(_instance == null)
			{
				_instance = new ShowTipManager();
			}
			return _instance;
		}
		
		public function ShowTipManager()
		{
			_tips = new Dictionary();
			_tipedObjects = new Vector.<ITipedDisplay>();
		}
		
		private var _currentTipObject:ITipedDisplay;
		private var _simpleTipset:Object;
		private var _tipContainer:DisplayObjectContainer;
		private var _tipedObjects:Vector.<ITipedDisplay>;
		private var _tips:Dictionary;
		/**
		 * 
		 * @param tipedDisplay 显示tip的鼠标相应对象
		 * 
		 */		
		public function addTip(tipedDisplay:ITipedDisplay):void
		{
			if(tipedDisplay == null)return;
			removeTipedObject(tipedDisplay);
			_tipedObjects.push(tipedDisplay);
			tipedDisplay.addEventListener(MouseEvent.ROLL_OVER,__onOver);
			tipedDisplay.addEventListener(MouseEvent.ROLL_OUT,__onOut);
		}
		/**
		 * 
		 * @param tip 所要显示的tip
		 * @param target 显示tip的鼠标相应对象
		 * @param direction tip所显示的方向
		 * @return tip所显示的位置（以target的注册点为注册点）
		 * 
		 */		
		public function getTipPosByDirction(tip:ITip,target:ITipedDisplay,direction:int):Point
		{
			var resultPos:Point = new Point();
			if(direction == Directions.DIRECTION_T)
			{
				resultPos.y = - tip.height - target.tipGap;
				resultPos.x = (target.width - tip.width)/2;
			}else if(direction == Directions.DIRECTION_L)
			{
				resultPos.x = - tip.width - target.tipGap;
				resultPos.y = (target.height - tip.height)/2;
			}else if(direction == Directions.DIRECTION_R)
			{
				resultPos.x = target.width + target.tipGap;
				resultPos.y = (target.height - tip.height)/2;
			}else if(direction == Directions.DIRECTION_B)
			{
				resultPos.y = target.height + target.tipGap;
				resultPos.x = (target.width - tip.width)/2;
			}else if(direction == Directions.DIRECTION_TL)
			{
				resultPos.y = - tip.height - target.tipGap;
				resultPos.x = - tip.width - target.tipGap;
			}else if(direction == Directions.DIRECTION_TR)
			{
				resultPos.y = - tip.height - target.tipGap;
				resultPos.x = target.width + target.tipGap;
			}else if(direction == Directions.DIRECTION_BL)
			{
				resultPos.y = target.height + target.tipGap;
				resultPos.x = - tip.width - target.tipGap;
			}else if(direction == Directions.DIRECTION_BR)
			{
				resultPos.y = target.height + target.tipGap;
				resultPos.x = target.width + target.tipGap;
			}
			return resultPos;
		}
		/**
		 * 
		 * @param target 所要隐藏tip的目标对象
		 * 
		 */		
		public function hideTip(target:ITipedDisplay):void
		{
			var tip:ITip = _tips[target.tipStyle];
			if(tip == null)return;
			if(_tipContainer.contains(tip.asDisplayObject()))
			{
				_tipContainer.removeChild(tip.asDisplayObject());
			}
		}
		/**
		 * 
		 * @param tipedDisplay 所要移除的tip的目标对象
		 * 
		 */		
		public function removeTip(tipedDisplay:ITipedDisplay):void
		{
			removeTipedObject(tipedDisplay);
			if(_currentTipObject == tipedDisplay)hideTip(_currentTipObject);
		}
		/**
		 * 设置简单的tip
		 * @param target tip的目标对象
		 * @param tipMsg tip的内容
		 * 
		 */		
		public function setSimpleTip(target:ITipedDisplay,tipMsg:String = ""):void
		{
			if(_simpleTipset == null)return;
			if(target is Component)Component(target).beginChanges();
			target.tipStyle = _simpleTipset.tipStyle;
			target.tipData = tipMsg;
			target.tipDirctions = _simpleTipset.tipDirctions;
			target.tipGap = _simpleTipset.tipGap;
			if(target is Component)Component(target).commitChanges();
		}
		/**
		 * 
		 * @param tipContainer tip的容器
		 * @param simpleTipset 简单tip的设置
		 * 
		 */		
		public function setup(tipContainer:DisplayObjectContainer,simpleTipset:Object = null):void
		{
			_tipContainer = tipContainer;
			_simpleTipset = simpleTipset;
		}
		/**
		 * 显示tip
		 * @param target 显示tip的对象
		 * 
		 */		
		public function showTip(target:ITipedDisplay):void
		{
			var tip:ITip = _tips[target.tipStyle];
			if(tip == null)
			{
				_tips[target.tipStyle] = ComponentFactory.Instance.creat(target.tipStyle);
				tip = _tips[target.tipStyle];
				if(tip == null) return;
			}
			tip.tipData = target.tipData;
			var startPos:Point = _tipContainer.globalToLocal(target.localToGlobal(StartPoint));
			var resultPos:Point = new Point();
			var resultDirection:int = getTipPriorityDirction(tip,target,target.tipDirctions);
			resultPos = getTipPosByDirction(tip,target,resultDirection);
			resultPos.x = resultPos.x+startPos.x;
			resultPos.y = resultPos.y+startPos.y;
			tip.x = resultPos.x;
			tip.y = resultPos.y;
			_currentTipObject = target;
			_tipContainer.addChild(tip.asDisplayObject());
		}
		
		private function __onOut(event:MouseEvent):void
		{
			var target:ITipedDisplay = event.currentTarget as ITipedDisplay;
			hideTip(target);
		}
		
		private function __onOver(event:MouseEvent):void
		{
			var target:ITipedDisplay = event.currentTarget as ITipedDisplay;
			showTip(target);
		}
		
		private function getTipPriorityDirction(tip:ITip,target:ITipedDisplay,directions:String):int
		{
			var dirs:Array = directions.split(",");
			if(dirs.length == 0)return 0;
			if(dirs.length == 1)return int(dirs[0]);
			var resultDirection:int = 0;
			resultDirection = -1;
			var startPos:Point = _tipContainer.globalToLocal(target.localToGlobal(StartPoint));
			for(var i:int = 0;i<dirs.length;i++)
			{
				var ordinaryPos:Point = getTipPosByDirction(tip,target,dirs[i]);
				var resultStartPos:Point = new Point(ordinaryPos.x+startPos.x,ordinaryPos.y+startPos.y);
				var resultEndPos:Point = new Point(ordinaryPos.x+startPos.x+tip.width,ordinaryPos.y+startPos.y+tip.height);
				if(DisplayUtils.isInTheStage(resultStartPos) && DisplayUtils.isInTheStage(resultEndPos))
				{
					resultDirection = int(dirs[i]);
					break;
				}
			}
			if(resultDirection == -1)return int(dirs[0]);
			return resultDirection;
		}
		
		private function removeTipedObject(tipedDisplay:ITipedDisplay):void
		{
			var index:int = _tipedObjects.indexOf(tipedDisplay);
			tipedDisplay.removeEventListener(MouseEvent.ROLL_OVER,__onOver);
			tipedDisplay.removeEventListener(MouseEvent.ROLL_OUT,__onOut);
			if( index != -1)
			{
				_tipedObjects.splice(index,1);
			}
		}
		
		public function removeCurrentTip():void
		{
			removeTipedObject(_currentTipObject);
		}
	}
}