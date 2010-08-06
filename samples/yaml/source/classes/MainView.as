package 
{
	import potato.modules.navigation.presets.YAMLSiteView;
	import display.RectangularSprite;
	import potato.modules.i18n.I18n;
	import potato.core.config.YAMLConfig;
	import flash.events.Event;
	import potato.modules.tracking.track;
	import potato.utils.getInstanceByName;
	
	/**
	 * Example for YAMLSiteView. (not yet finished)
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  04.08.2010
	 */
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
			
			var rs:RectangularSprite = new RectangularSprite(200, 100, 0x0000ff);
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