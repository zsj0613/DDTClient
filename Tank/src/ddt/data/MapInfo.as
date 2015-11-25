package ddt.data
{
	import flash.geom.Point;
	
	public class MapInfo
	{
		/**
	    * 重力加速度 
	    */	   
	  	public static  var G:Number = 0.98;
		
	    public var ID:int;
	    public var Name:String;
	    public var isOpen:Boolean;
		public var canSelect:Boolean;
	    
	   /**
	    * 前景长宽 (总游戏长宽)
	    */	   	
	    public var ForegroundWidth:Number;
	    public var ForegroundHeight:Number;
	    /**
	     * 地址 
	     */	    
	    public var ForePic:String;
	    
	   /**
	    * 背景长宽 
	    */	  
	    public var BackroundWidht:Number;
	    public var BackroundHeight:Number;
	    public var BackPic:String;
	    
	    /**
	     * 不可炸掉的区域 
	     */	    
	    public var DeadWidth:Number;
	    public var DeadHeight:Number;
	    public var DeadPic:String;
	    
	    /**
	     * 图片地址 
	     */	    
	    public var Pic:String;
	    
	    /**
	     * 地图描述 
	     */	    
	    public var Description:String;
	    
	    /**
	     *背景音乐 
	     */	    
	    public var BackMusic:String = "050" ;
	    
	    /**
	     * 重力加速度 
	     */	    
	    public var Weight:int;
	    
	    /**
	     * 风力 
	     */	    
	    public var Wind:Number;
	    /**
	     * 空气阻力 
	     */	    
	    public var DragIndex:int;
	    
	    /****
	    * 
	    */
	    public var Type : int;
	}
}