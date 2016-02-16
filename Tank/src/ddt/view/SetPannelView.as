package ddt.view
{
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.events.SliderEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import game.crazyTank.view.setting.SettingAsset;
	
	import org.aswing.KeyStroke;
	import org.aswing.KeyboardManager;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.manager.UIManager;
	import road.utils.ComponentHelper;
	
	import ddt.data.EquipType;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SharedManager;
	import ddt.manager.SocketManager;
	import ddt.utils.ComponentHelperII;
	import ddt.view.setview.CheckBoxSetting;
	import ddt.view.setview.Slider;

	public class SetPannelView extends HConfirmFrame
	{
		private var _checkbox:Array
		
		private var _asset:SettingAsset;
		
		private var _confirg:HLabelButton;
		
		private var _slide:Slider;
		
		private var _effectSlide:Slider;
		
		/* Singleton */
		private static var instance:SetPannelView;
		
		public static function get Instance():SetPannelView
		{
			if(instance == null)
			{
				instance = new SetPannelView();
			}
			return instance;
		}
		/* construction */
		public function SetPannelView()
		{
			super();
			alphaGound = false;
			blackGound = false;
			fireEvent = false;
			showBottom = true;
			showCancel = true;
			okBtn.y = okBtn.y;
			cancelBtn.y = cancelBtn.y;
			okFunction = __confirm;
			cancelFunction = __cancel;
			initView();
			initEvent();
		}

		private function initView():void
		{
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 14;
			format.color = 0xffffff;
			format.bold = true;
	
			titleText = LanguageMgr.GetTranslation("ddt.game.ToolStripView.set");

			_asset = new SettingAsset();
			addContent(_asset);		
						
			setContentSize(296,394);
//			paddingHeight = 0;
	
			_checkbox = [];
			var groups:Array = [];
			for(var i:int = 0; i < 6; i++)
			{
				_asset["pos" + i].visible = false;
				var r:CheckBoxSetting = new CheckBoxSetting();
				r.textField.text="";
				r.fireAuto=true;

				ComponentHelperII.replaceChildPostion(_asset["pos" + i],r);
				r.addEventListener(MouseEvent.CLICK,__select);
				_asset.addChild(r);
				_checkbox.push(r);
			}
			_slide = new Slider();
			_slide.x = _asset.slide_pos.x;
			_slide.y = _asset.slide_pos.y;
			//_slide.liveDragging = true;
			_slide.maximum = 100;
			_slide.addEventListener(Event.CHANGE,__slidChanged);
			_asset.addChild(_slide);

			
			_effectSlide = new Slider();
			_effectSlide.x = _asset.eslide_pos.x;
			_effectSlide.y = _asset.eslide_pos.y;
			_effectSlide.maximum = 100;
			//_effectSlide.liveDragging = true;
			_effectSlide.addEventListener(Event.CHANGE,__effectSlideChanged);
			_asset.addChild(_effectSlide);
			
			allowMusic = SharedManager.Instance.allowMusic;
			allowSound = SharedManager.Instance.allowSound;
			particle = SharedManager.Instance.showParticle;
			showbugle = SharedManager.Instance.showTopMessageBar;
			
			
		}
		
		private function __select(evt:MouseEvent):void
		{
			SharedManager.Instance.allowMusic = allowMusic;
			SharedManager.Instance.allowSound = allowSound;
			SharedManager.Instance.changed();
			updateLeftGreyArea()
		}
		
		private function updateLeftGreyArea():void{
			if(_checkbox[0].selected)
			{
				_slide.hideGreyArea();
				_slide.ableUseGrey();
			}  
			else if(!_checkbox[0].selected)
			{
				_slide.showGreyAreaFull();
				_slide.unableUseGrey();
			}
			
			if(_checkbox[1].selected)
			{
				_effectSlide.hideGreyArea();
				_effectSlide.ableUseGrey();
			} else if(!_checkbox[1].selected){
				_effectSlide.showGreyAreaFull();
				_effectSlide.unableUseGrey();
			}
			

		}
		
		
		private function __slidChanged(event:Event):void
		{
			SharedManager.Instance.musicVolumn = volumn;
			SharedManager.Instance.changed();
			updateLeftGreyArea()
			//
		}
		
		private function __effectSlideChanged(event:Event):void
		{
			SharedManager.Instance.soundVolumn = evolumn;
			SharedManager.Instance.changed();
			updateLeftGreyArea()
		}
		
		private function get allowMusic():Boolean
		{
			return _checkbox[0].selected;
		}
		private function set allowMusic(value:Boolean):void
		{
			_checkbox[0].selected = value;
		}
		private function get allowSound():Boolean
		{
			return _checkbox[1].selected;
		}
		private function set allowSound(value:Boolean):void
		{
			_checkbox[1].selected = value;
		}
		private function get particle():Boolean
		{
			return _checkbox[2].selected;
		}
		private function set particle(value:Boolean):void
		{
			_checkbox[2].selected = value;
		}
		private function get showbugle():Boolean
		{
			return _checkbox[3].selected;
		}
		private function set showbugle(value:Boolean):void
		{
			_checkbox[3].selected = value;
		}

		private function get invate():Boolean
		{
			return _checkbox[4].selected;
		}
		private function set invate(value:Boolean):void
		{
			_checkbox[4].selected = value;
		}
		/* 显示好友上下线提示 */
		private function get showOL():Boolean
		{
			return _checkbox[5].selected;
		}
		private function set showOL(value:Boolean):void
		{
			_checkbox[5].selected = value;
		}


		/* 音乐slider */
		public function set volumn(value:Number):void
		{
			_slide.value = value;
		}
		public function get volumn():Number
		{
			return _slide.value;
		}
		
		/* 音效slider */
		public function set evolumn(value:Number):void
		{
			_effectSlide.value = value ;
		}
		
		public function get evolumn():Number
		{
			return _effectSlide.value ;
		}
		
		private function initEvent():void
		{
			addEventListener(Event.CLOSE,__close);
//			_confirg.addEventListener(MouseEvent.CLICK,__confirm);
		}
		
		private function __confirm(event:MouseEvent = null):void
		{
			SharedManager.Instance.allowMusic = allowMusic;
			SharedManager.Instance.allowSound = allowSound;
			SharedManager.Instance.showParticle = particle;
			SharedManager.Instance.showTopMessageBar = showbugle;
			SharedManager.Instance.showInvateWindow = invate;

			SharedManager.Instance.showOL = showOL;
			SharedManager.Instance.showCI = showOL;
			
			SharedManager.Instance.musicVolumn = volumn;
			SharedManager.Instance.soundVolumn = evolumn;
			SharedManager.Instance.save();

			hide();
		}
		protected override function __closeClick(e:MouseEvent):void
		{
			doCancel();
		}
		private function doCancel():void
		{
			SoundManager.Instance.play("008");
			hide();
			revert();
		}
		private function __cancel():void
		{
			doCancel()
		}
		
		private function __close(event:Event):void
		{
			doCancel()
		}
		
		override public function dispose():void
		{
		}
		
		
		public function switchVisible():void
		{
			if(parent)
			{
				hide();
			}	
			else
			{
				open();
			}
		}
		
		
		private var _oldHideHate:Boolean;
		private var _oldAllowMusic:Boolean;
		private var _oldAllowSound:Boolean;
		private var _oldShowParticle:Boolean;
		private var _oldShowBugle:Boolean;
		private var _oldShowInvate:Boolean;
		private var _oldShowSP:Boolean;
		private var _oldMusicVolumn:int;
		private var _oldSoundVolumn:int;
		private var _oldShowOL:Boolean;
		private var _oldShowCI:Boolean;
		
		private var _oldHideGlass:Boolean;  //bret 09.7.31
		private var _oldHideSuit:Boolean;   //bret 09.7.31
		
		
		public function open():void
		{
			KeyboardManager.getInstance().registerKeyAction(KeyStroke.VK_ENTER,__confirm);
//			_oldHideHate = hidehat = PlayerManager.Instance.Self.getHatHide();
			_oldAllowMusic = allowMusic = SharedManager.Instance.allowMusic;
			_oldAllowSound = allowSound = SharedManager.Instance.allowSound;
			_oldShowParticle = particle = SharedManager.Instance.showParticle;
			_oldShowBugle =	showbugle = SharedManager.Instance.showTopMessageBar;
			_oldShowInvate = invate = SharedManager.Instance.showInvateWindow;
//			_oldShowSP = special = SharedManager.Instance.showSPCartoon;
			
			_oldShowOL = showOL = SharedManager.Instance.showOL;
//			_oldShowCI = showCI = SharedManager.Instance.showCI;
			
			_oldMusicVolumn = volumn = SharedManager.Instance.musicVolumn;
			_oldSoundVolumn = evolumn = SharedManager.Instance.soundVolumn;
			
			
//			_oldHideGlass = hideglass = PlayerManager.Instance.Self.getGlassHide();  //bret 09.7.31
//			_oldHideSuit = hidesuit = PlayerManager.Instance.Self.getSuitesHide();     //bret 09.7.31
			UIManager.AddDialog(this);
//			TipManager.AddTippanel(this,true);
			updateLeftGreyArea()
		}
		
		private function revert():void
		{
			SharedManager.Instance.allowMusic = _oldAllowMusic;
			SharedManager.Instance.allowSound = _oldAllowSound;
			SharedManager.Instance.showParticle = _oldShowParticle;
			SharedManager.Instance.showTopMessageBar = _oldShowBugle;
			SharedManager.Instance.showInvateWindow = _oldShowInvate;
			
			SharedManager.Instance.showOL = _oldShowOL;
			SharedManager.Instance.showCI = _oldShowOL;
			
			SharedManager.Instance.musicVolumn = _oldMusicVolumn;
			SharedManager.Instance.soundVolumn = _oldSoundVolumn;
			SharedManager.Instance.save();
			if(PlayerManager.Instance.Self.getHatHide() != _oldHideHate)
			{
				SocketManager.Instance.out.sendHideLayer(EquipType.HEAD,!_oldHideHate);
			}
			/* bret 09.8.1 */
			if(PlayerManager.Instance.Self.getGlassHide() != _oldHideGlass)
			{
				SocketManager.Instance.out.sendHideLayer(EquipType.GLASS,!_oldHideGlass);
			}
			if(PlayerManager.Instance.Self.getSuitesHide() != _oldHideSuit)
			{
				SocketManager.Instance.out.sendHideLayer(EquipType.SUITS,!_oldHideSuit);
			}
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			super.__onKeyDownd(e);
			e.stopImmediatePropagation();
		}
		
		override public function hide():void
		{
			KeyboardManager.getInstance().unregisterKeyAction(KeyStroke.VK_ENTER,__confirm);
			if(parent)
				parent.removeChild(this);
		}
	}
}