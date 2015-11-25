package ddt.game.playerThumbnail
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import road.ui.manager.TipManager;
	
	import webgame.crazytank.game.view.bloodAsset;
	
	public class BloodItem extends bloodAsset
	{
		private var _width:int;
		private var _totalBlood:int;
		private var _bloodNum:int;
		
		private var _bloodInfo:TextField;
		public function BloodItem(totalBlood:int)
		{
			_width = blood.width;
			_totalBlood = totalBlood;
			_bloodNum = totalBlood;
			_bloodInfo = new TextField();
//			initEvents();
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__showBlood);
			addEventListener(MouseEvent.MOUSE_OUT,__hideBlood);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__showBlood);
			removeEventListener(MouseEvent.MOUSE_OUT,__hideBlood);
		}
		
		private function __showBlood(evt:MouseEvent):void
		{
			_bloodInfo.text = _bloodNum.toString()+"/"+_totalBlood.toString();
			TipManager.setCurrentTarget(this,_bloodInfo);
		}
		
		private function __hideBlood(evt:MouseEvent):void
		{
			TipManager.setCurrentTarget(null,_bloodInfo);
		}
		
		public function set bloodNum(value:int):void
		{
			if(value < 0)
			{
				value = 0;
			}else if(value > _totalBlood)
			{
				value = _totalBlood;
			}
			_bloodNum = value;
			updateView();
		}
		
		private function updateView():void
		{
			this.blood.width = Math.floor(_width*_bloodNum/_totalBlood);
		}
		
		public function dispose():void
		{
			removeEvents();
			if(parent) parent.removeChild(this);
		}

	}
}