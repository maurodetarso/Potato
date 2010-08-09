package example.views
{
	import potato.modules.navigation.presets.YAMLSiteView;
	import potato.core.config.YAMLConfig;
	import flash.events.Event;
	import potato.modules.i18n._;
	
	/**
	 * Example for YAMLSiteView. (not yet finished)
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Fernando França
	 * @since  04.08.2010
	 */
	public class Loader extends YAMLSiteView
	{
		public function Loader()
		{
			super();
		}
		
		override public function init():void
		{
			changeView("about");
		}
	}

}