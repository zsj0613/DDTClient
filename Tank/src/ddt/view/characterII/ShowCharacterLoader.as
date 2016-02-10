package ddt.view.characterII
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import ddt.data.EquipType;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ItemManager;

	public class ShowCharacterLoader extends BaseCharacterLoader
	{
		protected var _contentWithoutWeapon:BitmapData;
		protected var _wing:MovieClip = new MovieClip();
		
		public function ShowCharacterLoader(info:PlayerInfo)
		{
			super(info);
		}
		
		override protected function initLoaders():void
		{			
			loaders = [];
			_recordStyle = info.Style.split(",");
			_recordColor = info.Colors.split(",");
			//global.traceStr(info.Colors);
			loadPart(7);
			loadPart(1);
			loadPart(0);
			loadPart(3);
			loadPart(4);
			loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[2])),_recordColor[2],BaseLayer.SHOW,false,info.getHairType()));
			loadPart(5);
			loadPart(6);
			loadPart(8);
		}
		private function loadPart(index:int):void{
			if(_recordStyle[index]>0){
				loaders.push(layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[index])),_recordColor[index],BaseLayer.SHOW));
			};
		}
		override protected function getIndexByTemplateId(id:String):int
		{
			var i:int = super.getIndexByTemplateId(id);
			if(i == -1)
			{
				if(int(id.charAt(0)) == EquipType.ARM)return 7;
				return -1;
			}
			return i;
		}
		
		override protected function drawCharacter():void
		{
			var picWidth:Number = (loaders[0] as ILayer).width;
			var picHeight:Number = (loaders[0] as ILayer).height;
			if(picWidth == 0 || picHeight == 0)return;
			var weapon:DisplayObject;
			_content = new BitmapData(picWidth,picHeight,true,0);
			_contentWithoutWeapon = new BitmapData(picWidth,picHeight,true,0);
			for(var i:int = loaders.length - 1; i >= 0; i--)
			{
				if(info.getShowSuits())
				{
					if(i != 0 && i != 8 && i != 7) continue;
				}else
				{
					if(i == 0) continue;
				}
				var layer:ILayer = loaders[i] as ILayer;
				if(layer.info.CategoryID != EquipType.ARM)
				{
					if(layer.info.CategoryID == EquipType.WING)
					{
						_wing = layer.getContent() as MovieClip;
					}else
					{
						_contentWithoutWeapon.draw(layer.getContent(),null,null,BlendMode.NORMAL);
					}
				}
				else
				{
					if(info.WeaponID != 0 && info.WeaponID != -1)
						weapon = layer.getContent();
				}
			}
			_content.draw(_contentWithoutWeapon);
			if(weapon != null)
				_content.draw(weapon);
		}
		
		
		
		override public function getContent():Array
		{
			return [_content,_contentWithoutWeapon,_wing];
		}
	}
}