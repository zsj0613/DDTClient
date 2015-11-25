package ddt.gameover.torphy
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.HButton.HBaseButton;
	import road.ui.controls.HButton.HLabelButton;
	import road.ui.controls.hframe.HFrame;
	import road.ui.manager.TipManager;
	
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.states.StateType;
	import ddt.view.bagII.BagIIController;
	
	import webgame.crazytank.game.view.TrophyPannelAsset;
	

	public class TrophyPannelView extends HFrame
	{
		private var _model:TrophyModel;
		private var _controller:ITropyController;
		private var _countDown:TrophyCountDownView;
		private var _trophy:TrophyView;
		private var _bag:BagIIController;
		
		private var _confirm_btn : HBaseButton;
		
		private var asset:TrophyPannelAsset;
		
		public function TrophyPannelView(controller:ITropyController,model:TrophyModel)
		{
			super();
			_model = model;
			_controller = controller;
			initView();
			initEvent();
			_trophy.infos = PlayerManager.Instance.Self.TempBag.items.list;
			
		}
		public function showView():void{
			TipManager.AddTippanel(this);
		}
		override public function dispose():void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TAKE_TEMP,__onTempResult);
			TipManager.RemoveTippanel(this);
			PlayerManager.Instance.Self.unlockAllBag();
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			if(_trophy)
			{
				_trophy.dispose();
				_trophy = null;
			}
			if(_bag)
			{
				_bag.dispose();
				_bag = null;
			}
			_model = null;
			moveEnable = false;
			if(_confirm_btn)
			{
				_confirm_btn.removeEventListener(MouseEvent.CLICK,__confirm);
				_confirm_btn.dispose();
				_confirm_btn = null;
			}
			
			if(parent)
			{
				parent.removeChild(this);
			}
			super.dispose();
		}
		
		public function update():void
		{
			var dic:DictionaryData = PlayerManager.Instance.Self.TempBag.items;
			_trophy.infos = dic.list;
		}
		
		private function initView():void
		{
			asset = new TrophyPannelAsset();
			setSize(716,540);
			mouseEnabled = false;
			blackGound = true;
			alphaGound = true;
			fireEvent = false;
			showClose = false;
			showBottom = true;
			moveEnable = false;
			
//			var back:PopUpBackAsset = new PopUpBackAsset();
//			addChildAt(back,0);
			
			addChildAt(asset,0);
			_confirm_btn = new HLabelButton();
			_confirm_btn.label = LanguageMgr.GetTranslation("ok");
			_confirm_btn.x = 562;
			_confirm_btn.y = 498;
//			_confirm_btn.useBackgoundPos = true;
			addChild(_confirm_btn);
			
			
			
			asset.bagPos.visible = false;
			_bag = new BagIIController(PlayerManager.Instance.Self);
			_bag.setCellDoubleClickEnable(false);
			_bag.getView().x = asset.bagPos.x;
			_bag.getView().y = asset.bagPos.y;
			_bag.setBagType(1);
			addChild(_bag.getView() as Sprite);	
			asset.trophyPos.visible = false;
			_trophy = new TrophyView();
			addChild(_trophy);
			_trophy.x = asset.trophyPos.x;
			_trophy.y = asset.trophyPos.y;
			update();
			
			asset.countDownPos.visible = false;
			_countDown = new TrophyCountDownView(_controller);
			_countDown.visible = false;
			_countDown.x = asset.countDownPos.x;
			_countDown.y = asset.countDownPos.y;
			addChild(_countDown);
			_countDown.startCountDown();
			
		}
	
		private function initEvent():void
		{
			_confirm_btn.addEventListener(MouseEvent.CLICK,__confirm);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_TEMP,__onTempResult);
		}
		private function __onTempResult(evt:CrazyTankSocketEvent):void{
			var result:Boolean = evt.pkg.readBoolean();
			if(result && PlayerManager.Instance.Self.TempBag.items.list.length == 0){
				__confirm(null);
			}
		}
		private function __confirm(event:MouseEvent):void
		{
			SoundManager.instance.play("008");
			if(StateManager.currentStateType != StateType.MISSION_RESULT)
			{
				StateManager.setState(PlayerManager.gotoState);
			} 
			_controller.dispose();
		}
	}
}