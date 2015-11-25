package ddt.view.help
{
	import road.ui.controls.hframe.HConfirmFrame;
	import road.ui.controls.hframe.HFrame;
	
	public class LittleHelpFrame extends HFrame
	{
		private var content:HelpFrameContent;
		public function LittleHelpFrame()
		{
			super();
			showBottom = false;
			autoDispose = true;
			setSize(490,500);
			content = new HelpFrameContent();
			content.x=20;
			content.y=35;
			addContent(content);
		}
		
		override public function dispose():void
		{
			content.dispose();
			content = null;
			super.dispose();
		}
	}
}