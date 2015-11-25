package ddt.view.movement
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	
	import road.manager.SoundManager;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import ddt.data.MovementInfo;
	import tank.game.movement.MoveMentRightAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;

	public class MovementRightView extends HConfirmFrame
	{
		private var _info:MovementInfo;
		internal function set info(value:MovementInfo):void
		{
			//if(_info == value) return;
			_info = value;
			update();	
		}
		
		private var _asset:MoveMentRightAsset;
		
		private var _confirm:Button;
		
		private var _cancel:Button;
		
		private var _list:SimpleGrid;
		
		private var _container:Sprite;
		
		public function MovementRightView()
		{
			super();
			initView();
			addEvent();
		}
		
		private function initView():void
		{
//			setCloseVisible(false);
//			marginWidth = 1;

            blackGound = false;
			alphaGound = false;
			fireEvent = false;
			showCancel = true;
			setContentSize(340,391);
			_asset = new MoveMentRightAsset();
			this.addContent(_asset);
            okLabel = LanguageMgr.GetTranslation("get");
            //okLabel = "领 取";
			_list = new SimpleGrid();
			_list.horizontalScrollPolicy = "off";
			_list.setSize(345,310);
			_list.move(_asset.listPos_mc.x,_asset.listPos_mc.y);
			_asset.listPos_mc.visible = false;
			_asset.addChild(_list);
			
			_asset.title_mc.title_txt.mouseWheelEnabled = false;
			_asset.title_mc.title_txt.width = 338;
//			_asset.title_mc.title_txt.autoSize = TextFieldAutoSize.CENTER;
			_asset.discription_mc.description_txt.mouseWheelEnabled = false;
			_asset.discription_mc.description_txt.autoSize = TextFieldAutoSize.LEFT;

			_asset.availabilityTime_mc.availabilityTime_txt.mouseWheelEnabled = false;
			_asset.availabilityTime_mc.availabilityTime_txt.autoSize = TextFieldAutoSize.LEFT;
			_asset.availabilityTime_mc.availabilityTime_txt.wordWrap = true;

			_asset.award_mc.award_txt.mouseWheelEnabled = false;
			_asset.award_mc.award_txt.autoSize = TextFieldAutoSize.LEFT;
			_asset.content_mc.content_txt.htmlText = "";
			_asset.content_mc.content_txt.mouseWheelEnabled = false;
			_asset.content_mc.content_txt.autoSize = TextFieldAutoSize.LEFT;
			_container = new Sprite();
		
			this.okFunction = __confirm;
			this.cancelFunction = close;
			this.buttonGape = 30;
			this.setCloseVisible = false;
			
		}
		
		private function addEvent():void
		{
			_asset.password_mc.addEventListener(TextEvent.TEXT_INPUT,__input);
			addEventListener(TextEvent.LINK,__link);
		}
		
		private function removeEvent():void
		{
			_asset.password_mc.pass_txt.removeEventListener(TextEvent.TEXT_INPUT,__input);
			removeEventListener(TextEvent.LINK,__link);
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			
			if(_container.parent)
			{
				_list.clearItems();
			}
			_container = null;
			
			if(_list.parent)
			{
				_asset.removeChild(_list);
			}
			_list = null;
			
			if(_asset.parent)
			{
				_asset.parent.removeChild(_asset);
			}
			_asset = null;
			
			if(parent)
				parent.removeChild(this);
		}
		
		
		override public function show():void
		{
			if(MovementLeftView.Instance.parent)
			{
				super.show();
				addEvent();
				x = MovementLeftView.Instance.x + MovementLeftView.Instance.width;
				y = MovementLeftView.Instance.y;
			}
		}
		
		override public function hide():void
		{
			super.hide();
			removeEvent();
			if(parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		private function update():void
		{
			show();
			_list.clearItems();
			updateContainer();
			_list.cellHeight = _container.height;
			_list.cellWidth = _container.width;
			_list.appendItem(_container);			
		}	
		
		private function updateContainer():void
		{
			_container = new Sprite();
			
//			var format:TextFormat = new TextFormat();
//			format.color = 0xffcc66;
//			format.bold = true;
			
//			format.font = LanguageMgr.GetTranslation("Arial");
			//format.font = "宋体";
			_asset.title_mc.title_txt.text = "";
//			_asset.title_mc.title_txt.defaultTextFormat = format;
			_asset.title_mc.title_txt.text = _info.Title;
//			_container.addChild(_asset.title_mc);
			
			_asset.discription_mc.description_txt.htmlText = "";
			_asset.discription_mc.y = 0;
//			_asset.discription_mc.y = _asset.title_mc.y + _asset.title_mc.title_txt.textHeight + 20;
			_asset.discription_mc.description_txt.htmlText = _info.Description;
			_asset.discription_mc.lineMc.y = _asset.discription_mc.description_txt.y + _asset.discription_mc.description_txt.textHeight+10;
			_container.addChild(_asset.discription_mc);
			
			
			_asset.availabilityTime_mc.availabilityTime_txt.text = "";
			_asset.availabilityTime_mc.y = _asset.discription_mc.y +  _asset.discription_mc.description_txt.textHeight + 30;
			if(!_info.Description)
			{
				_asset.availabilityTime_mc.y = _asset.discription_mc.y +  _asset.discription_mc.height + 20;	
			}
			_asset.availabilityTime_mc.availabilityTime_txt.text = _info.activeTime();
			_asset.availabilityTime_mc.lineMc.y = _asset.availabilityTime_mc.availabilityTime_txt.y + _asset.availabilityTime_mc.availabilityTime_txt.textHeight+10;
			_container.addChild(_asset.availabilityTime_mc);
			
			_asset.content_mc.content_txt.htmlText = "";
			_asset.content_mc.y = _asset.availabilityTime_mc.y + _asset.availabilityTime_mc.availabilityTime_txt.textHeight + 30;
			if(_info.Content)
			{
				_asset.content_mc.content_txt.htmlText = _info.Content; //"测试        <font color='#0066FF'><u><a href=\'event:http://www.baidu.com\'>http://www.baidu.com</a></u></font>";
				addEvent();
			}
			_asset.content_mc.lineMc.y = _asset.content_mc.content_txt.y + _asset.content_mc.content_txt.textHeight+10;
			_container.addChild(_asset.content_mc);
			
			_asset.award_mc.award_txt.htmlText = "";
			_asset.award_mc.y = _asset.content_mc.y + _asset.content_mc.content_txt.textHeight + 40;
			if(!_info.Content)
			{
				_asset.award_mc.y = _asset.content_mc.y + _asset.content_mc.height + 30;
			}
			if(_info.AwardContent)
			{
				_asset.award_mc.award_txt.htmlText = _info.AwardContent;
			}
	
			_container.addChild(_asset.award_mc);
						

			if(_info.HasKey==1)
			{
				_asset.password_mc.visible = true;
				_container.addChild(_asset.password_mc);
				
//				if(_asset.award_mc.y>230)_asset.password_mc.y = _asset.award_mc.y + _asset.award_mc.award_txt.textHeight + 30;
//				else _asset.password_mc.y = 320;
				
				if(!_info.AwardContent)
				{
					_asset.password_mc.y = _asset.award_mc.y + _asset.award_mc.height + 12;
				}
				else
				{
					_asset.password_mc.y = _asset.award_mc.y + _asset.award_mc.award_txt.textHeight + 30;
				}
				_asset.password_mc.pass_txt.text = "";
				_asset.password_mc.lineMc.visible = false;
			}
			else
			{
				_asset.password_mc.visible = false;
			}
			
//			if(_info.HasKey==1||_info.HasKey==2||_info.HasKey==3)
//			if(_info.HasKey==1)//bre 09.6.12
			if(_info.HasKey==1||_info.HasKey==2||_info.HasKey==3)
			{
				this.okBtn.visible = true;
				okBtnEnable = !_info.isAttend;
				cancelBtn.x = 130;
			}
			else
			{
				this.okBtn.visible = false;
				cancelBtn.x = 165;
			}
		}
		
		
		
		private function __input(event:TextEvent):void
		{
			if((_asset.password_mc.pass_txt.text.length + event.text.length) > 50)
			{
				event.preventDefault();
			}
			if(_asset.password_mc.pass_txt.text != "")okBtnEnable = true;
		}		

		
		override public function close():void
		{
			SoundManager.instance.play("008");
			super.close();
			removeEvent();
		}
		
		private function __confirm():void
		{
			SoundManager.instance.play("008");
			if(_asset.password_mc.pass_txt.text == ""&&_info.HasKey==1 )
			{
				
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.movement.MovementRightView.pass"),true);
				//AlertDialog.show("提示","请输入卡密",true);
				return;
			}
			_info.isAttend = true;
			okBtnEnable = false;
			SocketManager.Instance.out.sendActivePullDown(_info.ActiveID,_asset.password_mc.pass_txt.text);
			_asset.password_mc.pass_txt.text = "";
			//doClosing();
		}
		
		private function __link(e:TextEvent):void
		{
			navigateToURL(new URLRequest(e.text));
		}
		
	}
}