package ddt.view.dailyconduct
{
	import com.dailyconduct.view.DailyConductBgAsset;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HAlertDialog;
	import road.utils.ComponentHelper;
	
	import ddt.data.MovementInfo;
	import tank.game.movement.MoveMentRightAsset;
	import tank.game.movement.MovementContentAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.SocketManager;

	public class DailyMovementContext extends Sprite
	{
		private var _info            : MovementInfo;
		private var _panel           : ScrollPane;
		private var _uipanel         : UIComponent;
		private var _parent          : DailyConductBgAsset;
		public function DailyMovementContext($parent : DailyConductBgAsset)
		{
			_parent = $parent;
			super();
			init();
		}
		private function init() : void
		{
			_uipanel = new UIComponent();
			
			_panel = new ScrollPane();
			_panel.setStyle("upSkin",new Sprite());
			_panel.setStyle("skin",new Sprite());
			_panel.horizontalScrollPolicy = ScrollPolicy.OFF;
			ComponentHelper.replaceChild(_parent,_parent.pos4,_panel);
			_panel.source = _uipanel;
			
			_asset = new MovementContentAsset();
			_container = new Sprite();
			_uipanel.addChild(_container);
			
			
			_asset.discription_mc.description_txt.mouseWheelEnabled = false;
			_asset.discription_mc.description_txt.autoSize = TextFieldAutoSize.LEFT;
			_asset.discription_mc.description_txt.wordWrap = true;

			_asset.availabilityTime_mc.availabilityTime_txt.mouseWheelEnabled = false;
			_asset.availabilityTime_mc.availabilityTime_txt.autoSize = TextFieldAutoSize.LEFT;
			_asset.availabilityTime_mc.availabilityTime_txt.wordWrap = true;

			_asset.award_mc.award_txt.mouseWheelEnabled = false;
			_asset.award_mc.award_txt.autoSize = TextFieldAutoSize.LEFT;
			_asset.content_mc.content_txt.htmlText = "";
			_asset.content_mc.content_txt.mouseWheelEnabled = false;
			_asset.content_mc.content_txt.autoSize = TextFieldAutoSize.LEFT;
		}
		public function set info(data : MovementInfo) : void
		{
			_info = data;
			updateContainer();
		}
		public function get info() : MovementInfo
		{
			return _info;
			
		}
		
		private var _container : Sprite;
		private var _asset     : MovementContentAsset;
		private var _password_mc:MovieClip;
		private var _okBtn:HLabelButton;
		
		private function updateContainer():void
		{
			_asset.title_mc.title_txt.text = "";
			_asset.title_mc.title_txt.text = _info.Title;
			_asset.title_mc.y = 0;
			_container.addChild(_asset.title_mc);
			_asset.discription_mc.description_txt.htmlText = "";
			_asset.discription_mc.y = _asset.title_mc.y + _asset.title_mc.height + 10;
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
			
			if(_password_mc && _password_mc.parent)
				_password_mc.parent.removeChild(_password_mc);
			_password_mc = null;
			
			if(_okBtn)
				_okBtn.dispose();
			_okBtn = null;
			
			if(_info.HasKey == 1)
			{
				var tmp:MoveMentRightAsset = new MoveMentRightAsset();
				_password_mc = tmp.password_mc;
				_password_mc.visible = true;
				_password_mc
				_container.addChild(_password_mc);
				_password_mc.y = _asset.availabilityTime_mc.y + _asset.availabilityTime_mc.availabilityTime_txt.textHeight + 30;
				_password_mc.pass_txt.text = "";
			}
			
			if((_info.HasKey==1||_info.HasKey==2||_info.HasKey==3) && _password_mc)
			{
				_okBtn = new HLabelButton();
				_okBtn.label = LanguageMgr.GetTranslation("ddt.view.dailyconduct.gain");
				_okBtn.enable = !_info.isAttend;
				_okBtn.x = _password_mc.x + _password_mc.width;
				_okBtn.y = _password_mc.y - 6;
				_okBtn.addEventListener(MouseEvent.CLICK, __pullDown);
				_container.addChild(_okBtn);
			}
			
			if(_password_mc)
			{
				_asset.content_mc.y = _password_mc.y + _password_mc.pass_txt.textHeight + 30;
			}
			else
			{
				_asset.content_mc.y = _asset.availabilityTime_mc.y + _asset.availabilityTime_mc.availabilityTime_txt.textHeight + 30;
			}
			
			_asset.content_mc.content_txt.htmlText = "";
			
			if(_info.Content)
			{
				_asset.content_mc.content_txt.htmlText = _info.Content; //"测试        <font color='#0066FF'><u><a href=\'event:http://www.baidu.com\'>http://www.baidu.com</a></u></font>";
//				addEvent();
			}
			_asset.content_mc.lineMc.y = _asset.content_mc.content_txt.y + _asset.content_mc.content_txt.textHeight+10;
			_container.addChild(_asset.content_mc);
			
			_asset.award_mc.award_txt.htmlText = "";
			_asset.award_mc.y = _asset.content_mc.y + _asset.content_mc.content_txt.textHeight + 45;
			if(!_info.Content)
			{
				_asset.award_mc.y = _asset.content_mc.y + _asset.content_mc.height + 30;
			}
			if(_info.AwardContent)
			{
				_asset.award_mc.award_txt.htmlText = _info.AwardContent;
			}
	
			_container.addChild(_asset.award_mc);
						


			_uipanel.height = _container.height + 20;
			_panel.update();
			_panel.verticalScrollPosition = 0;
		}
		
		private function __pullDown(e:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			if(_password_mc.pass_txt.text == "" && _info.HasKey == 1 )
			{
				
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.movement.MovementRightView.pass"),true);
				//AlertDialog.show("提示","请输入卡密",true);
				return;
			}
			
			_info.isAttend = true;
			_okBtn.enable = false;
			SocketManager.Instance.out.sendActivePullDown(_info.ActiveID,_password_mc.pass_txt.text);
			_password_mc.pass_txt.text = "";
		}
		
		public function dispose():void
		{
			_info = null;
			
			if(_asset.title_mc && _asset.title_mc.parent)
				_asset.title_mc.parent.removeChild(_asset.title_mc);
				
			if(_asset.discription_mc && _asset.discription_mc.parent)
				_asset.discription_mc.parent.removeChild(_asset.discription_mc);
				
			if(_asset.availabilityTime_mc && _asset.availabilityTime_mc.parent)
				_asset.availabilityTime_mc.parent.removeChild(_asset.availabilityTime_mc);
				
			if(_asset.content_mc && _asset.content_mc.parent)
				_asset.content_mc.parent.removeChild(_asset.content_mc);
			
			_asset = null;
			
			if(_password_mc && _password_mc.parent)
				_password_mc.parent.removeChild(_password_mc);
			_password_mc = null;
			
			if(_okBtn)
			{
				_okBtn.removeEventListener(MouseEvent.CLICK, __pullDown);
				_okBtn.dispose();
			}
			_okBtn = null;
			
			if(_container && _container.parent)
				_container.parent.removeChild(_container);
			_container = null;
			
			if(_uipanel && _uipanel.parent)
				_uipanel.parent.removeChild(_uipanel);
			_uipanel = null;
			
			if(_panel)
			{
				_panel.source = null;
				if(_panel.parent)
					_panel.parent.removeChild(_panel);
			}
			_panel = null;
			
			_parent = null;
			
			if(parent)
				parent.removeChild(this);
		}
	}
}