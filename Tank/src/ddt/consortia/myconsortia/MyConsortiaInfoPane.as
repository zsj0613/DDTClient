package ddt.consortia.myconsortia
{
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.HComboBox;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	import road.utils.StringHelper;
	
	import tank.consortia.accect.MyConsortiaInfoAsset;
	import ddt.data.ConsortiaDutyType;
	import ddt.data.ConsortiaInfo;
	import ddt.data.ConsortiaLevelInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.ConsortiaDutyManager;
	import ddt.manager.ConsortiaLevelUpManager;
	import ddt.manager.FilterWordManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.view.common.RoomIIPropTip;

//	import ddt.consortia.data.ConsortiaData;

	public class MyConsortiaInfoPane extends MyConsortiaInfoAsset
	{
		private var _info :ConsortiaInfo;
		private var _text:TextArea;
		private var _textVisible:Boolean = true;
		private var _editBut:HLabelButton;
		private var _cancelBtn:HLabelButton;
		private var _canEdit:Boolean;
		private var _lastText:String = "";
		
//		private var keepPayTip:RoomIIPropTip;
		public function MyConsortiaInfoPane()
		{
			super();
			init();
			addEvent();
		}
		private function init() : void
		{
			/* 公告栏 bret 09.6.2 */
			_text = new TextArea();
			_text.textField.text = "";
			_text.setStyle("upSkin",new Sprite());
//			_text.setStyle("disabledSkin",new Sprite());
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 16;
			format.color = 0x013465;
			format.leading = 4;
//			_text.setStyle("disabledTextFormat",format);
			_text.setStyle("textFormat",format);
			_text.setSize(237,200);
//			_text.textField.selectable = false;
//			_text.textField.mouseEnabled = false;
			_canEdit = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._4_Notice);
			_text.editable = _canEdit;
			
			var filterA:Array = [];
			var glowFilter:GlowFilter = new GlowFilter(0xffffff,1,4,4,10);
			filterA.push(glowFilter);
			_text.textField.filters = filterA;
			addChild(_text);
			_text.x = consortiaAfficheTxt.x;
			_text.y = consortiaAfficheTxt.y;
			
			
			_editBut = new HLabelButton();
			_editBut.label = LanguageMgr.GetTranslation("ok");
			this.addChild(_editBut);
			_editBut.x = consortiaAfficheTxt.x + consortiaAfficheTxt.width/4 - _editBut.width/2;
			_editBut.y = consortiaAfficheTxt.y + consortiaAfficheTxt.height - _editBut.height + 8;
			
			
			_cancelBtn = new HLabelButton();
			_cancelBtn.label = LanguageMgr.GetTranslation("cancel");
			this.addChild(_cancelBtn);
			_cancelBtn.x = consortiaAfficheTxt.x + consortiaAfficheTxt.width/4 * 3 - _editBut.width/2 - 20;
			_cancelBtn.y = _editBut.y;
			_cancelBtn.enable = _editBut.enable = false;
			
			_cancelBtn.visible = _editBut.visible = _canEdit;
			/* ************************************************************ */
			setTextField(name_txt);
			setTextField(charmanName_txt);
			setTextField(count_txt);
			setTextField(fortune_txt);
			setTextField(honor_txt);
//			setTextField(keepPay_txt);
			keepPay_txt.selectable=false;
			level_mc.gotoAndStop(1);
			//setTextField(level_txt);
			setTextField(repute_txt);
			
			
//			setTextField(myConsortiaLevelTxt);
			setTextField(consortiaShopLevelTxt);
			setTextField(consortiaSmithLevelTxt);
			setTextField(consortiaStoreLevelTxt);
//			setTextField(_text.textField);
		}
		private function setTextField(txt : TextField) : void
		{
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.text = "";
		}
		private function addEvent() : void
		{
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __onCharManNameChange);
			
			keepPay_txt.addEventListener(MouseEvent.MOUSE_OVER,keepPayOverListener);
			keepPay_txt.addEventListener(MouseEvent.MOUSE_OUT,keepPayOutListener);
			
			_text.textField.addEventListener(MouseEvent.CLICK, __clear);
			_text.textField.addEventListener(Event.CHANGE,__input);
			_text.textField.addEventListener(TextEvent.TEXT_INPUT,__limit);
			_editBut.addEventListener(MouseEvent.CLICK, __sendUpDataDisplayBord);
			_cancelBtn.addEventListener(MouseEvent.CLICK, __cancelEdit);
		}
		
		private function __cancelEdit(e:MouseEvent):void {
			SoundManager.Instance.play("008");
			_text.text = dealPlacard(_lastText);
			_cancelBtn.enable = _editBut.enable = false;
		}
		
		private function __clear(e:MouseEvent):void {
			_text.text = _text.text == LanguageMgr.GetTranslation("ddt.consortia.myconsortia.systemWord") ? "" : _text.text;
		}
		private function __input(e:Event):void
		{
			_editBut.enable = _cancelBtn.enable = true;
		}
		private function __limit(e:TextEvent):void
		{
			//			SoundManager.instance.play("043");
			StringHelper.checkTextFieldLength(_text.textField,200);			
		}
		
		private function __sendUpDataDisplayBord(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			var b:ByteArray = new ByteArray();
			b.writeUTF(StringHelper.trim(_text.textField.text));
			if(b.length >300)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaAfficheFrame.long"));
				//MessageTipManager.getInstance().show("当前输入文本过长");
				return;
			}
			if(FilterWordManager.isGotForbiddenWords(_text.text))
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
				return;
			}
			var str : String = FilterWordManager.filterWrod(_text.text);
			str = StringHelper.trim(str);
			
			SocketManager.Instance.out.sendConsortiaUpdatePlacard(str);
			_editBut.enable = _cancelBtn.enable = false;
		}
		
		
		/* 维持费tip */
		private var keepPayTip:RoomIIPropTip;
		
		private function keepPayOverListener(event:MouseEvent):void{
			var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
			
			itemTemplateInfo.Name = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaInfoPane.week");
			//itemTemplateInfo.Name = "每周将从公会财富中扣除";

			itemTemplateInfo.Property4 = "";
			if(_info)
			{
				itemTemplateInfo.Description = StringHelper.parseTime(_info.DeductDate,7);
			}
			var format:TextFormat
			keepPayTip = new RoomIIPropTip(false,false,true);
			keepPayTip.description_txt.y = keepPayTip.gold_txt.y = keepPayTip.thew_txt.y;
			
			
			keepPayTip.update(itemTemplateInfo,1);
			keepPayTip.thew_txt.text = LanguageMgr.GetTranslation("ddt.consortia.myconsortia.MyConsortiaInfoPane.time");
			format=keepPayTip.thew_txt.getTextFormat();
			format.size = 14;
			keepPayTip.thew_txt.setTextFormat(format);
			//keepPayTip.thew_txt.text = "下次扣除时间：";
			keepPayTip.description_txt.x = keepPayTip.thew_txt.x+keepPayTip.thew_txt.width-25;
			
			format=keepPayTip.description_txt.getTextFormat();
			format.size = 14;
			keepPayTip.description_txt.setTextFormat(format);
		
			var keepPay_pos:Point = this.localToGlobal(new Point(keepPay_txt.x,keepPay_txt.y));
			keepPayTip.x = keepPay_pos.x - 70;
			keepPayTip.y = keepPay_pos.y + keepPay_txt.height;
			TipManager.AddTippanel(keepPayTip);
		}
		private function keepPayOutListener(event:MouseEvent):void{
			if(keepPayTip && keepPayTip.parent)TipManager.RemoveTippanel(keepPayTip);
		}
		
		public function get info() : ConsortiaInfo
		{
			return this._info;
		}
		public function set info(i : ConsortiaInfo) : void
		{
			
			this._info = i;
			upView();
		}
		private function __placardChange(evt : Event) : void
		{
			_text.text = dealPlacard(_info.Placard);
			_lastText = _info.Placard;
		}
		private function __onCharManNameChange(evt : PlayerPropertyEvent):void
		{
			if(evt.changedProperties["CharManName"])
			{
				this.charmanName_txt.text = _info.ChairmanName = String(PlayerManager.Instance.Self.CharManName);
			}
			if(evt.changedProperties["Right"])
			{
				_canEdit = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._4_Notice);
				_cancelBtn.visible = _editBut.visible = _text.editable = _canEdit;
			}
			else if(evt.changedProperties["ConsortiaLevel"])
			{
				/*if(_info)_info.Level = int(evt.changedProperties["ConsortiaLevel"]);
				this.level_txt.text = String(evt.changedProperties["ConsortiaLevel"]);*/
				//this.level_txt.text = String(PlayerManager.Instance.Self.ConsortiaLevel);
				level_mc.gotoAndStop(PlayerManager.Instance.Self.ConsortiaLevel);
			}
		}
	
		private function upView() : void
		{
			var fee:ConsortiaLevelInfo = ConsortiaLevelUpManager.Instance.getLevelData(_info.Level);
			
			this.name_txt.text        = _info.ConsortiaName;
			this.charmanName_txt.text = _info.ChairmanName;
			this.count_txt.text       = String(_info.Count);
			this.fortune_txt.text     = String(_info.Riches);
			this.honor_txt.text       = String(_info.Honor);
			this.keepPay_txt.text     = String(fee.Deduct) + LanguageMgr.GetTranslation("ddt.consortia.myconsortia.frame.MyConsortiaInfoPanel.week");
			//this.level_txt.text       = String(_info.Level);
			level_mc.gotoAndStop(_info.Level);
			this.repute_txt.text      = String(_info.Repute);
			if(_textVisible){
				_text.text                = dealPlacard(_info.Placard);
				_lastText = info.Placard;
			}
			
//			myConsortiaLevelTxt.text    = "Lv." + String(_info.Level);
			consortiaShopLevelTxt.text  = "Lv." + String(_info.ShopLevel);
			consortiaSmithLevelTxt.text = "Lv." + String(_info.SmithLevel);
			consortiaStoreLevelTxt.text = "Lv." + String(_info.StoreLevel);
//			_text.text                = _info.Placard;
		}
		/*更新公告*/
		public function upMyConsortiaPlacard(msg : String) : void
		{
			_info.Placard = msg;
			_text.text = dealPlacard(msg);
			_lastText = msg;
		}
		/*是否显示公告*/
		public function set clearPlacard(b : Boolean) : void
		{ 
			_textVisible = !b;
			
			if(b)
			{	
				_text.text = "";
				_editBut.visible = false;
				_cancelBtn.visible = false;
				_text.editable = false;
			}
			else if(_info) {
				_text.text = dealPlacard(_info.Placard);
				_editBut.visible = _cancelBtn.visible = _canEdit;
				_editBut.enable = _cancelBtn.enable = false;
				_text.editable = _canEdit;
			}
			else {
				_text.text = "";
				_editBut.visible = false;
				_cancelBtn.visible = false;
				_text.editable = false;
			}
		}
		public function set count(i : int) : void
		{
			if(!_info)return;
			 _info.Count = i;
			 this.count_txt.text       = String(i);
		}
		private function removeEvent() : void
		{
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __onCharManNameChange);
			
			keepPay_txt.removeEventListener(MouseEvent.MOUSE_OVER,keepPayOverListener);
			keepPay_txt.removeEventListener(MouseEvent.MOUSE_OUT,keepPayOutListener);
			_text.textField.removeEventListener(MouseEvent.CLICK, __clear);
			_text.textField.removeEventListener(Event.CHANGE,__input);
			_text.textField.removeEventListener(TextEvent.TEXT_INPUT,__limit);
			_editBut.removeEventListener(MouseEvent.CLICK, __sendUpDataDisplayBord);
			_cancelBtn.removeEventListener(MouseEvent.CLICK, __cancelEdit);
		}
		public function dispose() : void
		{
			removeEvent();
			if(this.parent)this.parent.removeChild(this);
		}
		
		private function dealPlacard(value:String):String {
			if(_canEdit)
				return value == "" ? LanguageMgr.GetTranslation("ddt.consortia.myconsortia.systemWord") : value;
			else 
				return value;
		}
	}
}