package ddt.game.playerThumbnail
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.ui.manager.TipManager;
	
	import webgame.crazytank.game.view.BossBloodAsset;
	
	//大怪的血条
	public class BossBloodItem extends BossBloodAsset
	{
		private var _width:int;
		private var _totalBlood:int;
		private var _bloodNum:int;
		private var _maskShape : Shape;
		private var _bloodInfo:TextField;
		public function BossBloodItem(totalBlood:int)
		{
			_width = this.width;
			_totalBlood = totalBlood;
			_bloodNum = totalBlood;
			_bloodInfo = new TextField();
//			bloodBg.mask = blood;
//			this.addChild(blood);
			blood.visible = false;
			_maskShape = new Shape();
			_maskShape.x = 13;
			_maskShape.y = 7;
			_maskShape.graphics.beginFill(0,1);
			_maskShape.graphics.drawRect(0,0,120,25);
			_maskShape.graphics.endFill();
			bloodBg.mask = _maskShape;
			addChild(_maskShape);
			var tempFormat:TextFormat = rate_txt.defaultTextFormat;
			tempFormat.bold = true;
			rate_txt.defaultTextFormat = tempFormat;
			rate_txt.selectable = false;
			rate_txt.mouseEnabled = false;
			rate_txt.text = "100%"
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
		
		public function set bloodNum(vlaue:int):void
		{
			_bloodNum = vlaue;
			updateView();
		}
		
		private function updateView():void
		{
//			this.blood.width = _width*(_bloodNum/_totalBlood);
			_bloodNum = _bloodNum > _totalBlood ? _totalBlood : _bloodNum;
			var rate : int =  getRate(_bloodNum,_totalBlood);//  int((_bloodNum/_totalBlood)*100);
			rate_txt.text = rate.toString() +"%"
			_maskShape.width = 120*(rate/100);
			bloodBg.mask = _maskShape;
		}
		
		private function getRate(value1 : int ,value2 : int) : int
		{
			var rate : Number = (value1 / value2) * 100;
			if(rate > 0 && rate < 1)rate = 1;
			return int(rate);
		}
		
		public function dispose():void
		{
			removeEvents();
			if(parent) parent.removeChild(this);
		}

	}
}