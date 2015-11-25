package ddt.view
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	public class SimpleSelectableButton extends Sprite
	{
		private var _selected:Boolean;
		
		private var _normalState:DisplayObject;
		
		private var _selectedState:DisplayObject;
		
		private var _asset:SimpleButton;
		
		public function SimpleSelectableButton(asset:SimpleButton,selectedState:DisplayObject = null)
		{
			super();
			_asset = asset;
			_normalState = asset.upState;
			_selectedState = selectedState == null ? asset.downState : selectedState;
			addChild(_asset);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				updateState();
			}
		}
		
		public function get enable():Boolean
		{
			return _asset.enabled;
		}
		
		public function set enable(value:Boolean):void
		{
			_asset.enabled = value;
		}
		
		protected function updateState():void
		{
			if(_selected)
			{
				_asset.upState = _selectedState;
			}
			else
			{
				_asset.upState = _normalState;
			}
		}
		
	}
}