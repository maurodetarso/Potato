package 
{
	import potato.modules.navigation.YAMLSiteView;
	import display.RectangularSprite;
	
	public class MainView extends YAMLSiteView
	{
	
		public function MainView()
		{
			super();
			trace(parameters.configFile);
			trace(parameters.defaultExtension);
			trace(parameters.userDataServicePath);
		}
		
		override public function init():void
		{
			super.init();
			
			var rs:RectangularSprite = new RectangularSprite(200, 100);
			rs.x = 100;
			rs.y = 100;
			addDisposableChild(rs);
			
			trace(_config.hasProperty("project_views"));
			//trace(_config.project_views);
			trace(parameters.userDataServicePath);
		}
		
		override public function dispose():void
		{
			super.dispose();	
		}
	
	}

}