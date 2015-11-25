package ddt.view.common
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import road.ui.controls.HButton.HBaseButton;
	/**
	 * 
	 * @author WickiLA
	 * @time 0607/2010
	 * @description 可以闪的，具有选择状态的HBaseButton，像选择作战实验室打法的那种按钮
	 */	
	public class HSelectableShineButton extends HBaseButton
	{
		private var _selectedShineBg:MovieClip;
		private var _selected:Boolean;
		
		public function HSelectableShineButton($bg:DisplayObject,selectedShineBg:MovieClip)
		{
			super($bg);
			_selectedShineBg = selectedShineBg;
			_selectedShineBg.mouseChildren = _selectedShineBg.mouseEnabled = false;
			addChild(_selectedShineBg);
			selected = false;
			updateView();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			updateView();
		}
		
		public function startShine():void
		{
			_selectedShineBg.visible = true;
			_selectedShineBg.play();
		}
		
		public function stopShine():void
		{
			_selectedShineBg.visible = false;
			_selectedShineBg.stop();
			updateView();
		}
		
		private function updateView():void
		{
			_selectedShineBg.gotoAndStop(1);
			if(_selected)
			{
				_selectedShineBg.visible = true;
			}else
			{
				_selectedShineBg.visible = false;
			}
		}
		
		override public function dispose():void
		{
			_selectedShineBg.stop();
			removeChild(_selectedShineBg);
			super.dispose();
		}

	}
}