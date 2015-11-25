package ddt.manager
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import road.ui.manager.TipManager;
	
	import tank.commonII.asset.upgradeClewAsset;
	import ddt.data.Config;
	import ddt.data.player.PlayerPropertyEvent;
	import ddt.states.StateType;
	import ddt.view.chatsystem.ChatData;
	import ddt.view.chatsystem.ChatInputView;

	public class GradeExaltClewManager  extends Sprite
	{
		private var _asset :upgradeClewAsset;
		private var _stage : Stage;
		private var _grade:int;
		private static var instance : GradeExaltClewManager;
		private var isSteup:Boolean = false;
		public function GradeExaltClewManager()
		{
			
		}
		
		public static function getInstance():GradeExaltClewManager{
			if(instance == null){
				instance = new GradeExaltClewManager();
			}
			return instance;
		}
		
		public function steup() : void
		{
			if(isSteup)
			{
				return;
			}else
			{
				addEvent();
				isSteup = true;
			}
		}
		
		private function addEvent():void
		{
			PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE , __GradeExalt);
		}
		private function removeEvent():void
		{
			PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE , __GradeExalt);
		}
		
		private function __GradeExalt(e:PlayerPropertyEvent):void
		{
			if(e.changedProperties["Grade"] && PlayerManager.Instance.Self.IsUpdate)
			{
				if(e.target.Grade == _grade){
					return;
				}
				_grade = e.target.Grade;
				if(StateManager.currentStateType != StateType.FIGHTING)
				{
					show();
				}
				
			}
		}
			
		
		private function show():void
		{
			if(_asset)
			{
				if(_asset)_asset.removeEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
				if(_asset && _asset.parent)removeChild(_asset);
				_asset = null;
			}
			_asset = new upgradeClewAsset();
			x = (Config.GAME_WIDTH) / 2;
			y = (Config.GAME_HEIGHT) / 2 + 85;
			_asset.addEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
			addChild(_asset);
			_asset.gotoAndPlay(1);
			TipManager.AddTippanel(this);
			var chatMsg:ChatData = new ChatData();
			chatMsg.msg          = LanguageMgr.GetTranslation("ddt.manager.GradeExaltClewManager");
			chatMsg.channel	  = ChatInputView.SYS_NOTICE;
			ChatManager.Instance.chat(chatMsg);
		}
		
		private function end():void
		{
			_asset.gotoAndStop(_asset.totalFrames);
			hide();
		}
		
		private function __cartoonFrameHandler(event:Event):void
		{
			if(_asset == null)return;
			if(_asset.currentFrame == _asset.totalFrames)
			{
				end();
			}
		}
		
		public function hide():void
		{
			dispose();
			if(parent)
			{
				parent.mouseEnabled = true;
			}
			if(parent)
			{
				TipManager.RemoveTippanel(this);
			}
		}
		
		private function dispose():void
		{
			if(_asset)_asset.removeEventListener(Event.ENTER_FRAME,__cartoonFrameHandler);
			if(_asset && _asset.parent)removeChild(_asset);
			_asset = null;
		}
	}
}