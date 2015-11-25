package ddt.view.common.church
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.utils.StringHelper;
	
	import tank.church.ProposeResponseAsset;
	import tank.church.lookEquipAsset;
	import ddt.manager.ChatManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PersonalInfoManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	
	/**
	 * 求婚响应 
	 * @author Administrator
	 * 
	 */	
	public class ProposeResponseFrame extends HConfirmFrame
	{
		private var spouseID:int;
		private var spouseName:String;
		private var _love:String;
		
		private var _bg:ProposeResponseAsset;
		private var _loveTxt:TextArea;
		public var answerId : int;
		
		private var _lookEquipBtn:HBaseButton;
		
		public function ProposeResponseFrame($id:int,$name:String,$answerId:int,$love:String="")
		{
			this.spouseID = $id;
			this.spouseName = $name;
			this._love = $love;
			answerId = $answerId;
			
			blackGound = false;
			alphaGound = false;
			moveEnable = true;
			fireEvent = false;
			showBottom = true;
			showClose = true;
			buttonGape = 100;
			setContentSize(415,370);
			
			cancelFunction =__cancel;
			okFunction =__confirm ;
			
			okLabel = LanguageMgr.GetTranslation("accept");
			cancelLabel = LanguageMgr.GetTranslation("refuse");
			
			centerTitle = true;
			titleText = LanguageMgr.GetTranslation("ddt.view.common.church.ProposeResponseFrame.titleText");
			
			init();
		}
		
		private function init():void
		{
			_bg = new ProposeResponseAsset();
			
			var txt:TextField = new TextField()
			txt.text = "TEst test"
			txt.width = txt.textWidth;
			
			_bg.name_txt.text = spouseName + "，向你求婚！";
//			_bg.name_txt.autoSize("left")
				
			_bg.name_txt.width = _bg.name_txt.textWidth + 10
			_bg.name_txt.y += 2
				
			_bg.name_txt.setTextFormat(new TextFormat(LanguageMgr.GetTranslation("songti"),16,0xFF0034,true));
				
			_bg.name_txt.filters = [new GlowFilter(0xffffff,1,4,4,10)];
			addContent(_bg,true);
			
			_lookEquipBtn = new HBaseButton(new lookEquipAsset());
			_lookEquipBtn.x = _bg.lookBtn.x;
			_lookEquipBtn.y = _bg.lookBtn.y;
			_bg.lookBtn.visible = false;
			_bg.addChild(_lookEquipBtn);
			_lookEquipBtn.addEventListener(MouseEvent.CLICK,__lookEquip);
			
			_loveTxt = new TextArea();
			_loveTxt.editable = false;
			_loveTxt.maxChars = 300;
			_loveTxt.setStyle("upSkin",new Sprite());
			_loveTxt.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0x013465;
			format.leading = 4;
			_loveTxt.setStyle("disabledTextFormat",format);
			_loveTxt.setStyle("textFormat",format);
			_loveTxt.setSize(_bg.txt_pos.width,_bg.txt_pos.height);
			_loveTxt.textField.defaultTextFormat = new TextFormat("Arial",14,0x013465);
			_loveTxt.x = _bg.txt_pos.x;
			_loveTxt.y = _bg.txt_pos.y;
			_loveTxt.text = _love;
			_bg.addChild(_loveTxt);
			
			_bg.txt_pos.visible = false;
		}
		
		private function __lookEquip(evt:MouseEvent):void
		{
			SoundManager.instance.play("008");
			PersonalInfoManager.instance.addPersonalInfo(spouseID,PlayerManager.Instance.Self.ZoneID);
		}
		
		private function __confirm():void
		{
			SocketManager.Instance.out.sendProposeRespose(true,spouseID,answerId);
			super.hide();
		}
		
		private function __cancel():void
		{
			SocketManager.Instance.out.sendProposeRespose(false,spouseID,answerId);
			var msg:String = StringHelper.rePlaceHtmlTextField(LanguageMgr.GetTranslation("ddt.view.common.church.ProposeResponseFrame.msg",spouseName));
			ChatManager.Instance.sysChatRed(msg);
			super.hide();
		}
		
		override protected function __closeClick(e:MouseEvent):void
		{
			__cancel();
			SoundManager.instance.play("008");
		}
	}
}