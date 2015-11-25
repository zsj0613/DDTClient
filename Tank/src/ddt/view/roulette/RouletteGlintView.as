package ddt.view.roulette
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import tank.game.movement.BigGlintAsset;
	import tank.game.movement.GlintAsset;
	import tank.game.movement.GlintViewAsset;
	
	public class RouletteGlintView extends GlintViewAsset
	{
		private var _timer:Timer;
		/**
		 *物品cell闪动的类型  1:单闪  2:群闪
		 */		
		private var _glintType:int = 0;
		/**
		 *物品cell闪动对象的数组 
		 */		
		private var _glintArray:Array;
		
		private var _bigGlintSprite:BigGlintAsset;
		
		private var _pointArray:Array;
		
		public static const BIGGLINTCOMPLETE:String = "bigGlintComplete";
		
		public function RouletteGlintView()
		{
			init();
			initEvent();
		}
		
		private function init():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_timer = new Timer(100,1);
			_timer.stop();
			_glintArray = new Array();
			
			_pointArray = new Array();
			for(var i:int = 0 ; i <= 17 ; i++)
			{
				var point:Point = new Point(this["glint_"+i].x , this["glint_"+i].y);
				_pointArray.push(point);
				removeChild(this["glint_"+i]);
			}
		}
		
		private function initEvent():void
		{
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE , _timerComplete);
		}
		
		private function _timerComplete(e:TimerEvent):void
		{
			_timer.stop();
			_clearGlint();
		}
		
		private function _restartTimer(time:int):void
		{
			_timer.delay = time;
			_timer.reset();
			_timer.start();
		}
		
		/**
		 *单闪一个cell 
		 * @param value cell的编号
		 * @param time 闪动的时间长度
		 */		
		public function showOneCell(value:int , time:int):void
		{
			glintType = 1;
			if(value >= 0 && value <= 17)
			{
				var glintSp:GlintAsset = new GlintAsset();
				glintSp.x = _pointArray[value].x;
				glintSp.y = _pointArray[value].y
				addChild(glintSp);
				_glintArray.push(glintSp);
				
				_restartTimer(time);
			}
		}
		
		public function showTwoStep(time:int):void
		{
			glintType = 2;
			showAllCell();
			showBigGlint();
			_restartTimer(time);
		}
		
		/**
		 * 所有的cell闪动
		 * @param time 闪动的时就爱你长度
		 */		
		public function showAllCell():void
		{
			for(var i:int = 0 ; i <= 17 ; i++)
			{
				var glintSp:GlintAsset = new GlintAsset();
				glintSp.x = _pointArray[i].x;
				glintSp.y = _pointArray[i].y
				addChild(glintSp);
				_glintArray.push(glintSp);
			}
		}
		
		/**
		 * 大边框闪动
		 * 
		 */		
		public function showBigGlint():void
		{
			_bigGlintSprite = new BigGlintAsset();
			addChild(_bigGlintSprite);
		}
		
		/**
		 *清除闪动效果 
		 * 
		 */		
		private function _clearGlint():void
		{
			for(var i:int = 0 ; i < _glintArray.length ; i++)
			{
				var glintSp:GlintAsset = _glintArray[i] as GlintAsset;
				removeChild(glintSp);
			}
			
			if(_bigGlintSprite)
			{
				removeChild(_bigGlintSprite);
				_bigGlintSprite = null;
			}
			
			_glintArray.splice(0 , _glintArray.length);
			
			if(glintType == 2)
			{
				dispatchEvent(new Event(BIGGLINTCOMPLETE));
			}
		}
		
		public function set glintType(value:int):void
		{
			_glintType = value;
		}
		
		public function get glintType():int
		{
			return _glintType;
		}
		
		public function dispose():void
		{
			if(_timer)
			{
				_timer.stop();
				_timer = null;
			}
			
			if(_bigGlintSprite)
				_bigGlintSprite = null;
			
			_glintArray.splice(0 , _glintArray.length);
		}
	}
}

























