package ddt.game
{
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.bloodStripAsset;
	import game.crazyTank.view.common.toolStripTipAsset;
	
	import road.ui.manager.TipManager;
	
	import ddt.data.Config;
	import ddt.manager.LanguageMgr;

	public class BloodStrip extends bloodStripAsset
	{
		private var _tip:toolStripTipAsset;
		
		public function BloodStrip()
		{
			_tip = new ToolStripTip();
			_tip.content = LanguageMgr.GetTranslation("ddt.game.BloodStrip.tip");
			_tip.bg.height -= 30;
			_tip.title = "";
			
			maskMc.addEventListener(MouseEvent.MOUSE_OVER,__showTip);
			maskMc.addEventListener(MouseEvent.MOUSE_OUT,__hideTip);
			this.bloodText.mouseEnabled = false;
		}
		public function dispose():void
		{
    		maskMc.removeEventListener(MouseEvent.MOUSE_OVER,__showTip);
			maskMc.removeEventListener(MouseEvent.MOUSE_OUT,__hideTip);
    		if(_tip && _tip.parent)
    		{
    			removeChild(_tip);
    		}
    		_tip = null;
    		if(parent) parent.removeChild(this);
		}
		
		private var _blood:int;
		private var _maxBlood:int;
		public function update(blood:int,maxBlood:int):void
		{
			if(blood<0){
				blood = 0;
			}
			_blood = blood;
			_maxBlood = maxBlood;
			
			if(_blood >= _maxBlood)
			{
				bloodMaskMc.gotoAndStop(1);
			}
			else if(_blood <=0 )
			{
				bloodMaskMc.gotoAndStop(100);
			}
			else
			{
				bloodMaskMc.gotoAndStop(100 - int( 100 * _blood / _maxBlood));
			}
			
			bloodText.text = _blood >=0 ? String(_blood) : "0";
		}
		
		private function __showTip(evt:MouseEvent):void
		{
			_tip.currentTxt.defaultTextFormat = new TextFormat("Arial",13,0xff0000,true);
			_tip.currentTxt.filters = [new GlowFilter(0xffffff,1,2,2,10)];
			_tip.titleTxt.defaultTextFormat = _tip.totalTxt.defaultTextFormat = new TextFormat("Arial",13,0xffffff,true);
			_tip.title = LanguageMgr.GetTranslation("ddt.game.BloodStrip.HP")+":";
			_tip.currentTxt.text = String(_blood);
			_tip.totalTxt.text = "/" + String(_maxBlood);
			_tip.x = Config.GAME_WIDTH - 60 - _tip.width;
			_tip.y = Config.GAME_HEIGHT - 90 - _tip.height;
			TipManager.AddTippanel(_tip);
		}
		
		private function __hideTip(evt:MouseEvent):void
		{
			TipManager.RemoveTippanel(_tip);
		}
	}
}