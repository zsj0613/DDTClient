package ddt.auctionHouse.view.vmenu
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VerticalMenu extends Sprite
	{
		private var tabWidth:Number;
		private var l1Width:Number;
		private var l2Width:Number;
		
		private var subMenus:Array;
		private var rootMenu:Array;
		
		public var currentItem:IMenuItem;
		
		public static const MENU_CLICKED:String = "menuClicked"
		public function VerticalMenu($tabWidth:Number,$l1Width:Number,$l2Width:Number)
		{
			super();
			tabWidth = $tabWidth;
			l1Width = $l1Width;
			l2Width = $l2Width;
			rootMenu = [];
			subMenus = [];
		}
		
		
		public function addItemAt($item:IMenuItem,parentIndex:int = -1):void
		{
			if(parentIndex == -1)
			{
				rootMenu.push($item);
				$item.addEventListener(MouseEvent.CLICK,rootMenuClickHandler);
			}
			else
			{
				if(!subMenus[parentIndex])
				{
					for(var i:uint = 0;i<=parentIndex;i++)
					{
						if(!subMenus[i])
						{
							subMenus[i] = [];
						}
					}
					
				}
				$item.x = tabWidth;
				$item.addEventListener(MouseEvent.CLICK,subMenuClickHandler);
				subMenus[parentIndex].push($item);
				
			}
			addChild($item as DisplayObject);
			closeAll();
			
		}
		
		public function closeAll():void
		{
			for(var i:uint = 0;i<rootMenu.length;i++)
			{
				rootMenu[i].y = i*l1Width;
				rootMenu[i].isOpen = false;
				rootMenu[i].enable = true;
			}
			
			for(var i1:uint = 0;i1<subMenus.length;i1++)
			{
				for(var i2:uint = 0;i2<subMenus[i1].length;i2++)
				{
					subMenus[i1][i2].visible = false;
				}
			}
			_height = rootMenu.length*l1Width
		}
		public function get $height():Number
		{
			return _height;
		}
		
		protected function rootMenuClickHandler(e:MouseEvent):void
		{
			if(currentItem !=null){
				currentItem.enable = true;
			}
			currentItem = e.currentTarget as IMenuItem;
			
			var _index:int = rootMenu.indexOf(currentItem);
			if(currentItem.isOpen)
			{
				closeAll();
				currentItem.enable = false;
				for(var i:uint = 0;i<subMenus.length;i++)
				{
					for(var j:uint = 0;j<subMenus[i].length;j++)
					{
						subMenus[i][j].enable = true;
					}
				}
			}
			else
			{
				closeAll();
				openItemByIndex(_index);
				dispatchEvent(new Event(MENU_CLICKED));
				currentItem.enable = false;
			}
			
			
			
		}
		
		private function closeItems() : void
		{
			
		}
		private var _height : int;
		private function openItemByIndex(index:uint):void
		{
			if(!subMenus[index]) return
			for(var i:uint = 0;i<rootMenu.length;i++)
			{
				if(i <= index)
				{
					rootMenu[i].y  = i*l1Width;
				}
				else
				{
					rootMenu[i].y  = i*l1Width+subMenus[index].length*l2Width;
				}
			} 
			for(var i1:uint = 0;i1<subMenus.length;i1++)
			{
				for(var i2:uint = 0;i2<subMenus[i1].length;i2++)
				{
					if(i1 ==index)
					{
						subMenus[i1][i2].visible = true;
						subMenus[i1][i2].enable = true;
						subMenus[i1][i2].y = (index+1)*l1Width+i2*l2Width;
					} else{
						subMenus[i1][i2].visible = false;
					}
				}
			}
			_height = rootMenu.length*l1Width + subMenus[index].length*l2Width;
			rootMenu[index].isOpen = true;
		}
		
		public function dispose ():void
		{
			if(rootMenu)
			{
				for(var i:uint = 0;i<rootMenu.length;i++){
					rootMenu[i].dispose();
					rootMenu[i].removeEventListener(MouseEvent.CLICK,rootMenuClickHandler);
				}
			}
			rootMenu = null;
			if(subMenus)
			{
				for(var i1:uint = 0;i1<subMenus.length;i1++)
				{
					for(var i2:uint = 0;i2<subMenus[i1].length;i2++)
					{
						subMenus[i1][i2].dispose();
						subMenus[i1][i2].removeEventListener(MouseEvent.CLICK,subMenuClickHandler);
					}
					
				}
			}
			
			subMenus = null;
			currentItem = null;
		}
		
		
//		private function myRemoveChild(child:DisplayObject):void
//		{
//			if(child.parent)
//			{
//				child.parent.removeChild(child);
//				child.removeEventListener(MouseEvent.CLICK,rootMenuClickHandler);
//			}
//		}
		
		protected function subMenuClickHandler(e:MouseEvent):void
		{
			if(currentItem == e.currentTarget) return;
			currentItem.enable = true;
			currentItem = e.currentTarget as IMenuItem;
			dispatchEvent(new Event(MENU_CLICKED));
		}
		
		
	}
}