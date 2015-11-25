package ddt.view.im
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	
	import game.crazyTank.view.common.LoadingAsset;
	import game.crazyTank.view.common.SexIconAsset;
	import game.crazyTank.view.im.CommunityItemAsset;
	import game.crazyTank.view.im.Defaultavater;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HFrameButton;
	import road.utils.ComponentHelper;
	import road.utils.StringHelper;
	
	import ddt.data.player.FriendListPlayer;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import ddt.utils.ComponentHelperII;
	import ddt.view.common.LevelIcon;
	
	public class CMFriendItem extends CommunityItemAsset
	{
		private var _info:Object;
		private var _personalHomePageBtn : HFrameButton;
		private var _addFriendBtn : HFrameButton;
		private var _inviteBtn: HFrameButton;
		private var _photoloading:LoadingAsset; // x:20		y:23
		private var _loader:Loader;
		private var _imageData:BitmapData;
		private var _levelIcon:LevelIcon;
		public static var ALL_TRYTIME:int = 3;
		private var defAvater:Defaultavater;
		private var imageContainer:Sprite;
		private var _sex_mc:SexIconAsset;
		
		private var _isExpand:Boolean;
		
		public var photoLoaded:Boolean = false;
		public function get Selected():Boolean
		{
			return lighthight_mc.visible;
		}
		
		public function set Selected(value:Boolean):void
		{
			lighthight_mc.visible = value;
		}
		
		public function get info():Object
		{
			return _info;
		}
		
		public function get AddFriendBtn():HFrameButton
		{
			return _addFriendBtn;
		}
		
		public function CMFriendItem(info:Object)
		{
			_info = info;
			super();
			init();
			initEvent();
		}
		private function init():void
		{
			this.buttonMode = true;
			// 初始化图片加载器
			_loader = new Loader();
			// 初化始图像
			_imageData = new BitmapData(45,45);
			// 初始化为未高亮状态
			lighthight_mc.visible = false;
			over_mc.visible = false;
			// 添加等待加载社区头像动画
			_photoloading = new LoadingAsset();
			_photoloading.x = 11;
			_photoloading.y = 1;
			addChild(_photoloading);
			
			var __info:FriendListPlayer;
			
			for each(__info in PlayerManager.Instance.friendList)
			{
//				trace(__info.LoginName);
				if(__info.LoginName == _info.UserName)
				{
//					_addFriendBtn.enable = false; 
//					_addFriendBtn.buttonMode = false;
//					_inviteBtn.visible = false;
					break;
				}
			}
			
			// 显示名称
			this.communityname_txt.text = _info.OtherName;
			this.gamenickname_txt.text = _info.NickName;
			
			_sex_mc=new SexIconAsset()
			if(_info.sex)
			{
				_sex_mc.gotoAndStop(1);
			}else
			{
				_sex_mc.gotoAndStop(2);
			}
			
			
			
			if(!_info.IsExist)
			{
				this.communityname_txt.y += 12;
				//this.gamenick_lab.visible = false;
				removeChild(level_pos);
				removeChild(sexl_pos);
				
			}else
			{
				ComponentHelperII.replaceChildPostion(level_pos,_levelIcon=new LevelIcon("s",_info.level,0,0,0,0,false));
				ComponentHelperII.replaceChildPostion(sexl_pos,_sex_mc);
			}
			this.communityname_txt.mouseEnabled = false;
			this.gamenickname_txt.mouseEnabled = false;
		}
		
		private function initEvent():void
		{
//			_personalHomePageBtn.addEventListener(MouseEvent.CLICK, __jumpToWebPage);
//			if(_addFriendBtn.enable)
//			{
//				_addFriendBtn.addEventListener(MouseEvent.CLICK, __addFriendHandler);
//			}
//			if(_inviteBtn.enable)
//			{
//				_inviteBtn.addEventListener(MouseEvent.CLICK, __inviteClickHandler);
//			}
		}
		
		private function __headOver(e:Event):void
		{
			over_mc.visible=true;
		}
		private function __headOut(e:Event):void
		{
			over_mc.visible=false;
		}
		
		private function __inviteClickHandler(e:MouseEvent):void
		{
//			trace("邀请");
			MessageTipManager.getInstance().show("已通过社区消息发送邀请");
			SoundManager.instance.play("008");
			if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
			{
				var req:URLRequest = new URLRequest(PathManager.CommunityInvite());
				
				var data:URLVariables = new URLVariables();
				
				data["fuid"] = String(PlayerManager.Instance.Self.LoginName);// from uid
				data["fnick"] = PlayerManager.Instance.Self.NickName; // from nickname
				data["tuid"] =_info.UserName;  // to uid
				data["serverid"] = String(ServerManager.Instance.AgentID);  // server ID
				data["rnd"] = Math.random(); // 随机数
				
				req.data = data;
				
				var loader:URLLoader = new URLLoader(req);
				loader.load(req);
//				MessageTipManager.getInstance().show("操作成功");
			}
		}
		private var _loaderContext:LoaderContext;
		public function sendRequest():void
		{
			_loaderContext = new LoaderContext(true);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, __statusChange);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,__error);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onComplete);
			_loader.load(new URLRequest(_info.Photo),_loaderContext);
		}
		
		private function __statusChange(e:HTTPStatusEvent):void
		{
			if(e.status >= 400)
			{
				__error(e);
			}
		}
		
		private var tryTime:int = 0;
		private function __error(e:Event):void
		{
			tryTime++;
			if(tryTime == ALL_TRYTIME)
			{
				if(_photoloading.parent)_photoloading.parent.removeChild(_photoloading);
				_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, __statusChange);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,__error);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __onComplete);
				photoLoaded = true;
				defAvater = new Defaultavater();
				defAvater.x = avatar_mc.x;
				defAvater.y = avatar_mc.y;
				defAvater.addEventListener(MouseEvent.CLICK, __avatarClickHandler);
				addChild(defAvater);
				dispatchEvent(new Event(Event.COMPLETE));
			}else
			{
				sendRequest();
			}
		}
		
		private function __onComplete(e:Event):void
		{
			imageContainer = new Sprite();
			imageContainer.x = avatar_mc.x;
			imageContainer.y = avatar_mc.y;
			imageContainer.addEventListener(MouseEvent.CLICK, __avatarClickHandler);
			imageContainer.addChild(_loader);
			imageContainer.buttonMode = true;
			imageContainer.scaleX = (45/imageContainer.width);
			imageContainer.scaleY = (45/imageContainer.height);
			imageContainer.addEventListener(MouseEvent.ROLL_OVER,__headOver);
			imageContainer.addEventListener(MouseEvent.ROLL_OUT,__headOut);
			if(_photoloading.parent)_photoloading.parent.removeChild(_photoloading);
			addChild(imageContainer);
			photoLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function __avatarClickHandler(e:MouseEvent):void
		{
//			trace("头像点击");
//			SoundManager.instance.play("008");
//			dispatchEvent(new Event(Event.CHANGE));
//			if(StringHelper.isNullOrEmpty(_info.PersonWeb))
//			{
//				return;
//			}
//			navigateToURL(new URLRequest(_info.PersonWeb));
		}

		private function __jumpToWebPage(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			navigateToURL(new URLRequest(_info.PersonWeb));
		}
		
		private function __addFriendHandler(e:MouseEvent):void
		{
//			SocketManager.Instance.out.sendAddFriend(_info.NickName,0);
			SoundManager.instance.play("008");
			IMController.Instance.addFriend(_info.NickName);
		}
		
		public function disAbleAdd():void
		{
//			_addFriendBtn.enable = false;
		}
		
		public function dispose():void
		{
			if(_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, __statusChange);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,__error);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,__onComplete);
				_loader.unload();
				_loader = null;
			}
			_loaderContext = null;
//			_personalHomePageBtn.removeEventListener(MouseEvent.CLICK, __jumpToWebPage);
//			_personalHomePageBtn.parent.removeChild(_personalHomePageBtn);
//			_personalHomePageBtn.dispose();
//			_personalHomePageBtn = null;
//			_addFriendBtn.removeEventListener(MouseEvent.CLICK, __addFriendHandler);
//			_inviteBtn.removeEventListener(MouseEvent.CLICK, __inviteClickHandler);
		}
	}
}