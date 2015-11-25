package ddt.game
{
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.common.danderAsset;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.game.LocalPlayer;
	import ddt.data.game.Player;
	import ddt.manager.LanguageMgr;

	public class DanderStrip extends danderAsset
	{
		private var _tip:ToolStripTip;
		private var _info:LocalPlayer;
		
		public function DanderStrip()
		{
			super();
			_tip = new ToolStripTip();
			_tip.content = LanguageMgr.GetTranslation("ddt.game.DanderStrip.tip");
			initEvents();
		}
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
			removeEvents();
			_tip = null;
		}
		
		public function setInfo(info:LocalPlayer):void
		{
			_info = info;
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
			removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
		}
		
		private function __showTip(evt:MouseEvent):void
		{
			if(_info)
			{
				_tip.currentTxt.defaultTextFormat = new TextFormat("Arial",13,0xffcc00,true);
				_tip.titleTxt.defaultTextFormat = _tip.totalTxt.defaultTextFormat = new TextFormat("Arial",13,0xffffff,true);
				_tip.title = "POW: ";
				_tip.currentTxt.text = String(_info.dander/2);
				_tip.currentTxt.filters = [new GlowFilter(0xff1e00)];
				_tip.totalTxt.text = "/"+Player.TOTAL_DANDER/2;
				TipManager.setCurrentTarget(this,_tip);
			}
		}
		
		private function __hideTip(evt:MouseEvent):void
		{
			TipManager.setCurrentTarget(null,_tip);
		}
		
	
	}
}