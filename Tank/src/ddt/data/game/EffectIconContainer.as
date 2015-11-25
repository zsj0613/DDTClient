package ddt.data.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import road.data.DictionaryData;
	import road.data.DictionaryEvent;
	
	[Event(name="change", type="flash.events.Event")]
	public class EffectIconContainer extends Sprite
	{
		private var _data:DictionaryData;
		private var _spList:Array;
		public function EffectIconContainer()
		{
			super();
			
			initialize();
			
			initEvent();
		}
		
		private function initialize():void
		{
			if(_spList || _data)
			{
				release();
			}
			_data = new DictionaryData();
			_spList = [];
		}
		
		private function release():void
		{
			clearIcons()
			if(_data)
			{
				removeEvent();
				_data.clear();
			}
			_data = null;
			
		}
		private function clearIcons():void{
			for each(var sp:Sprite in _spList){
				removeChild(sp);
			}
			_spList = [];
		}
		private function drawIcons(iconArr:Array):void{
			for(var i:int=0;i<iconArr.length;i++){
				var icon:Sprite = _data.list[i];
				icon.x = (i&3)*21;
				icon.y = (i>>2)*21;
				_spList.push(icon);
				addChild(icon);
			}
		}
		
		private function initEvent():void
		{
			_data.addEventListener(DictionaryEvent.ADD, __changeEffectHandler);
			_data.addEventListener(DictionaryEvent.REMOVE, __changeEffectHandler);
		}
		
		private function removeEvent():void
		{
			if(_data)
			{
				_data.removeEventListener(DictionaryEvent.ADD, __changeEffectHandler);
				_data.removeEventListener(DictionaryEvent.REMOVE, __changeEffectHandler);
			}
		}
		
		private function __changeEffectHandler(e:DictionaryEvent):void
		{
			var sp:Sprite = e.data as Sprite;
			_updateList();
		}
		
		
		private function _updateList():void{
			clearIcons();
			drawIcons(_data.list)
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		 override public function get width():Number
		{
			return (_spList.length % 5)* 21;
		}
		
		override public function get height():Number
		{
			return (Math.floor(_spList.length / 5)+1) * 21;
		} 
		
		public function handleEffect(type:int, view:Sprite):void
		{
			if(view)
				_data.add(type, view);
		}
		
		public function removeEffect(type:int):void
		{
			_data.remove(type);
		}
		
		public function clearEffectIcon():void
		{
			release();
		}
		
		public function dispose():void
		{
			removeEvent();
			release();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}