package ddt.view.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ddt.manager.LanguageMgr;

	public class FPSView extends Sprite
	{
		private var _last:int;
		private var _fps:int;
		private var _txt:TextField;
		
		public function FPSView()
		{
			_txt = new TextField();
			_txt.textColor = 0xFFFFFF;
			_txt.filters = [new GlowFilter(0x000000,1,2,2,10)];
			_txt.multiline = true;
			_txt.height = 60;
			_txt.mouseEnabled = false;
			_txt.selectable = false;
			
			_last = getTimer();
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function updateTxt():void
		{
		   
			_txt.text = LanguageMgr.GetTranslation("ddt.view.common.FPSView.biaozhun");
			_txt.appendText( LanguageMgr.GetTranslation("ddt.view.common.FPSView.dangqian",_fps));
			_txt.appendText( LanguageMgr.GetTranslation("ddt.view.common.FPSView.xingneng"));

		}
		
		private function __enterFrame(evt:Event):void
		{
			_fps = int(1000/(getTimer() - _last));
			_last = getTimer();
		}
		
		private static var _instance:FPSView;
		
		public static function get instance():FPSView
		{
			if(_instance == null)
			{
				_instance = new FPSView();
			}
			return _instance;
		}
	}
}