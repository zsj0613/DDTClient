package ddt.loginstate
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.SimpleGrid;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	import road.utils.ComponentHelper;
	
	import tank.loading.ChooeseRoleAsset;
	import ddt.manager.LanguageMgr;

	public class ChooeseRoleFrame extends HFrame
	{
		private var asset:ChooeseRoleAsset;
		private var _roleList:SimpleGrid;
		private var selectedInfo:Object;
		private var goIntoGameBtn:HBaseButton;
		
		public function ChooeseRoleFrame()
		{
			super();
			setSize(376,385);
			init();
		}
		
		private function init():void
		{
			titleText = LanguageMgr.GetTranslation("ddt.loginstate.chooseCharacter");
			centerTitle = true;
			showClose = false;
			showBottom = false;
			asset = new ChooeseRoleAsset();
			asset.x = 12;
			asset.y = 34;
			addChild(asset);
			_roleList = new SimpleGrid(313,68);
			_roleList.horizontalScrollPolicy = "off";
			ComponentHelper.replaceChild(asset,asset.list_pos,_roleList);
			goIntoGameBtn = new HBaseButton(asset.goinGameBtnAsset,"");
			goIntoGameBtn.useBackgoundPos = true;
			asset.addChild(goIntoGameBtn);
			goIntoGameBtn.addEventListener(MouseEvent.CLICK,goIntoGame);
		}
		
		public function drawBlack():void
		{
			graphics.beginFill(0x000000,0.5);
			graphics.drawRect(-3000,-3000,6000,6000);
			graphics.endFill();
		}
		
		public function goIntoGame(e:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			if(selectedInfo.Rename || selectedInfo.ConsortiaRename)
			{
				var modifyNameFrame:ModifyNameFrame
				if(selectedInfo.Rename && !selectedInfo.NameChanged)
				{
					modifyNameFrame = new ModifyNameFrame(selectedInfo);
					modifyNameFrame.x = (1000-modifyNameFrame.width)/2;
					modifyNameFrame.y = (600-modifyNameFrame.height)/2;
					modifyNameFrame.addEventListener(Event.COMPLETE,modifyComplete);
					modifyNameFrame.state = ModifyNameFrame.NICKNAME_MODIFY;
					TipManager.addToStageLayer(modifyNameFrame);
					return;
				}
				
				if(selectedInfo.ConsortiaRename && !selectedInfo.ConsortiaNameChanged)
				{
					modifyNameFrame = new ModifyNameFrame(selectedInfo);
					modifyNameFrame.x = (1000-modifyNameFrame.width)/2;
					modifyNameFrame.y = (600-modifyNameFrame.height)/2;
					modifyNameFrame.addEventListener(Event.COMPLETE,modifyComplete);
					modifyNameFrame.state = ModifyNameFrame.GUILD_MODIFY;
					TipManager.addToStageLayer(modifyNameFrame);
					return;
				}
				dispatchEvent(new Event(Event.COMPLETE));
				
			}else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function modifyComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,modifyComplete);
			if(selectedInfo.ConsortiaNameChanged && selectedInfo.NameChanged)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}else
			{
				goIntoGame(null);
			}
		}
		
		public function set info(roles:Array):void
		{
			for(var i:int = 0;i< roles.length;i++)
			{
				var item:ChooeseRoleItem = new ChooeseRoleItem(roles[i]);
				_roleList.appendItem(item);
				item.addEventListener(Event.SELECT,selecteChanged);
			}
			selectedInfo = roles[0];
			_roleList.items[0].selected = true;
		}
		
		private function selecteChanged(e:Event):void
		{
			for(var i:int = 0;i<_roleList.itemCount;i++)
			{
				_roleList.items[i].selected = false;
			}
			e.target.selected = true;
			selectedInfo = e.target.info;
		}
		
		public function get LoginNickName ():String
		{
			return selectedInfo.NickName;
		}
		
		override public function dispose ():void
		{
			graphics.clear();
			for(var i:int = 0;i<_roleList.itemCount;i++)
			{
				_roleList.items[i].dispose();
			}
			goIntoGameBtn.removeEventListener(MouseEvent.CLICK,goIntoGame);
			asset.removeChild(goIntoGameBtn);
			goIntoGameBtn.dispose();
			goIntoGameBtn = null;
			_roleList.clearItems();
			_roleList = null;
			super.dispose();
		}
		
	}
}