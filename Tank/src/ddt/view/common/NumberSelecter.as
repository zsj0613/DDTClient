package ddt.view.common
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import tank.view.common.NumberSelecterAsset;
	
	
	/**
	 * @author wickila
	 * @time 0401/2010
	 * @description 数量选择器
	 * */
	
	public class NumberSelecter extends NumberSelecterAsset
	{
		private var _minNum:int;
		private var _maxNum:int;
		private var _num:int;
		private var _reduceBtn:HBaseButton;
		private var _addBtn:HBaseButton;
		
		public function NumberSelecter(min:int=1,max:int=99)
		{
			super();
			_minNum = min;
			_maxNum = max;
			init();
			initEvents();
		}
		
		private function init():void
		{
			_reduceBtn = new HBaseButton(reduceBtnAsset);
			_reduceBtn.useBackgoundPos = true;
			addChild(_reduceBtn);
			
			_addBtn = new HBaseButton(addBtnAsset);
			_addBtn.useBackgoundPos = true;
			addChild(_addBtn);
			
			_num = 1;
			updateView();
		}
		
		private function initEvents():void
		{
			_reduceBtn.addEventListener(MouseEvent.CLICK,reduceBtnClickHandler);
			_addBtn.addEventListener(MouseEvent.CLICK,addBtnClickHandler);
			numText.addEventListener(MouseEvent.CLICK,clickHandler);
			numText.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			numText.addEventListener(Event.CHANGE,changeHandler);
		}
		
		private function removeEvents():void
		{
			_reduceBtn.removeEventListener(MouseEvent.CLICK,reduceBtnClickHandler);
			_addBtn.removeEventListener(MouseEvent.CLICK,addBtnClickHandler);
			numText.removeEventListener(MouseEvent.CLICK,clickHandler);
			numText.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			numText.removeEventListener(Event.CHANGE,changeHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
		private function changeHandler(evt:Event):void
		{
			number = int(numText.text);
		}
		
		private function onKeyDown(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
			if(evt.keyCode == Keyboard.ENTER)
			{
				number = int(numText.text)
			}
		}
		
		private function reduceBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			number -= 1;
		}
		
		private function addBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			number += 1;
		}
		
		public function set number(value:int):void
		{
			if(value < _minNum)
			{
				value = _minNum;
			}else if(value > _maxNum)
			{
				value = _maxNum;
			}
			_num = value;
			updateView();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get number():int
		{
			return _num;
		}
		
		private function updateView():void
		{
			numText.text = _num.toString();
			_reduceBtn.enable = (_num > _minNum);
			_addBtn.enable = (_num < _maxNum);
		}
		
		public function dispose():void
		{
			removeEvents();
			_reduceBtn.dispose();
			_reduceBtn = null;
			_addBtn.dispose();
			_addBtn = null;
			if(parent) parent.removeChild(this);
		}

	}
}