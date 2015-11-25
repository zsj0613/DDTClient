package ddt.view.scenePathSearcher
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;	
	
	public class SceneMTween extends EventDispatcher {
		//已更改并且屏幕已更新
		public static const FINISH : String = "finish";
		//已到达结尾并已完成
		public static const CHANGE : String = "change";
		//开始播放
		public static const START : String = "start";
		//已停止
		public static const STOP : String = "stop";
		//目标对象
		private var _obj : DisplayObject;
		//受目标对象的补间影响的属性的名称
		private var _prop : String;		private var _prop2 : String;
		//指示当前是否正在播放补间
		private var _isPlaying : Boolean;
		//一个数字，指示要补间的目标对象属性的结束值
		private var _finish : Number;		private var _finish2 : Number;
		//播放前的目标对象属性值与结束值差
		private var vectors : Number;		private var vectors2 : Number;
		//计数
		private var currentCount : Number;
		//播放的总帧数		private var repeatCount : Number;
		
		private var _time : Number;		
		
		public function SceneMTween(obj : DisplayObject) {
			this._obj = obj;
		}
		
		private function onEnterFrame(event : Event) : void {
			_obj[_prop] += vectors / repeatCount;
			if(_prop2) {
				_obj[_prop2] += vectors2 / repeatCount;
			}
			currentCount++;
			if(currentCount >= repeatCount) {
				stop();
				_obj[_prop] = _finish;
				if(_prop2) {
					_obj[_prop2] = _finish2;
				}
				dispatchEvent(new Event(FINISH));
			}
			dispatchEvent(new Event(CHANGE));
		}
		
		public function start(time : Number,prop : String,finish : Number,prop2 : String = null,finish2 : Number = 0) : void {
			if(_isPlaying) {
				stop();
			}
			_time=time;
			_prop = prop;
			_finish = finish;
			_finish2 = finish2;
			_prop2 = prop2;
			currentCount = 0;
			vectors = _finish - _obj[_prop];
			if(_prop2) {
				vectors2 = _finish2 - _obj[_prop2];
			}
			else
			{
				_finish2=0;
			}
			
			startGo();
		}
		
		public function startGo() : void {
			if(_isPlaying) {
				stop();
			}
			repeatCount = _time / 1000 * 25 ;
			_obj.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_obj.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_isPlaying = true;
			dispatchEvent(new Event(START));
		}
		
		/**
		 * 停止播放
		 */
		public function stop() : void {			
			_obj.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_isPlaying = false;
			dispatchEvent(new Event(STOP));
		}
		
		public function dispose ():void
		{
			stop();
			_obj = null;
		}
		
		public function get isPlaying() : Boolean {
			return _isPlaying;
		}
		
		public function set time(value:Number):void
		{
			_time = value;
		}

	}
}
