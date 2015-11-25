package ddt.view.chatsystem
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import game.crazyTank.view.chat.ChannelSelectBGAccect;
	
	import road.manager.SoundManager;
	public class ChatChannelListView extends ChannelSelectBGAccect
	{
		private const chanelMap:Object={bt0:0,bt1:1,bt2:2,bt3:3,bt4:4,bt5:5,bt6:12};
		public function ChatChannelListView()
		{
			init();
		}
		
		private function __itemClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.play("008");
			var currentChannel:int = int(chanelMap[(e.currentTarget as SimpleButton).name]);
			dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,currentChannel));
		}
		
		private function __selectedComplete(event:MouseEvent):void
		{
			visible = false;
		}
		
		private function init():void
		{
			graphics.beginFill(0xffffff,0);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
			for(var i:uint = 0;i<7;i++)
			{
				this["bt"+i].addEventListener(MouseEvent.CLICK,__itemClickHandler);
			}
			visible = false;
			addEventListener(MouseEvent.CLICK,__selectedComplete);
		}
	}
}