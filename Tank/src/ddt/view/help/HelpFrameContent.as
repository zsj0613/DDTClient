package ddt.view.help
{
	import flash.display.Sprite;
	
	import ddt.view.HAccordion.AccordionStrip;
	import ddt.view.HAccordion.HAccordion;
	import tank.view.help.HelpItemAsset1;
	
	public class HelpFrameContent extends Sprite
	{
		private var _content:HAccordion;
		public function HelpFrameContent()
		{
			super();
			_content = new HAccordion([new AccordionStrip(null,"1.怎样进行战斗",true),
										new AccordionStrip(null,"2.快速升级的方法",true),
										new AccordionStrip(null,"3.怎样添加好友",true),
										new AccordionStrip(null,"4.装备到期后如何继续使用",true),
										new AccordionStrip(null,"5.游戏币的获得途径",true),
										new AccordionStrip(null,"6.如何变得更强（强化，镶嵌，合成，熔炼）",true),
										new AccordionStrip(null,"7.如何改变形象",true),
										new AccordionStrip(null,"8.创建竞技房间",true),
										new AccordionStrip(null,"9.如何加入公会。",true),
										new AccordionStrip(null,"10.副本如何进行",true)]);
			_content.setSize(440,450);
			addChild(_content);
			addChildNode();
		}
		
		private function addChildNode():void
		{
			var childItem1:AccordionStrip = new AccordionStrip(new LittleHelpItem(new HelpItemAsset1(),__fightHelp));
			_content.addChildNodeAt(childItem1,0);
		}
		
		private function __fightHelp():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
	}
}