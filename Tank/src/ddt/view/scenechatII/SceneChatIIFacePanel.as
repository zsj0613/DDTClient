package ddt.view.scenechatII
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.ChatFacePanelAsset;
	
	import road.comm.PackageOut;
	
	import ddt.data.socket.ePackageType;
	import ddt.manager.SocketManager;
	import road.manager.SoundManager;

	public class SceneChatIIFacePanel extends ChatFacePanelAsset
	{
		private var _selected:int;
		private var _inGame:Boolean;
		
		public function SceneChatIIFacePanel(inGame:Boolean = false)
		{
			_inGame = inGame;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
		}
		
		private function initEvent():void
		{
			for(var i:int = 1; i <= 48; i++)
			{
				if(i != 38)  //38是猪头表情，去掉此行，即启用猪头
					this["e0" + (i < 10 ? "0" + String(i) : String(i))].addEventListener(MouseEvent.CLICK,__itemClick)
			}
			this.addEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		private function __itemClick(evt:MouseEvent):void
		{
			_selected = int(evt.currentTarget.name.slice(2,4));
			if(_inGame)
			{
				SoundManager.instance.play("008");
				var pkg:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
				pkg.writeInt(_selected);
				SocketManager.Instance.out.sendPackage(pkg);
			}
			else
			{
				dispatchEvent(new Event(Event.SELECT));
			}
			setVisible(false);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 1; i <= 48; i++)
			{
				if(i != 38)
					this["e0" + (i < 10 ? "0" + String(i) : String(i))].removeEventListener(MouseEvent.CLICK,__itemClick)
			}
			removeEventListener(MouseEvent.CLICK,__mouseClick);
		}
		
		public function setVisible(b:Boolean):void
		{
			this.visible = b;
		}
		
		public function get selected():int
		{
			return _selected;
		}
		
		private function __mouseClick(evt:MouseEvent):void
		{
			setVisible(false);
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}