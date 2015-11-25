package ddt.command.fightLibCommands.script
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ddt.command.fightLibCommands.BaseFightLibCommand;
	import ddt.command.fightLibCommands.IFightLibCommand;
	import ddt.events.FightLibCommandEvent;
	
	/**
	 * 
	 * @author WickiLA
	 * @time 0528/2010
	 * @description 作战实验室的脚本，在其他地方初始化命令，只有初始化完成以后才可以开始执行
	 * 				脚本会依赖于一个视图来执行，在执行的时候可能会调用视图的各种接口来完成任务，这个视图在这里叫做：寄主(_host)
	 */	

	public class BaseScript extends EventDispatcher
	{
		protected var _type:int;
		protected var _commonds:Array;
		protected var _index:int;
		protected var _initialized:Boolean;
		protected var _isPaused:Boolean;
		protected var _currentCommand:IFightLibCommand;
		protected var _host:Object;
		
		private var _hasRestarted:Boolean;
		
		public function BaseScript(host:Object)
		{
			_host = host;
			_initialized = false;
			_commonds = new Array();
			initializeScript();
		}
		
		protected function initializeScript():void
		{
			_initialized = true;
		}
		
		public function start():void
		{
			if(_initialized)
			{
				initEvents();
				_index=0;
				next();
			}else
			{
				throw new Error("在脚本初始化前调用脚本");
			}
		}
		
		public function restart():void
		{
			for each(var command:IFightLibCommand in _commonds)
			{
				command.undo();
			}
			removeEvents();
			_isPaused = false;
			_currentCommand  = null;
			start();
			_hasRestarted = true;
		}
		
		public function next():void
		{
			if(_index<_commonds.length)
			{
				_commonds[_index++].excute();
			}else
			{
				finish();
			}
			
		}
		
		private function initEvents():void
		{
			for each(var command:IFightLibCommand in _commonds)
			{
				command.addEventListener(FightLibCommandEvent.FINISH,__finishHandler);
				command.addEventListener(FightLibCommandEvent.WAIT,__waitHandler);
			}
		}
		
		private function removeEvents():void
		{
			for each(var command:IFightLibCommand in _commonds)
			{
				command.removeEventListener(Event.COMPLETE,__finishHandler);
				command.removeEventListener(Event.DEACTIVATE,__waitHandler);
			}
		}
		
		protected function __finishHandler(evt:Event):void
		{
			if(!_isPaused)
			{
				next();
			}
		}
		
		protected function __waitHandler(evt:Event):void
		{
			pause();
		}
		
		public function finish():void
		{
			_index = 0;
			removeEvents();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function pause():void
		{
			_isPaused = true;
			_currentCommand = _commonds[_index-1];
		}
		
		public function continueScript():void
		{
			_isPaused = false;
			if(_currentCommand)_currentCommand.finish();
		}
		
		public function get hasRestarted():Boolean
		{
			return _hasRestarted;
		}
		
		public function dispose():void
		{
			_host = null;
			for each(var command:BaseFightLibCommand in _commonds)
			{
				command.dispose();
			}
			_commonds = null;
			_currentCommand = null;
		}
	}
}