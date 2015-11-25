package ddt.view.sceneCharacter
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import road.ui.manager.TipManager;
	
	import ddt.events.SceneCharacterEvent;
	import ddt.view.scenePathSearcher.SceneMTween;
	
	/**
	 * 行动人物形象
	 * @author Devin
	 */
	public class SceneCharacterPlayerBase extends Sprite
	{
		private var _callBack:Function;
		private var _sceneCharacterDirection:SceneCharacterDirection=SceneCharacterDirection.RB;
		private var _sceneCharacterStateSet:SceneCharacterStateSet;//玩家状态集
		private var _sceneCharacterStateType:String;//当前玩家状态类型ID，由此来改变当前状态
		private var _sceneCharacterStateItem:SceneCharacterStateItem;//当前玩家状态
		private var _characterVisible:Boolean=true;
		protected var _moveSpeed:Number = 0.15;//移动速度 
		protected var _walkPath:Array;//行走路径
		protected var _tween:SceneMTween;
		private var _walkDistance:Number;
		protected var character:Sprite;
		private var _walkPath0:Point;
		private var po1:Point;
		
		/**
		 * 只有当有设置状态集，并指定当前状态时，人物形象才会生效
		 */		
		public function SceneCharacterPlayerBase(callBack:Function=null)
		{			
			_callBack=callBack;
			initialize();
		}
		
		private function initialize():void
		{
			_tween = new SceneMTween(this);
			character=new Sprite();
			addChildAt(character, 0);
			
			setEvent();
		}
		
		private function setEvent():void
		{
			_tween.addEventListener(SceneMTween.FINISH, __finish);
			_tween.addEventListener(SceneMTween.CHANGE, __change);
		}
		
		private function removeEvent():void
		{
			if(_tween) _tween.removeEventListener(SceneMTween.FINISH, __finish);
			if(_tween) _tween.removeEventListener(SceneMTween.CHANGE, __change);
		}
		
		private function __change(event:Event):void
		{
			dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_MOVEMENT,null));
		}
		
		/**
		 * 走下一步 
		 * @param event
		 */		
		private function __finish(event:Event):void
		{
			playerWalk(_walkPath);
			dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_ARRIVED_NEXT_STEP));
		}
		
		/**
		 * 玩家行走 
		 * @param walkPath 行走路径
		 * @param moveSpeed 行走速度
		 */			
		public function playerWalk(walkPath:Array) : void
		{
			_walkPath = walkPath;
			if(_walkPath && _walkPath.length>0)
			{
				sceneCharacterDirection=SceneCharacterDirection.getDirection(new Point(this.x,this.y),_walkPath[0]);
				dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, true));
				
				_walkPath0=_walkPath[0] as Point;
				po1=new Point(this.x,this.y);
				_walkDistance = Point.distance(_walkPath0,new Point(this.x,this.y));
				_tween.start(_walkDistance/_moveSpeed, "x", _walkPath[0].x, "y", _walkPath[0].y);
				_walkPath.shift();
			}
			else
			{
				dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE, false));
			}
		}
		
		/**
		 * 设置当前动作类型
		 */		
		public function set sceneCharacterActionType(value:String):void
		{
			if(_sceneCharacterStateItem.setSceneCharacterActionType==value) return;
			
			_sceneCharacterStateItem.setSceneCharacterActionType=value;
			dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,value));
		}
		
		/**
		 * 取得当前玩家坐标点
		 */		
		public function get playerPoint():Point
		{
			return new Point(this.x,this.y);
		}
		
		/**
		 * 设置当前玩家坐标点
		 */		
		public function set playerPoint(value:Point):void
		{
			this.x=value.x;
			this.y=value.y;
		}
		
		/**
		 * 取得人物移动速度
		 */		
		public function get moveSpeed():Number
		{
			return _moveSpeed;
		}
		
		/**
		 * 设置人物移动速度
		 */		
		public function set moveSpeed(value:Number):void
		{
			if(_moveSpeed==value) return;
			_moveSpeed = value;
		}
		
		/**
		 * 取得行走路径
		 */		
		public function get walkPath():Array
		{
			return _walkPath;
		}
		
		/**
		 * 设置行走路径
		 */		
		public function set walkPath(value:Array):void
		{
			_walkPath = value;
		}
		
		/**
		 * 设置状态集
		 */		
		protected function set sceneCharacterStateSet(value:SceneCharacterStateSet):void
		{
			_sceneCharacterStateSet=value;
			sceneCharacterStateType=_sceneCharacterStateSet.dataSet[0].type;//第一个为默认形象
			if(_callBack!=null) _callBack(this, true);
		}
		
		/**
		 * 更新人物状态行为
		 */		
		public function update():void
		{
			_sceneCharacterStateItem.sceneCharacterBase.update();
		}
		
		/**
		 * 玩家状态类型ID 
		 */		
		public function get sceneCharacterStateType():String
		{
			return _sceneCharacterStateType;
		}
		
		/**
		 * 玩家状态类型ID
		 */		
		public function set sceneCharacterStateType(value:String):void
		{
			if(_sceneCharacterStateType==value) return;
			_sceneCharacterStateType = value;
			if(!_sceneCharacterStateSet) return;
			
			_sceneCharacterStateItem=_sceneCharacterStateSet.getItem(_sceneCharacterStateType);
			
			if(!_sceneCharacterStateItem) return;
			
			while(character && character.numChildren>0)
			{
				character.removeChildAt(0);
			}
			
			character.addChild(_sceneCharacterStateItem.sceneCharacterBase);
			
			//--------------测试用，用与输出当前状态下的所有帧形象，正式启用时将代码注释掉------
			//			var testFrameBitmap:Vector.<Bitmap>=_sceneCharacterStateItem.sceneCharacterBase.testGetFrameBitmap();
			//			for (var x:int=0;x< testFrameBitmap.length;x++)
			//			{
			//				var b:Bitmap=testFrameBitmap[x];
			//				b.x=(x<7 ? x : x%7)*120;
			//				b.y=(int(x/7)*180);
			//				TipManager.AddTippanel(b);
			//			}
			//-------------------------测试用结束--------------------------------------------
		}
		
		/**
		 * 玩家方向
		 */		
		public function get sceneCharacterDirection():SceneCharacterDirection
		{
			return _sceneCharacterDirection;
		}
		
		/**
		 * 玩家方向
		 */		
		public function set sceneCharacterDirection(value:SceneCharacterDirection):void
		{
			if(_sceneCharacterDirection==value) return;
			_sceneCharacterDirection = value;
			if(_sceneCharacterStateItem) _sceneCharacterStateItem.sceneCharacterDirection=_sceneCharacterDirection;
		}
		
		public function dispose():void
		{
			while(_walkPath && _walkPath.length>0)
			{
				_walkPath.shift();
			}
			_walkPath=null;
			
			if(_tween) _tween.dispose();
			_tween=null;
			
			_sceneCharacterDirection=null;
			_callBack=null;
			
			while(_sceneCharacterStateSet && _sceneCharacterStateSet.dataSet && _sceneCharacterStateSet.length>0)
			{
				_sceneCharacterStateSet.dataSet[0].dispose();
				_sceneCharacterStateSet.dataSet.shift();
			}
			_sceneCharacterStateSet=null;
			
			if(_sceneCharacterStateItem) _sceneCharacterStateItem.dispose();
			_sceneCharacterStateItem=null;
			
			if(character)
			{
				if(character.parent) character.parent.removeChild(character);
				character=null;
			}
		}
	}
}