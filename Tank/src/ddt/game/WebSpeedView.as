package ddt.game
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import game.crazyTank.view.GoodsTipBgAsset;
	
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.WebSpeedInfo;
	import ddt.events.WebSpeedEvent;
	import ddt.manager.GameManager;
	import ddt.manager.LanguageMgr;
	import ddt.utils.Helpers;
	
	import webgame.crazytank.game.view.WebSpeedAsset;
	import webgame.crazytank.game.view.WebSpeedCiteAsset;

	public class WebSpeedView extends WebSpeedAsset
	{
		private var _info:WebSpeedInfo = GameManager.Instance.Current.selfGamePlayer.webSpeedInfo;
		
		private var _cite:WebSpeedCiteAsset;
		
		private var _startTime:Number;
		
		public function WebSpeedView()
		{
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_cite = new WebSpeedCiteAsset();
			Helpers.hidePosMc(_cite);
			ComponentHelper.replaceChild(_cite,_cite.bg_pos,new GoodsTipBgAsset());
			gotoAndStop(1);
			_startTime = getTimer();
			__stateChanged(null);
		}
		
		public function dispose():void
		{
			_info.removeEventListener(WebSpeedEvent.STATE_CHANE,__stateChanged);
			removeEventListener(Event.ENTER_FRAME,__frame);
			_info = null;
			if(_cite.parent)
			{
				TipManager.RemoveTippanel(_cite);
				_cite = null;
			}
		}
		
		private function initEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,__over);
			addEventListener(MouseEvent.MOUSE_OUT,__out);
//			addEventListener(MouseEvent.MOUSE_MOVE,__move);
			_info.addEventListener(WebSpeedEvent.STATE_CHANE,__stateChanged);
			addEventListener(Event.ENTER_FRAME,__frame);
		}
		
		

		
		
		private function __over(event:MouseEvent):void
		{
			if(!_cite.parent)
			{
				_cite.x = event.stageX;
				_cite.y = event.stageY;
				TipManager.AddTippanel(_cite);
			}
		}
		
		private function __out(event:MouseEvent):void
		{
			if(_cite.parent)
			{
				TipManager.RemoveTippanel(_cite);
			}
		}
		
//		private function __move(event:MouseEvent):void
//		{
//			if(_cite.parent)
//			{
//				var pos:Point = getXY(event.stageX,event.stageY);
//				_cite.x = pos.x;
//				_cite.y = pos.y;
//			}
//		}
		
		private function __stateChanged(event:WebSpeedEvent):void
		{
			gotoAndStop(_info.stateId);
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.font = "Arial";
			if(_info.state == WebSpeedInfo.BEST)
			{
				format.color = 0x00FF33;
			}
			else if(_info.state == WebSpeedInfo.BETTER)
			{
				format.color = 0xcc9900;
			}
			else if(_info.state == WebSpeedInfo.WORST)
			{
				format.color = 0xff0000;
			}
			_cite.delay_txt.defaultTextFormat = format;
			format.bold = true;
			_cite.state_txt.defaultTextFormat = format;
			
			_cite.fps_txt.text = LanguageMgr.GetTranslation("ddt.game.WebSpeedView.frame") + _info.fps.toString();
			_cite.delay_txt.text = LanguageMgr.GetTranslation("ddt.game.WebSpeedView.delay") + _info.delay.toString();
			/* _cite.fps_txt.text = "帧数:" + _info.fps.toString();
			_cite.delay_txt.text = "延迟" + _info.delay.toString(); */
			_cite.state_txt.text = _info.state;
		}
		
		private var _count:uint = 1500;
		private function __frame(event:Event):void
		{
			var difference:Number = getTimer() - _startTime;
			_count ++ ;
			_startTime = getTimer();
			if(_count < 1500)
			{
				return;
			}
			_info.fps = int(1000 / difference);
			_count = 0;
		}
	}
}