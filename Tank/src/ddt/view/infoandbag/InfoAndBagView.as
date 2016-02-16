package ddt.view.infoandbag
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.infoandbag.InfoAndBagBgAsset;
	
	import org.aswing.KeyboardManager;
	
	import road.data.DictionaryData;
	import road.manager.SoundManager;
	import road.ui.controls.hframe.HAlertDialog;
	import road.ui.controls.hframe.HFrame;
	
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.interfaces.IAcceptDrag;
	import ddt.manager.DragManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.UserGuideManager;
	import ddt.view.DownloadingView;
	import ddt.view.ReworkNameView;
	import ddt.view.bagII.BagIIController;
	import ddt.view.bagII.BagIIView;
	import ddt.view.bagII.IBagIIController;
	import ddt.view.bagII.bagStore.BagStore;
	import ddt.view.cells.DragEffect;
	import ddt.view.personalinfoII.IPersonalInfoIIController;
	import ddt.view.personalinfoII.PersonalInfoIIController;
	import ddt.view.personalinfoII.PersonalInfoIIView;

	public class InfoAndBagView extends InfoAndBagBgAsset implements IAcceptDrag
	{
		private var _bg:HFrame;
		private var _bag:IBagIIController;
		private var _infocontroller:IPersonalInfoIIController;
		private var _info:PlayerInfo;
		private var _controller:InfoAndBagController;
		public var bagCells:Array;//背包物品列表(物品格子)
		
//		private var ok_btn:HBaseButton;
		
		public function InfoAndBagView(controller:InfoAndBagController,info:PlayerInfo)
		{
			_controller = controller;
			_info = info;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_bg = new HFrame();
			_bg.blackGound = false;
			_bg.alphaGound = false;
			_bg.fireEvent = false;
			_bg.moveEnable = false;
			_bg.showBottom = false;
			_bg.setSize(859,498);
			_bg.y = 4;
			_bg.closeCallBack = __okClick;
			addChildAt(_bg,0);
			bag_pos.visible = info_pos.visible = false;
		
			_infocontroller = new PersonalInfoIIController(_info,true);
			_infocontroller.getView().x = info_pos.x;
			_infocontroller.getView().y = info_pos.y;
			addChild(_infocontroller.getView());
			
			_bag = new BagIIController(_info);
			_bag.getView().x = bag_pos.x;
			_bag.getView().y = bag_pos.y;
			addChild(_bag.getView());
			bagCells=(_bag as BagIIController).getBagCells();
			
//			ok_btn = new HBaseButton(okBtnAccect);
//			ok_btn.useBackgoundPos = true;
//			addChild(ok_btn);
		}
		
		public function set blackMode(value:Boolean):void
		{
			_bg.blackGound = value;
		}
		
		public function dragDrop(effect:DragEffect):void
		{
			DragManager.acceptDrag(null,DragEffect.NONE);
		}
		
		public function setBagType(type:uint):void
		{
			(_bag as BagIIController).setBagType(type);
		}
		
		public function closeKeySetFrame():void
		{
			((_bag as BagIIController).getView() as BagIIView).closeKeySetFrame();
		}
		
		private function initEvent():void
		{
			addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
			_bag.getView().addEventListener(CellEvent.DRAGSTART,__startShine);
			_bag.getView().addEventListener(CellEvent.DRAGSTOP,__stopShine);
			//_bag.getView().addEventListener("delstart",__delStart);
			_bag.getView().addEventListener("sellstart",__sellStart);
			//_bag.getView().addEventListener("delstop",__delStop);
			_bag.getView().addEventListener("sellstop",__sellStop);
			_infocontroller.getView().addEventListener(CellEvent.DRAGSTART,__startShine);
			_infocontroller.getView().addEventListener(CellEvent.DRAGSTOP,__stopShine);
			_infocontroller.getView().addEventListener(BagStore.OPEN_BAGSTORE,closeFrame);
//			ok_btn.addEventListener(MouseEvent.CLICK,__okClick);
			this.addEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
//		private function __delStart(e:Event):void
//		{
//			//Sprite(_infocontroller.getView()).mouseEnabled=false;
//			Sprite(_infocontroller.getView()).mouseChildren=false;
//		}
		
		private function __sellStart(e:Event):void
		{
			//Sprite(_infocontroller.getView()).mouseEnabled=false;
			Sprite(_infocontroller.getView()).mouseChildren=false;
		}
		
//		private function __delStop(e:Event):void
//		{
//			Sprite(_infocontroller.getView()).mouseChildren=true;
//		}
		
		private function __sellStop(e:Event):void
		{
			Sprite(_infocontroller.getView()).mouseChildren=true;
		}
		
		private function removeEvnet():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,   __onKeyDownHandler);
			_bag.getView().removeEventListener(CellEvent.DRAGSTART,__startShine);
			_bag.getView().removeEventListener(CellEvent.DRAGSTOP,__stopShine);
			_infocontroller.getView().removeEventListener(CellEvent.DRAGSTART,__startShine);
			_infocontroller.getView().removeEventListener(CellEvent.DRAGSTOP,__stopShine);
			_infocontroller.getView().removeEventListener(BagStore.OPEN_BAGSTORE,closeFrame)
			removeEventListener(Event.ADDED_TO_STAGE,userGuide);
		}
		// userGuide
		private function userGuide(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,userGuide);
			if(!UserGuideManager.Instance.getIsFinishTutorial(12)){
				UserGuideManager.Instance.setupStep(12,UserGuideManager.CONTROL_GUIDE,beforeUserGuide12,checkUserGuide12);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(13)){
				UserGuideManager.Instance.setupStep(13,UserGuideManager.CONTROL_GUIDE,beforeUserGuide13,checkUserGuide13);
			}
			if(!UserGuideManager.Instance.getIsFinishTutorial(14)){
				UserGuideManager.Instance.setupStep(14,UserGuideManager.CONTROL_GUIDE,null,checkUserGuide14);
			}
		}
		private var _weapon:int
		private function beforeUserGuide12():void{
			_weapon = _info.WeaponID
		}
		private function checkUserGuide12():Boolean{
			if(DragManager.isDraging){//change weapon
				return true;
			}
			if(checkUserGuide13()){
				return true;
			}
			return false;
		}
		private function beforeUserGuide13():void{
						
		}
		private function checkUserGuide13():Boolean{
			if(_info.WeaponID != _weapon && _info.WeaponID > 0 && !DragManager.isDraging){//close bag
				return true;
			}
			return false;
		}
		private function checkUserGuide14():Boolean{
			if(!visible){//close bag
				return true;
			}
			return false;
		}
		private function closeFrame(evt:Event):void
		{
			_controller.switchVisible();
		}
		
		private function __addToStageHandler(e:Event):void
		{
//			trace("显示背包后的焦点位置："+stage.focus);
			removeEventListener(Event.ADDED_TO_STAGE,__addToStageHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,   __onKeyDownHandler);
			KeyboardManager.getInstance().init(stage);
		}
		private function __onKeyDownHandler(evt : KeyboardEvent) : void
		{
//			evt.stopPropagation();
//			SoundManager.instance.play("008");
			if((evt.target is DownloadingView) || (evt.target is ReworkNameView) || (evt.target is HAlertDialog) || (evt.target is TextField))
			{
				return;	
			}
			if(evt.keyCode == Keyboard.ESCAPE && visible && BagStore.Instance.passwordOpen)
			{
				PlayerManager.Instance.Self.unlockAllBag();
				__okClick();
			}
//			stage.dispatchEvent(evt);
		}
		private function __okClick():void
		{
			SoundManager.Instance.play("008");
			_controller.switchVisible();
		}
		
		private function __startShine(evt:CellEvent):void
		{
			if(DragManager.isDraging)(_infocontroller.getView() as PersonalInfoIIView).startShine((evt.data) as ItemTemplateInfo);
		}
		
		private function __stopShine(evt:CellEvent):void
		{
			(_infocontroller.getView() as PersonalInfoIIView).stopShine();
		}
		
		public function dispose():void
		{
			removeEvnet();
			_bg.dispose();
			if(_bg.parent)_bg.parent.removeChild(_bg);
			_bg.dispose();
			_bg = null;
//			ok_btn.removeEventListener(MouseEvent.CLICK,__okClick);
			_bag.dispose();
			_bag = null;
			_infocontroller.dispose();
			_infocontroller = null;
			_controller = null;
			_info = null;
			if(parent)parent.removeChild(this);
		}
	}
}