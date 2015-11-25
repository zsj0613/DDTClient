package ddt.view.bagII.baglocked
{
	import fl.controls.ScrollPolicy;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import game.crazyTank.view.bagII.TextBgAsset;
	
	import road.ui.controls.SimpleGrid;
	
	import ddt.manager.LanguageMgr;
	import ddt.view.bagII.BagEvent;
	

	public class PasswordProtectionSimpleGrid extends SimpleGrid
	{
		private var _questionArray:Array = [
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.question1"),
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.question2"),
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.question3"),
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.question4"),
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.question5"),
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.question6"),
		LanguageMgr.GetTranslation("ddt.view.bagII.baglocked.customer"),
		];
		
		public function PasswordProtectionSimpleGrid()
		{
			super(200,18,1);
			setSize(228,148);
			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			marginHeight = marginWidth = 0;
			cellPaddingHeight = 0;
			initEvents();
		}
		
		override protected function configUI():void{
			super.configUI();
			creatCells();
		}
		
		private function creatCells():void{
			for(var i:int = 0; i < _questionArray.length; i++){
				var text:TextBgAsset = new TextBgAsset();
				text.bg2.visible = false;
				text.bgtext.text = _questionArray[i];
				text.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				text.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				text.addEventListener(MouseEvent.CLICK,mouseClickHandler);
				text.bg3.buttonMode = true;
				appendItem(text);
			}
		}
		
		private function mouseOverHandler(event:MouseEvent):void{
			(event.currentTarget as TextBgAsset).bg2.visible = true;
		}
		
		private function mouseOutHandler(event:MouseEvent):void{
			(event.currentTarget as TextBgAsset).bg2.visible = false;
		}
		
		private function mouseClickHandler(event:MouseEvent):void{
			var evt:BagEvent = new BagEvent(BagEvent.PSDPRO,new Dictionary);
			evt.data = event.currentTarget as TextBgAsset;
			dispatchEvent(evt);
		}
		
		private function initEvents():void{
			
		}
		
		public function addItem(value:String):void{
			var text:TextBgAsset = new TextBgAsset();
			text.bg2.visible = false;
			text.bgtext.text = value;
			text.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			text.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			text.addEventListener(MouseEvent.CLICK,mouseClickHandler);
			text.bg3.buttonMode = true;
			appendItem(text);
		}
		
		public function get questionArray():Array{
			return _questionArray;	
		}
		
		public function set questionArray(array:Array):void{
			_questionArray = array;
		}
		
		public function dispose():void
		{
			for each(var i:TextBgAsset in this)
			{
				i.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				i.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				i.removeEventListener(MouseEvent.CLICK,mouseClickHandler);
				if(i.parent)
					i.parent.removeChild(i);
				i = null;
			}
			clearItems();
			_questionArray = null;
		}
	}
}