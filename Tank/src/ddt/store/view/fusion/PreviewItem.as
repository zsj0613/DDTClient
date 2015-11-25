package ddt.store.view.fusion
{
	import game.crazyTank.view.storeII.PreviewItemAsset;
	
	import road.utils.ComponentHelper;
	
	import ddt.store.data.PreviewInfoII;

	public class PreviewItem extends PreviewItemAsset
	{
		private var _cell : PreviewItemCell;
		public function PreviewItem()
		{
			super();
			_cell = new PreviewItemCell();
			_cell.allowDrag   = false;
			ComponentHelper.replaceChild(this,this["cell"],_cell);
		}
		
		public function set info($info : PreviewInfoII) : void
		{
			_cell.info = $info.info;
			this.rate_txt.text = String($info.rate) + "%";
			this.title_txt.text = String($info.info.Name);
		}
		public function dispose() : void
		{
			this.rate_txt.text = "";
			this.title_txt.text = "";
			_cell.dispose();
			if(this.parent)this.parent.removeChild(this);
		}
		
	}
}