package ddt.church.churchScene
{
	import ddt.church.churchScene.frame.DialogueUseSalute;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import road.BitmapUtil.ScaleBitmap;
//	import road.loader.ModelLoader;
	import road.manager.SoundManager;
	///import road.model.ModelEvent;
	//import road.model.ModelManager;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.controls.hframe.bitmap.ChurchRoomNameBG;
	import road.ui.manager.TipManager;
	
	import tank.church.SceneUIAsset;
	import ddt.data.ChurchRoomInfo;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;
	import ddt.view.common.WaitingView;
	import road.utils.ClassUtils;
	import road.loader.*;
	
	public class SceneUI extends SceneUIAsset
	{
		private var _controler:SceneControler;
		
		
		private var _showName:MovieClip;
		private var _showPao:MovieClip;
		private var _showFire:MovieClip;
		
		private var _tablet:Sprite;
		private var _roomNameBG:ScaleBitmap;
		private var _format:TextFormat;
		
		private var _enterMoonSceneBtn:MovieClip;
		private var _useSalute:SimpleButton;
		
		private var hideConfigs:Array = [];
		
		public function SceneUI(controler:SceneControler)
		{
			this._controler = controler;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			_roomNameBG = new ChurchRoomNameBG();
			
			_tablet = new Sprite();
			_tablet.mouseEnabled = false;
			_tablet.addChild(_roomNameBG);
			
			_format = new TextFormat("Arial",16);
			//_format = new TextFormat("宋体",16);
			
			setTablet();
						
			_enterMoonSceneBtn = this.enterMoonSceneBtn;
			_enterMoonSceneBtn.mouseChildren = false;
			_enterMoonSceneBtn.buttonMode = true;

			_useSalute  = this.useSalute;
//			_useSalute.x = _enterMoonSceneBtn.x;
//			_useSalute.y = _enterMoonSceneBtn.y+15;
			
			removeChild(_enterMoonSceneBtn);
			removeChild(_useSalute);
			
			_showName = this.ShowNameAsset;
			_showName.gotoAndStop(ChurchRoomManager.instance.isHideName?1:2);
			_showName.buttonMode = true;
			
			_showPao = this.ShowPaopaoAsset;
			_showPao.gotoAndStop(ChurchRoomManager.instance.isHidePao?1:2);
			_showPao.buttonMode = true;
			
			_showFire = this.FireHideControlBtnAsset;
			_showFire.gotoAndStop(ChurchRoomManager.instance.isHideFire?1:2);
			_showFire.buttonMode = true;
		}
		
		private function addEvent():void
		{
			_enterMoonSceneBtn.addEventListener(MouseEvent.CLICK,__enterMoonScene);
//			_useSalute.addEventListener(MouseEvent.CLICK,__useSalute);
			_showName.addEventListener(MouseEvent.CLICK,__hideClick);
			_showPao.addEventListener(MouseEvent.CLICK,__hideClick);
			_showFire.addEventListener(MouseEvent.CLICK,__hideClick);
		}
		
		private function removeEvent():void
		{
			_enterMoonSceneBtn.removeEventListener(MouseEvent.CLICK,__enterMoonScene);
//			_useSalute.removeEventListener(MouseEvent.CLICK,__useSalute);
			_showName.removeEventListener(MouseEvent.CLICK,__hideClick);
			_showPao.removeEventListener(MouseEvent.CLICK,__hideClick);
			_showFire.removeEventListener(MouseEvent.CLICK,__hideClick);
		}
		
		private function __enterMoonScene(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
//			if(saluteLoaded)
//			{
				ChurchRoomManager.instance.currentScene = true;
//			}else
//			{
//				loadSalute();
//			}
		}
		
		
		private var _saluteLoader:ModuleLoader;
		public function loadSalute():void
		{
			if(!saluteLoaded)
			{
				WaitingView.instance.show();
				WaitingView.instance.addEventListener(WaitingView.WAITING_CANCEL,saluteLoadCancel);
				_saluteLoader = LoaderManager.Instance.createLoader("Salute.swf",BaseLoader.MODULE_LOADER);
				_saluteLoader.addEventListener(ProgressEvent.PROGRESS,saluteProgress);
				_saluteLoader.addEventListener(LoaderEvent.COMPLETE,saluteComplete);
				LoaderManager.Instance.startLoad(this._saluteLoader);
			}
		}
		
		private function saluteLoadCancel(e:Event):void
		{
			WaitingView.instance.removeEventListener(WaitingView.WAITING_CANCEL,saluteLoadCancel);
			if(_saluteLoader)
			{
				_saluteLoader.removeEventListener(ProgressEvent.PROGRESS,saluteProgress);
				_saluteLoader.removeEventListener(LoaderEvent.COMPLETE,saluteComplete);
				_saluteLoader = null;
			}
			WaitingView.instance.hide();
		}
		
		public function get saluteLoaded ():Boolean
		{
			return ClassUtils.hasDefinition("ddt.church.fireAcect.Salute");
		}
		
		private function saluteProgress(e:ProgressEvent):void
		{
			WaitingView.instance.percent = Math.round((e.bytesLoaded/e.bytesTotal)*100);
		}
		
		private function saluteComplete(e:Event):void
		{
			ChurchRoomManager.instance.currentScene = true;
			saluteLoadCancel(null);
		}
//		private function __useSalute(event:MouseEvent):void
//		{
//			SoundManager.instance.play("008");
//			if(ChurchRoomManager.instance.isAdmin(PlayerManager.Instance.Self) && !ChurchRoomManager.instance.currentRoom.isUsedSalute)
//			{
//				_controler.setSaulte(PlayerManager.Instance.Self.ID);
//			}else
//			{
//				if(PlayerManager.Instance.Self.Money<500)
//				{
//					HConfirmDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.view.comon.lack"),true,LeavePage.leaveToFill,null);
//					return;
//				}
//				
//				var dialogue:DialogueUseSalute = new DialogueUseSalute(_controler);
//				TipManager.AddTippanel(dialogue,true);
//			}
//		}
		
		private function __hideClick(event:MouseEvent):void
		{
			SoundManager.Instance.play("008");
			switch(event.currentTarget)
			{
				case _showName:
				ChurchRoomManager.instance.isHideName = !ChurchRoomManager.instance.isHideName;
				_showName.gotoAndStop(ChurchRoomManager.instance.isHideName?1:2);
				break;
				case _showPao:
				ChurchRoomManager.instance.isHidePao = !ChurchRoomManager.instance.isHidePao;
				_showPao.gotoAndStop(ChurchRoomManager.instance.isHidePao?1:2);
				break;
				case _showFire:
				ChurchRoomManager.instance.isHideFire = !ChurchRoomManager.instance.isHideFire;
				_showFire.gotoAndStop(ChurchRoomManager.instance.isHideFire?1:2);
				break;
			}
		}

		/**
		 * 备份设置
		 */		
		public function backupConfig():void
		{
			hideConfigs[0] = ChurchRoomManager.instance.isHideName?1:0;
			hideConfigs[1] = ChurchRoomManager.instance.isHidePao?1:0;
			hideConfigs[2] = ChurchRoomManager.instance.isHideFire?1:0;
			
			ChurchRoomManager.instance.isHideName = true;
			ChurchRoomManager.instance.isHidePao = true;
			ChurchRoomManager.instance.isHideFire = true;
			
			_showName.gotoAndStop(1);
			_showPao.gotoAndStop(1);
			_showFire.gotoAndStop(1);
		}
		
		/**
		 * 还原设置
		 */		
		public function revertConfig():void
		{
			ChurchRoomManager.instance.isHideName = hideConfigs[0];
			ChurchRoomManager.instance.isHidePao = hideConfigs[1];
			ChurchRoomManager.instance.isHideFire = hideConfigs[2];
			
			_showName.gotoAndStop(ChurchRoomManager.instance.isHideName?1:2);
			_showPao.gotoAndStop(ChurchRoomManager.instance.isHidePao?1:2);
			_showFire.gotoAndStop(ChurchRoomManager.instance.isHideFire?1:2);
		}
		
		/** 
		 * 重置UI状态(切换场景) 
		 */		
		public function reset():void
		{
			if(ChurchRoomManager.instance.currentScene)
			{
				if(_tablet.parent)removeChild(_tablet);
				
				if(_enterMoonSceneBtn.parent)removeChild(_enterMoonSceneBtn);
				
//				addChild(_useSalute);
			}else
			{
				addChild(_tablet);
				
				if(ChurchRoomManager.instance.currentRoom.isStarted && ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_NONE)
				{
					addChild(_enterMoonSceneBtn);
				}else
				{
					if(_enterMoonSceneBtn.parent)removeChild(_enterMoonSceneBtn);
				}
//				if(_useSalute.parent)removeChild(_useSalute);
			}
		}
		
		private function setTablet():void
		{
			var t1:TextField = createTF(ChurchRoomManager.instance.currentRoom.groomName,0xDF0300);
			var t2:TextField = createTF(LanguageMgr.GetTranslation("yu"),0x000000);
			t2.x = t1.x + t1.width;
			var t3:TextField = createTF(ChurchRoomManager.instance.currentRoom.brideName,0xDF0300);
			t3.x = t2.x + t2.width;
			var t4:TextField = createTF(LanguageMgr.GetTranslation("dehunli"),0x000000);
			t4.x = t3.x + t3.width;
			 
			var s:Sprite = new Sprite();
			s.addChild(t1);
			s.addChild(t2);
			s.addChild(t3);
			s.addChild(t4);
			s.x = 5;
			s.y = 5;
			_tablet.addChild(s);
			
			setCenter();
		}
		
		private function createTF(str:String,color:int):TextField
		{
			_format.color = color;
			_format.bold = true;
			
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = str;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.filters = [new GlowFilter(0xffffff,1,2,2,100,1)]
			tf.setTextFormat(_format);
			
			return tf;
		}
		
		private function setCenter():void
		{
			_roomNameBG.width = _tablet.width+5;
			_tablet.x = 1000-_tablet.width -5;
			_tablet.y = 10;
		}
		
		public function dispose():void
		{
			removeEvent();
			DisposeUtils.disposeDisplayObject(_showName);
			_showName = null;
			DisposeUtils.disposeDisplayObject(_showPao);
			_showPao = null;
			DisposeUtils.disposeDisplayObject(_showFire);
			_showFire = null;
			DisposeUtils.disposeDisplayObject(_tablet);
			_tablet = null;
			DisposeUtils.disposeDisplayObject(_enterMoonSceneBtn);
			_enterMoonSceneBtn = null;
			if(this.parent)this.parent.removeChild(this);
		}
	}
}
