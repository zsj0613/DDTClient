package ddt.view.emailII
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import game.crazyTank.view.emailII.ReadingEmailAsset;
	import game.crazyTank.view.emailII.useHelpAsset;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.utils.ComponentHelper;
	
	import ddt.data.EmailInfo;
	import ddt.data.EmailInfoOfSended;
	import ddt.data.EquipType;
	import ddt.data.player.PlayerInfo;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.MailManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.TimeManager;
	import ddt.view.HelpFrame;
	import ddt.view.bagII.baglocked.BagLockedGetFrame;
	import ddt.view.characterII.CharactoryFactory;
	import ddt.view.characterII.ICharacter;
	import ddt.view.characterII.ShowCharacter;
	import ddt.view.common.LevelIcon;

	internal class ReadingView extends BaseEmailRightView
	{
		private var _asset:ReadingEmailAsset;
		
		private var _info:EmailInfo;
		private var minfo:PlayerInfo;
		private var _playerview:ShowCharacter;
		private var _levelIcon:LevelIcon;
		
		private var _reBack_btn : HLabelButton;
		private var _reply_btn  : HLabelButton;
		private var _close_btn  : HLabelButton;
		private var _write_btn  : HLabelButton;
		private var _lPage_btn  : HBaseButton;
		private var _rPage_btn  : HBaseButton;
		private var _help_btn   : HBaseButton;
		
		private var allMail_btn:MovieClip;
		private var noReadMail_btn:MovieClip;
		private var sendedMail_btn:MovieClip;
		private var showImage:DisplayObject;
		
		public function set info(value:EmailInfo):void
		{
			_info = value;
			if(_info is EmailInfoOfSended)
			{
				updateSended();
				return;
			} 
			update();
		}
		/**
		 * 设置只读状态 
		 * @param value
		 * 
		 */		
		public function set readOnly(value:Boolean):void
		{
			for(var i:uint = 0;i<5;i++)
			{
				(_diamonds[i] as DiamondOfReading).readOnly = value;
				(_diamonds[i] as DiamondOfReading).visible = !value;
			}
		}
		
		private var _diamonds:Array;
		
		private  var _list:EmailIIListView;
		
		/**
		 * 是否能回复及退信
		 */	
		internal function set isCanReply(value:Boolean):void
		{
			if(_info is EmailInfoOfSended)
			{
				return;
			}
			_reply_btn.enable = value;
			if(_info){
				if(_info.Type >100 && _info.Money > 0)
				{
					_reBack_btn.enable = true;
				}else{
					_reBack_btn.enable = false;
				}
			}else{
				_reBack_btn.enable = false;
			}
		}
		/**
		 * 切换按钮的可视状态
		 */		
		public function switchBtnsVisible(value:Boolean):void
		{
			_asset.selectAll_btn.visible = value;
			_asset.deleteSelect_btn.visible = value;
			_asset.receiveEx_btn.visible = value;
			
			if(value)
			{
				_asset.senderType.gotoAndStop(1);
			}else
			{
				
				_asset.senderType.gotoAndStop(2);
			}
		}
		
		public function ReadingView()
		{
			super();
			_asset.page_mc.page_txt.text = "1/1";
			closeCallBack = closeWin;
		}
		
		private function update():void
		{
			
			if(_info&&(_info.Type ==0 || _info.Type ==1 || _info.Type == 10 || _info.Type > 100))
			{
				_asset.comman_mc.visible = true;
			}else
			{
				_asset.comman_mc.visible = false;
			}
			
			_sender.text = _info ? _info.Sender : "";
			_topic.text = _info ?_info.Title : "";
			_ta.text = _info ? _info.Content : "";
//			trace(_ta.getLineMetrics(2).width);
			
			clearPersonalImage();
			
			if(_info) {
				prepareShow();
			}
			
			for each(var diamond:DiamondOfReading in _diamonds)
			{
				diamond.info = _info;
			}
			
			_list.updateInfo(_info);
			
		}
		
		private function clearPersonalImage():void {
			if(_playerview) {
//				showImage.parent.removeChild(showImage);
				_playerview.dispose();
				_playerview = null;
			}
			if(_levelIcon) {
				_levelIcon.dispose();
				_levelIcon = null;
			}
		}

		
		private function prepareShow():void {
			minfo = PlayerManager.Instance.findPlayer(_info.UserID,PlayerManager.Instance.Self.ZoneID);
			if(_info.Money > 0 && _info.UserID != PlayerManager.Instance.Self.ID && _info.UserID != 0) {
				_asset.personal_mc.visible = true;
				if(!PlayerManager.Instance.hasInFriendList(_info.UserID) && !PlayerManager.Instance.hasInClubPlays(_info.UserID)) {
					SocketManager.Instance.out.sendItemEquip(_info.UserID);
					minfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,showPersonal);
					return;
				}
				showBegain();
			}
			else {
				personalHide();
			}
		}
		
		private function showPersonal(e:PlayerPropertyEvent):void {
			minfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,showPersonal);
			showBegain();
		}
		
		private function showBegain():void {
			minfo.WeaponID = int(minfo.Style.split(",")[EquipType.ARM - 1]);
			_playerview = CharactoryFactory.createCharacter(minfo) as ShowCharacter;
			_playerview.show(true,-1);
			_playerview.setShowLight(true,null);
			_playerview.showGun = true;
			
			_playerview.stopAnimation();
			showComplete(null);
//			_playerview.addEventListener(Event.COMPLETE,showComplete);
		}
		
		private function showComplete(e:Event):void {
//			showImage = _playerview.getShowBitmapBig();
			_playerview.x = 593;
			_playerview.y = 198;
			
			var playerviewMask:Sprite=new Sprite();
			playerviewMask.graphics.beginFill(0x000000);
			playerviewMask.graphics.drawRect(0, 0, 124, 140);
			playerviewMask.graphics.endFill();
			playerviewMask.x = 604;
			playerviewMask.y = 199;
			_playerview.mask=playerviewMask;
			
			
			if(_asset) {
				_asset.addChild(playerviewMask);
				_asset.addChild(_playerview);
			}
			
			_levelIcon = new LevelIcon("",minfo.Grade,minfo.Repute,minfo.WinCount,minfo.TotalCount,minfo.FightPower);
			_levelIcon.stop();
			_levelIcon.x = 688.0;
			_levelIcon.y = 206;
			_levelIcon.mouseChildren = false;
			_levelIcon.mouseEnabled = false;
			if(_asset) {
				_asset.addChild(_levelIcon);
			}
		}
		
		private function updateSended():void
		{
			_asset.comman_mc.visible = false;
			
			var tempInfo:EmailInfoOfSended = (_info as EmailInfoOfSended);
			_sender.text = tempInfo ? tempInfo.Receiver : "";
			_topic.text = tempInfo ?tempInfo.Title : "";
			_ta.text = tempInfo ? tempInfo.Content : "";
			_ta.text+="\n"+tempInfo.AnnexRemark;
			_list.updateInfo(_info);
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_write_btn.addEventListener(MouseEvent.CLICK,__write);
			_reply_btn.addEventListener(MouseEvent.CLICK,__reply);
			_close_btn.addEventListener(MouseEvent.CLICK,__close);
			_lPage_btn.addEventListener(MouseEvent.CLICK,__lastPage);
			_rPage_btn.addEventListener(MouseEvent.CLICK,__nextPage);
			_reBack_btn.addEventListener(MouseEvent.CLICK,__backEmail);
			_help_btn.addEventListener(MouseEvent.CLICK, __help);
			_help_btn.addEventListener(MouseEvent.MOUSE_DOWN, __down);
			this.addEventListener(Event.ADDED_TO_STAGE, stageInit);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeUp);
			
			
			allMail_btn.addEventListener(MouseEvent.CLICK,selectMailTypeListener);
			noReadMail_btn.addEventListener(MouseEvent.CLICK,selectMailTypeListener);
			sendedMail_btn.addEventListener(MouseEvent.CLICK,selectMailTypeListener);
			
			_asset.selectAll_btn.addEventListener(MouseEvent.CLICK,selectAllListener);
			_asset.deleteSelect_btn.addEventListener(MouseEvent.CLICK,deleteSelectListener);
			_asset.receiveEx_btn.addEventListener(MouseEvent.CLICK,receiveExListener);
		}	
		
		private function stageInit(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, __up);
		}
		
		private function removeUp(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, __up);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_write_btn.removeEventListener(MouseEvent.CLICK,__write);
			_reply_btn.removeEventListener(MouseEvent.CLICK,__reply);
			_close_btn.removeEventListener(MouseEvent.CLICK,__close);
			_lPage_btn.removeEventListener(MouseEvent.CLICK,__lastPage);
			_rPage_btn.removeEventListener(MouseEvent.CLICK,__nextPage);
			_reBack_btn.removeEventListener(MouseEvent.CLICK,__backEmail);
			_help_btn.removeEventListener(MouseEvent.CLICK, __help);
			_help_btn.removeEventListener(MouseEvent.MOUSE_DOWN, __down);
			this.removeEventListener(Event.ADDED_TO_STAGE, stageInit);
			
			allMail_btn.removeEventListener(MouseEvent.CLICK,selectMailTypeListener);
			noReadMail_btn.removeEventListener(MouseEvent.CLICK,selectMailTypeListener);
			sendedMail_btn.removeEventListener(MouseEvent.CLICK,selectMailTypeListener);
			
			_asset.selectAll_btn.removeEventListener(MouseEvent.CLICK,selectAllListener);
			_asset.deleteSelect_btn.removeEventListener(MouseEvent.CLICK,deleteSelectListener);
			_asset.receiveEx_btn.removeEventListener(MouseEvent.CLICK,receiveExListener);
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_asset = new ReadingEmailAsset();
			_asset.comman_mc.visible = false
			addContent(_asset);			
			setContentSize(740,459);
			
			_sender.selectable = false;
			ComponentHelper.replaceChild(_asset,_asset.senderPos_mc,_sender);
			
			allMail_btn = _asset.allMail_btn;
			allMail_btn.buttonMode = true;
			allMail_btn.gotoAndStop(2);
			noReadMail_btn = _asset.noReadMail_btn;
			noReadMail_btn.buttonMode = true;
			noReadMail_btn.gotoAndStop(1);
			sendedMail_btn = _asset.sendedMail_btn;
			sendedMail_btn.buttonMode = true;
			sendedMail_btn.gotoAndStop(1);
			
			_reBack_btn   = new HLabelButton();
			_reBack_btn.label = LanguageMgr.GetTranslation("reBack_btn.label");
			//_reBack_btn.label = "退 信";
			_reBack_btn.useBackgoundPos = true;
			_reBack_btn.x = _asset.backPos_mc.x;
			_reBack_btn.y = _asset.backPos_mc.y;
			_asset.removeChild(_asset.backPos_mc);
			_asset.addChild(_reBack_btn);
			
			_reply_btn    = new HLabelButton();
			_reply_btn.label = LanguageMgr.GetTranslation("reply_btn.label");
			//_reply_btn.label = "回 复";
			_reply_btn.useBackgoundPos = true;
			_reply_btn.x = _asset.replayPos_mc.x;
			_reply_btn.y = _asset.replayPos_mc.y;
			_asset.removeChild(_asset.replayPos_mc);
			_asset.addChild(_reply_btn);
			
			_close_btn    = new HLabelButton();
			_close_btn.label = LanguageMgr.GetTranslation("cancel");
			_close_btn.useBackgoundPos = true;
			_close_btn.x = _asset.cancelPos_mc.x;
			_close_btn.y = _asset.cancelPos_mc.y;
			_asset.removeChild(_asset.cancelPos_mc);
			_asset.addChild(_close_btn);
			
			_write_btn    = new HLabelButton();
			_write_btn.label = LanguageMgr.GetTranslation("write_btn.label");
			//_write_btn.label = "写邮件";
			_write_btn.useBackgoundPos = true;
			_write_btn.x = _asset.writePos_mc.x;
			_write_btn.y = _asset.writePos_mc.y;
			_asset.removeChild(_asset.writePos_mc);
			_asset.addChild(_write_btn);
			
			_lPage_btn = new HBaseButton(_asset.page_mc.lPage_btn);
			_lPage_btn.useBackgoundPos = true;
			_asset.page_mc.addChild(_lPage_btn);
			
			_rPage_btn = new HBaseButton(_asset.page_mc.rPage_btn);
			_rPage_btn.useBackgoundPos = true;
			_asset.page_mc.addChild(_rPage_btn);
			
			_help_btn = new HBaseButton(_asset.useHelp);
			_help_btn.useBackgoundPos = true;
			_asset.addChild(_help_btn);
			
			_rPage_btn.enable = _lPage_btn.enable = false;
			
			_asset.senderType.stop();
			
			isCanReply = false;
			
			_topic.selectable = false;
			ComponentHelper.replaceChild(_asset,_asset.topicPos_mc,_topic);
			
			_ta.textField.mouseEnabled = false;
			_ta.textField.selectable = false;
			_ta.editable = false;
			ComponentHelper.replaceChild(_asset,_asset.contentPos_mc,_ta);
		
			
			personalHide();
			_diamonds = new Array();
			
			for(var i:uint = 0;i<5;i++)
			{
				_diamonds[i] = new DiamondOfReading(i);
				_diamonds[i].x = _asset.diamondListPos_mc.x+i*68;
				_diamonds[i].y = _asset.diamondListPos_mc.y;
				_asset.addChild(_diamonds[i]);
			}
			
			_asset.diamondListPos_mc.visible = false;
			
			_list = new EmailIIListView();
			ComponentHelper.replaceChild(_asset,_asset.listPos_mc,_list);
			
			
		}
		
		private function selectMailTypeListener(e:MouseEvent):void
		{
			personalHide();
			clearPersonalImage();
			btnSound();
			resetBtnStatus();
			MovieClip(e.currentTarget).gotoAndStop(2);
			
			if(e.currentTarget == allMail_btn)
			{
				MailManager.Instance.changeType(EmailIIState.ALL);
			}else if(e.currentTarget == noReadMail_btn)
			{ 
				MailManager.Instance.changeType(EmailIIState.NOREAD);
			}else
			{
				MailManager.Instance.changeType(EmailIIState.SENDED);
			}
		}	
		
		private function resetBtnStatus():void
		{
			allMail_btn.gotoAndStop(1);
			noReadMail_btn.gotoAndStop(1);
			sendedMail_btn.gotoAndStop(1);
		}
		/**
		 * 全选 
		 * @param e
		 * 
		 */		
		private function selectAllListener(e:MouseEvent):void
		{
			btnSound();
			_list.switchSeleted();
		}
		/**
		 * 删除所选 
		 * @param e
		 * 
		 */		
		private function deleteSelectListener(e:MouseEvent):void
		{
			btnSound();
			if(PlayerManager.Instance.Self.bagLocked)
	        {
	        	new BagLockedGetFrame().show();
	        	return;
	        }
			var arr:Array = _list.getSelectedMails();
			if(arr.length>0)
			{
				for(var i:int = 0; i < arr.length; i++) {
					if(arr[i].hasAnnexs() || arr[i].Money != 0){
						HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("ddt.view.emailII.EmailIIStripView.delectEmail"),true,ok,cancle);
						break;
					}
					if(i == arr.length - 1) {
						ok();
					}
				}
				
			}else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.ReadingView.deleteSelectListener"));
				//MessageTipManager.getInstance().show("请至少选择一封邮件");
			}
		}
		
		private function cancle():void
		{
			btnSound();
		}
		
		private function ok():void
		{
			btnSound();
			
			var arr:Array = _list.getSelectedMails();	
			for(var i:uint = 0;i<arr.length;i++)
			{
				MailManager.Instance.deleteEmail(arr[i]);
				MailManager.Instance.removeMail(arr[i]);
				MailManager.Instance.changeSelected(null);
			}
		}
		
		/**
		 * 收取附件 
		 * @param e
		 * 
		 */		
		private function receiveExListener(e:MouseEvent):void
		{
			btnSound();
			if(PlayerManager.Instance.Self.bagLocked)
	        {
	        	new BagLockedGetFrame().show();
	        	return;
	        }
			var arr:Array = _list.getSelectedMails();
			if(arr.length>0)
			{
				for(var i:uint = 0;i<arr.length;i++)
				{
					if((arr[i] as EmailInfo).Type>100&&(arr[i] as EmailInfo).Money>0)
					{
						continue;
					}
					var _info:EmailInfo = arr[i] as EmailInfo;
					if(!_info.IsRead)
					{
						var str:String = _info.SendTime;
    	 		        var startTime:Date = new Date(Number(str.substr(0,4)),Number(str.substr(5,2))-1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
				 		_info.ValidDate = 72+(TimeManager.Instance.Now().time - startTime.time)/(60*60*1000);
					}
					MailManager.Instance.getAnnexToBag(arr[i],0);
					
				}			
			}else
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.emailII.ReadingView.deleteSelectListener"));
				//MessageTipManager.getInstance().show("请至少选择一封邮件");
			}
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			_reBack_btn.dispose();
			_reBack_btn = null;
			_reply_btn.dispose();
			_reply_btn = null;
			_close_btn.dispose();
			_close_btn = null;
			_write_btn.dispose();
			_write_btn = null;
			_lPage_btn.dispose();
			_lPage_btn = null;
			_rPage_btn.dispose();
			_rPage_btn = null;
			closeCallBack = null;
			clearPersonalImage();
			if(_helpPage) {
				_helpPage.dispose();
				_helpPage = null;
			}
			if(_list.parent)
			{
				_asset.removeChild(_list);
			}
			_list.dispose();
			_list = null;
			if(_asset.parent)
			{
				_asset.parent.removeChild(_asset);
//				trace(this,_content,_asset.parent,_asset.parent.name);  ///why?why? _asset.parent不是 _content
			}
			_info = null;
			_asset = null;
			for each(var diamond:DiamondOfReading in _diamonds)
			{
				diamond.dispose();
				if(diamond.parent)
				{
					diamond.parent.removeChild(diamond);
				}
				diamond = null;
			}
			_diamonds = [];
		}
		
		internal function setListView(array:Array,totalPage:int,currentPage:int,isSendedMail:Boolean = false):void
		{
			_list.update(array,isSendedMail);
			
			_asset.page_mc.page_txt.text = currentPage.toString() + "/" + totalPage.toString();
			
			_lPage_btn.enable = ((currentPage == 0 || currentPage == 1) ? false : true);
			_rPage_btn.enable = (currentPage == totalPage ? false : true);
		}
		
		private function __write(event:MouseEvent):void
		{
			btnSound();
			if(_helpPage) {
				_helpPage.hide();
			}
			MailManager.Instance.changeState(EmailIIState.WRITE);
		}	
		
		private function __reply(event:MouseEvent):void
		{
			btnSound();
			MailManager.Instance.changeState(EmailIIState.REPLY);
		}
		
		private function __close(event:MouseEvent):void
		{
			btnSound();
			closeWin();
		}
		
		private function closeWin():void
		{
			MailManager.Instance.hide();
		}
		
		/**
		 * 下一页 
		 * @param event
		 */		
		private function __nextPage(event:MouseEvent):void
		{
			SoundManager.instance.play("045");
			MailManager.Instance.setPage(false,_list.canChangePage());
			MailManager.Instance.changeSelected(null);
			if(_levelIcon) {
				clearPersonalImage();
			}
		}
		/**
		 * 上一页 
		 * @param event
		 */		
		private function __lastPage(event:MouseEvent):void
		{
			SoundManager.instance.play("045");
			MailManager.Instance.setPage(true,_list.canChangePage());
			MailManager.Instance.changeSelected(null);
			if(_levelIcon) {
				clearPersonalImage();
			}
		}
		
		
		private function __backEmail(e:MouseEvent):void
		{
			btnSound();
			MailManager.Instance.untreadEmail(_info.ID);
		}
		
		
		private var _helpPage : HelpFrame;
		private function initHelpPage() : void
		{
			var helpBd : BitmapData = new useHelpAsset(0,0);
			var helpIma : Bitmap = new Bitmap(helpBd);
			_helpPage = new HelpFrame(helpIma);
			_helpPage.titleText = LanguageMgr.GetTranslation("ddt.view.emailII.ReadingView.useHelp");
			_helpPage.okLabel = LanguageMgr.GetTranslation("close");
			helpBd = null;
		}
		
		private function __help(e:MouseEvent):void {
			SoundManager.instance.play("008");
			e.stopImmediatePropagation();
			if(!_helpPage) {
				initHelpPage();
			}
			_helpPage.show();
		}
		
		private function __down(e:MouseEvent):void {
			_asset.useHelp.gotoAndStop(2);
		}
		
		private function __up(e:MouseEvent):void {
			_asset.useHelp.gotoAndStop(1);
		}
		
		public function personalHide():void {
			_asset.personal_mc.visible=false;
		}
		
	}
}