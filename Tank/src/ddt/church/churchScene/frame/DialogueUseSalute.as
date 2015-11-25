package ddt.church.churchScene.frame
{
	import ddt.church.churchScene.SceneControler;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HConfirmFrame;
	
	import tank.church.DialogueOfSaluteAsset;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.utils.DisposeUtils;

	public class DialogueUseSalute extends HConfirmFrame
	{
		private var _asset:DialogueOfSaluteAsset;
		private var _controler:SceneControler;
		
		public function DialogueUseSalute(controler:SceneControler)
		{
			super();
			this._controler = controler;
			
			showCancel = true;

			okFunction = __okClick;
			okLabel = LanguageMgr.GetTranslation("ranfang");
			//okLabel = "燃 放";
			
			setContentSize(295,150);
			configUI();
		}
		private function configUI():void
		{
			_asset = new DialogueOfSaluteAsset();
			addContent(_asset);
		}
		
		private function __okClick(evt:MouseEvent = null):void
		{
			SoundManager.instance.play("008");
			
			//燃放礼炮
			_controler.setSaulte(PlayerManager.Instance.Self.ID);
			
			hide();
		}
		
		override protected function __onKeyDownd(e:KeyboardEvent):void
		{
			e.stopImmediatePropagation();
			if(e.keyCode == Keyboard.ESCAPE)
			{
				if(cancelBtn.enable)
				{
					SoundManager.instance.play("008");
					if(cancelFunction != null)
					{
						cancelFunction();
					}else
					{
						close();
					}
				}
			}else if(e.keyCode == Keyboard.ENTER)
			{
				__okClick(null);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			DisposeUtils.disposeDisplayObject(_asset);
			if(parent)parent.removeChild(this);
		}
	}
}