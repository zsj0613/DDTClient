package ddt.view.common.church
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.AgreeProposeAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.StateManager;
	import ddt.states.StateType;

	public class DialogueAgreePropose extends HConfirmFrame
	{
		private var _asset:AgreeProposeAsset;
		public var isShowed:Boolean = true;
		
		public function DialogueAgreePropose()
		{
			super();
			blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = true;

			okFunction = __okClick;
			okLabel = LanguageMgr.GetTranslation("ddt.view.common.church.DialogueAgreePropose.okLabel");
			//okLabel = "举行婚礼";
			cancelFunction = __cancelClick;
			cancelLabel = LanguageMgr.GetTranslation("ddt.view.common.church.DialogueAgreePropose.cancelLabel");
			//cancelLabel = "以后举行";
			
			buttonGape = 120; 
			setContentSize(435,194);
			configUI();
		}
		private function configUI():void
		{
			addEventListener(Event.CLOSE,__close);
			
			_asset = new AgreeProposeAsset();
			addContent(_asset);
		}
		
		public function set info(value:String):void
		{	
			_asset.name_txt.setTextFormat(new TextFormat(LanguageMgr.GetTranslation("songti"),16,0xff0034,true));
			_asset.name_txt.text = value;
			_asset.name_txt.filters = [new GlowFilter(0xffffff,1,4,4,10)];
			
			_asset.name_txt.width = _asset.name_txt.textWidth + 8
			var nameWidth:Number = _asset.name_txt.width

			_asset.rightTxt.width = _asset.rightTxt.textWidth +10
			var rightTxtWidth:Number = _asset.rightTxt.width
			
			var totalWidth:Number = nameWidth + rightTxtWidth
			
			_asset.name_txt.x = _asset.bottomTxt.x - totalWidth/2 + 4
			_asset.rightTxt.x = _asset.name_txt.x + _asset.name_txt.width
			isShowed = false;
		}
		
		override public function show():void
		{
			super.show();
			SoundManager.instance.play("018");
//			UIManager.setChildCenter(this);
//			TipManager.AddTippanel(this);
			isShowed = true;
		}
		
		private function __okClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			StateManager.setState(StateType.CHURCH_ROOMLIST);
			hide();
		}
		
		private function __close(evt:Event):void
		{
			SoundManager.instance.play("008");
			hide();
		}
		
		private function __cancelClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			hide();
		}
		
//		private function hide():void
//		{
//			if(parent)parent.removeChild(this);
//		}

		override public function dispose():void
		{
			super.dispose();
			if(parent)parent.removeChild(this);
		}
		
		private static var _instance:DialogueAgreePropose;
		public static function get Instance():DialogueAgreePropose
		{
			if(_instance == null)
			{
				_instance = new DialogueAgreePropose();
			}
			return _instance
		}
	}
}