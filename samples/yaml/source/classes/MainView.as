package 
{
	import potato.modules.navigation.ComplexSiteView;
	import potato.display.RectangularSprite;

	public class MainView extends ComplexSiteView
	{
	
		public function MainView()
		{
			super();
			trace(parameters.configFile);
			var rs:RectangularSprite = new RectangularSprite(200, 100);
			addDisposableChild(rs);
			trace("OK");
		}
		
		override public function init():void
		{
			super.init();
			
		}
	
	}

}