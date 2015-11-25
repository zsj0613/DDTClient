package ddt.church.churchScene
{
	import ddt.church.churchScene.fire.FireView;
	import ddt.church.churchScene.frame.ModifyRoomInfoFrame;
	import ddt.church.churchScene.frame.SceneGuestListFrame;
	import ddt.church.churchScene.invite.ChurchInviteController;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	import road.loader.*;
	import road.manager.SoundManager;
	import road.utils.ClassUtils;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HConfirmDialog;
	import road.ui.manager.TipManager;
	
	import tank.church.SceneMenuAsset;
	import tank.church.StartTipMovie;
	import ddt.data.ChurchRoomInfo;
	import ddt.events.ChurchRoomEvent;
	import ddt.manager.ChurchRoomManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.utils.LeavePage;

	public class SceneMenu extends SceneMenuAsset
	{
		private const SHOW:String = "show";
		private const HIDE:String = "hide";
		private const SWITCHING:String = "switching";
		
		private var currentStatus:String = SHOW;
		private var showPos:Number = 0;
		private var hidePos:Number = 300;
		private var speed:Number = 5;
		
		private var _controler:SceneControler;
		private var _model:SceneModel;
		
		private var subMenuVisible:Boolean = false;
		
		private var _tipMovie:StartTipMovie;
		
		private var _guestList:SceneGuestListFrame;
		private var _invite:ChurchInviteController;
		private var _fireView:FireView;
		private var _modify:ModifyRoomInfoFrame;
		
		public function SceneMenu(controler:SceneControler,model:SceneModel)
		{
			this._controler = controler;
			this._model = model;
			
			init();
			addEvent();
		}
		
		private function init():void
		{
			loadFire();
			if(ChurchRoomManager.instance.isAdmin(PlayerManager.Instance.Self))
			{
				this.removeChild(inviteGuestBtn);
				churchManageBtn.x = temp_pos.x;
				churchManageBtn.y = temp_pos.y;
				
				_tipMovie = new StartTipMovie();
				_tipMovie.x = startWeddingBtn.x;
				_tipMovie.y = startWeddingBtn.y - _tipMovie.height;
				_tipMovie.mouseChildren = false;
				_tipMovie.mouseEnabled = false;
				addChild(_tipMovie);
				
				if(PlayerManager.Instance.Self.ID != ChurchRoomManager.instance.currentRoom.createID)
				{
					setButtnEnable(modifyBtn,false);
				}
				
				swicthSubMenuVisible();
			}else
			{
				this.removeChild(churchManageBtn);
				this.removeChild(menuBbg);
				this.removeChild(startWeddingBtn);
				this.removeChild(inviteGuestBBtn);
				this.removeChild(guestListBtn);
				this.removeChild(continuationBtn);
				this.removeChild(modifyBtn);
				
				inviteGuestBtn.x = temp_pos.x;
				inviteGuestBtn.y = temp_pos.y;
				
				if(!ChurchRoomManager.instance.currentRoom.canInvite)
				{
					setButtnEnable(inviteGuestBtn,false);
				}
			}
			if(ChurchRoomManager.instance.currentScene == true)
			{
				leaveBtn.visible = false;
				exitBtn.visible  = true;
			}else
			{
				leaveBtn.visible = true;
				exitBtn.visible  = false;
			}
			this.removeChild(temp_pos);
			this.switchTip.mouseEnabled = false;
			switchTip.stop();
			
		}
		
		private function swicthSubMenuVisible():void
		{
			subMenuVisible = !subMenuVisible;
			menuBbg.visible = subMenuVisible;
			startWeddingBtn.visible = subMenuVisible;
			inviteGuestBBtn.visible = subMenuVisible;
			guestListBtn.visible = subMenuVisible;
			continuationBtn.visible = subMenuVisible;
			modifyBtn.visible = subMenuVisible;
			
			if(_tipMovie&&!ChurchRoomManager.instance.currentScene)_tipMovie.visible = subMenuVisible;
		}
		
		private function addEvent():void
		{
			for(var i:uint;i<this.numChildren;i++)
			{
				var obj:DisplayObject = this.getChildAt(i);
				if(obj.name.indexOf("Btn"))
				{
					obj.addEventListener(MouseEvent.CLICK,__menuClick);
				}
			}
			
			ChurchRoomManager.instance.currentRoom.addEventListener(ChurchRoomEvent.WEDDING_STATUS_CHANGE,__weddingStatusChange);
			ChurchRoomManager.instance.addEventListener(ChurchRoomEvent.SCENE_CHANGE ,__updateBtn);
			ChurchRoomManager.instance.addEventListener(ChurchRoomEvent.SCENE_CHANGE ,__updateBtn);
		}
		
		private function removeEvent():void
		{
			removeEventListener(Event.ENTER_FRAME,__hide);
			for(var i:uint;i<this.numChildren;i++)
			{
				var obj:DisplayObject = this.getChildAt(i);
				if(obj.name.indexOf("Btn"))
				{
					obj.removeEventListener(MouseEvent.CLICK,__menuClick);
				}
			}
			
			ChurchRoomManager.instance.currentRoom.removeEventListener(ChurchRoomEvent.WEDDING_STATUS_CHANGE,__weddingStatusChange);
			ChurchRoomManager.instance.currentRoom.removeEventListener(ChurchRoomEvent.SCENE_CHANGE ,__updateBtn);
		}
		
		private function __weddingStatusChange(event:ChurchRoomEvent):void
		{
			switchWeddingStatus();
		}
		/**
		 * 设置婚礼中的按钮状态 
		 */				
		private function switchWeddingStatus():void
		{
			if(ChurchRoomManager.instance.currentScene)return;
			
			if(_tipMovie)
			{
				removeChild(_tipMovie);
				_tipMovie = null;
			}
			
			var status:String = ChurchRoomManager.instance.currentRoom.status;
			
			if(status == ChurchRoomInfo.WEDDING_ING)
			{
				if(startWeddingBtn)setButtnEnable(startWeddingBtn,false);
				if(inviteGuestBBtn)setButtnEnable(inviteGuestBBtn,false);
				if(inviteGuestBtn)setButtnEnable(inviteGuestBtn,false);
				if(useFireBtn)setButtnEnable(useFireBtn,false);
				
				if(_fireView&&_fireView.parent)
				{
					_fireView.parent.removeChild(_fireView);
				}
				
//				if(guestListBtn)setButtnEnable(guestListBtn,false);
//				
//				if(_guestList&&_guestList.parent)
//				{
//					_guestList.parent.removeChild(_guestList);
//				}
				
				if(exitBtn)setButtnEnable(exitBtn,false);
//				if(leaveBtn)setButtnEnable(leaveBtn,false);
			}else
			{
				if(startWeddingBtn)setButtnEnable(startWeddingBtn,true);
				if(inviteGuestBBtn)setButtnEnable(inviteGuestBBtn,true);
				if(inviteGuestBtn)setButtnEnable(inviteGuestBtn,true);
				if(useFireBtn)setButtnEnable(useFireBtn,true);
				if(exitBtn)setButtnEnable(exitBtn,true);
				if(leaveBtn)setButtnEnable(leaveBtn,true);
			}
		}
		
		private function __updateBtn(evt:ChurchRoomEvent):void
		{
			if(ChurchRoomManager.instance.currentScene == true)
			{
				leaveBtn.visible = false;
				exitBtn.visible  = true;
			}else
			{
				leaveBtn.visible = true;
				exitBtn.visible  = false;
			}
		}
		
		public function set leaveBtnEnable(value:Boolean):void
		{
			if(leaveBtn)setButtnEnable(leaveBtn,value);
		}
		
		/**
		 * 重置菜单状态(切换场景) 
		 */		
		public function reset():void
		{
			var currentScene:Boolean = ChurchRoomManager.instance.currentScene;
			
			if(startWeddingBtn)setButtnEnable(startWeddingBtn,!currentScene);
			if(_tipMovie)_tipMovie.visible = (!currentScene&&subMenuVisible);
		}
		
		private function __menuClick(event:MouseEvent):void
		{
			switch((event.currentTarget as DisplayObject).name)
			{
				case "churchManageBtn":
					SoundManager.instance.play("008");
					swicthSubMenuVisible();
				break;
				case "startWeddingBtn":
					if(startWeddingBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					HConfirmDialog.show(LanguageMgr.GetTranslation("ddt.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("are.you.sure.to.marry"),true,startWedding);
				break;
				case "continuationBtn":
					SoundManager.instance.play("008");
					_controler.continuation();
				break;
				case "guestListBtn":
					SoundManager.instance.play("008");
					switchVisibleGuestList();
				break;
				case "inviteGuestBBtn":
					if(inviteGuestBBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					switchVisibleInvite();
				break;
				case "inviteGuestBtn":
					if(inviteGuestBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					switchVisibleInvite();
				break;
				case "presentBtn":
					SoundManager.instance.play("008");
					_controler.present();
				break;
				case "useFireBtn":
					if(useFireBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					switchVisibleFireList();
				break;
				case "fillBtn":
					LeavePage.leaveToFill();
				break;
				case "exitBtn":
					if(exitBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					exit();
				break;
				case "leaveBtn":
					if(leaveBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					HConfirmDialog.show("提示","是否确定离开当前婚礼房间",true,_exit);
//					StateManager.setState(StateType.CHURCH_ROOMLIST);
					break;
				case "switchBtn":
					SoundManager.instance.play("008");
					switchMenuStatus();
				break;
				case "modifyBtn":
					if(modifyBtn.enabled == true)
					{
						SoundManager.instance.play("008");
					}
					switchModifyVisible();
				break;
				default:
				break;
			}
		}
		
		private function _exit():void
		{
			exit();
		}
		
		private function exit():void
		{
			if(ChurchRoomManager.instance.currentScene&&ChurchRoomManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_NONE)
			{
				ChurchRoomManager.instance.currentScene = false;
			}else
			{
				StateManager.setState(StateType.CHURCH_ROOMLIST);
			}
		}
		
		private function startWedding():void
		{
			_controler.startWedding();
		}

		private function setButtnEnable(obj:SimpleButton,value:Boolean):void
		{
			obj.enabled = value;
			obj.mouseEnabled = value;
			obj.filters = value?[]:[new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0])];
		}
		
		private function switchMenuStatus():void
		{
			switch(currentStatus)
			{
				case SHOW:
				addEventListener(Event.ENTER_FRAME,__hide);
				currentStatus = SWITCHING;
				switchTip.gotoAndStop(2);
				break;
				case HIDE:
				addEventListener(Event.ENTER_FRAME,__show);
				currentStatus = SWITCHING;
				switchTip.gotoAndStop(1);
				break;
				case SWITCHING:
				break;
			}
		}
		
		private function __hide(event:Event):void
		{
			this.x += (hidePos - this.x)/speed;
			if(Math.abs(this.x - hidePos)<=1)
			{
				this.x = hidePos;
				removeEventListener(Event.ENTER_FRAME,__hide);
				currentStatus = HIDE;
			}
		}
		
		private function __show(event:Event):void
		{
			this.x += (showPos - this.x)/speed;
			if(Math.abs(this.x - showPos)<=1)
			{
				this.x = showPos;
				removeEventListener(Event.ENTER_FRAME,__show);
				currentStatus = SHOW;
			}
		}
		
		private function switchModifyVisible():void
		{
			if(!_modify)
			{
				_modify = new ModifyRoomInfoFrame(_controler);
			}
			
			if(_modify.parent)
			{
				_modify.parent.removeChild(_modify);
			}else
			{
				TipManager.clearTipLayer();
				TipManager.AddTippanel(_modify,true);
			}
		}
		
		private function switchVisibleGuestList():void
		{
			if(!_guestList)
			{
				_guestList = new SceneGuestListFrame(_model.getPlayers());
			}
			
			if(_guestList.parent)
			{
				_guestList.parent.removeChild(_guestList);
			}else
			{
				_guestList.x = 770;
				_guestList.y = 65;
				if(ChurchRoomManager.instance.currentRoom.status != ChurchRoomInfo.WEDDING_ING)TipManager.clearTipLayer();
				TipManager.AddTippanel(_guestList,false);
			}
		}
		
		private function switchVisibleInvite():void
		{
			if(_invite == null)
			{
				_invite = new ChurchInviteController();
			}
			if(_invite.getView().parent)
			{
				_invite.getView().parent.removeChild(_invite.getView());
			}
			else
			{
				_invite.refleshList(0);
				TipManager.clearTipLayer();
				TipManager.AddTippanel(_invite.getView(),true);			
			}
		}
		private function switchVisibleFireList():void
		{
			if(!fireLoaded)
			{
				HAlertDialog.show(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.churchScene.SceneUI.switchVisibleFireList"));
				//HAlertDialog.show("提示：","烟花资源正在加载中！请稍候");
				return; 
			}
			if(!_fireView)
			{
				_fireView = new FireView(_controler);
			}
			
			if(_fireView.parent)
			{
				_fireView.parent.removeChild(_fireView);
			}else
			{
				_fireView.x = 855;
				_fireView.y = 240;
				TipManager.clearTipLayer();
				TipManager.AddTippanel(_fireView,false);
			}
		}
		
		private var _fireLoader:ModuleLoader;
		public function loadFire():void
		{
			if(!fireLoaded)
			{
				_fireLoader =  LoaderManager.Instance.createLoader("Catharine.swf",BaseLoader.MODULE_LOADER);
			}
		}
		public function get fireLoaded ():Boolean
		{
			return ClassUtils.hasDefinition("ddt.church.fireAcect.FireItemAccect02");
		}
		public function dispose():void
		{
			removeEvent();
			_model = null;
			_controler = null;
			if(parent)parent.removeChild(this); 
		}
	}
}