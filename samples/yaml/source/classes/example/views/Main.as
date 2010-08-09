package example.views
{
	import potato.modules.navigation.presets.YAMLSiteView;
	import potato.core.config.YAMLConfig;
	import flash.events.Event;
	import example.display.RectangularSprite;
	import flash.display.Bitmap;
	
	/**
	 * Example for YAMLSiteView. (not yet finished)
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  04.08.2010
	 */
	public class Main extends YAMLSiteView
	{
		public function Main()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			var rs:RectangularSprite = new RectangularSprite(100, 480, 0x555555);
			rs.x = 0;
			rs.y = 0;
			addDisposableChild(rs);
			
			// Yay, dependencies have already been loaded for this View!
			// Let's add our Black Cat logo now!
			var myLogo:Bitmap = dependencies.getBitmap("logo");
			myLogo.smoothing = true;
			myLogo.scaleX = myLogo.scaleY = 0.5;
			myLogo.x = 420;
			myLogo.y = 320;
			addChild(myLogo);
		}
		
		override public function dispose():void
		{
			super.dispose();	
		}
	
	}

}