package road.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name = "add",type = "DictionaryEvent")]
	[Event(name = "update",type = "DictionaryEvent")]
	[Event(name = "remove",type = "DictionaryEvent")]
	[Event(name = "clear",type = "DictionaryEvent")]
	public dynamic class DictionaryData extends Dictionary implements IEventDispatcher
	{
		private var _dispatcher:EventDispatcher;
		private var _array:Array;
		
		public function DictionaryData(weakKeys:Boolean=false)
		{
			super(weakKeys);
			_dispatcher = new EventDispatcher(this);
			_array = [];
		}
		
		public function get length():int
		{
			return _array.length;
		}
		
		public function get list():Array
		{
			return _array;
		}
		
		private var _fName:String;
		private var _value:Object;
		public function filter(field:String,value:Object):Array
		{
			_fName = field;
			_value = value;
			return _array.filter(filterCallBack);
		}
		private function filterCallBack(item:*,index:int, array:Array):Boolean
		{
			return item[_fName] == _value;
		}
		
		public function add(key:*,value:Object):void
		{
			if(this[key] == null)
			{
				this[key] = value;
				_array.push(value);
				dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD,value));
			}
			else
			{
				var old:Object = this[key];
				this[key] = value;
				var t:int = _array.indexOf(old);
				if(t > -1)_array.splice(t,1);
				_array.push(value);
				dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE,value));
			}
		}
		
		public function remove(key:*):void
		{
			var obj:Object = this[key];
			if(obj != null)
			{
				this[key] = null;
				delete this[key];
				var t:int = _array.indexOf(obj);
				if(t > -1)_array.splice(t,1);
				dispatchEvent(new DictionaryEvent(DictionaryEvent.REMOVE,obj));
			}
		}
		
		public function setData(dic:DictionaryData):void
		{
			cleardata();
			for(var i:String in dic)
			{
				this[i] = dic[i];
				_array.push(dic[i]);
			}
		}
		
		public function clear():void
		{
			cleardata();
			dispatchEvent(new DictionaryEvent(DictionaryEvent.CLEAR));
		}
		
		public function slice(startIndex:int = 0,endIndex:int = 166777215):Array
		{
			return _array.slice(startIndex,endIndex);
		}
		
		public function concat(arr:Array):Array
		{
			return _array.concat(arr);
		}
		
		private function cleardata():void
		{
			var temp:Array = []
			for(var i:String in this)
			{
				temp.push(i);
			}
			for each(var s:String in temp)
			{
				delete this[s];
			}
			_array = [];
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type,listener,useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
	}
}