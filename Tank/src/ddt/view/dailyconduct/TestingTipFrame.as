package ddt.view.dailyconduct
{
	import com.dailyconduct.view.TestingTipAsset;
	
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.TipManager;

	public class TestingTipFrame extends HConfirmFrame
	{
		public static var str:String = "Test";
		private var _tip : TestingTipAsset;
		public function TestingTipFrame()
		{
			super();
			init();
		}
		private function init() : void
		{
			blackGound = false;
			alphaGound = false;
			mouseEnabled = false;
			fireEvent = false;
			showCancel = false;
			moveEnable = false;
			setSize(480,250);
			titleText = "提示";		
			
			_tip = new TestingTipAsset();
			_tip.Text_txt.text = str;
			this.addContent(_tip);
			//global.traceStr(str);
			this.closeCallBack = dispose;	
			this.okFunction    = dispose;
		}
		
		override public function dispose():void
		{
			if(_tip && _tip.parent)_tip.parent.removeChild(_tip);
			_tip = null;
			super.dispose();
		}
		
		override public function show():void
		{
			TipManager.AddTippanel(this,true);
			blackGound = true;
		}
	}
}