package potato.modules.navigation
{
	import potato.core.config.JSONConfig;
	import potato.modules.parameters.Parameters;
	import potato.modules.dependencies.Dependencies;
    import potato.modules.tracking.Tracker;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import potato.modules.i18n.I18n;
	import flash.events.Event;
	import potato.core.config.ObjectConfig;

	/**
	 * Description
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin, Fernando França
	 * @since  16.06.2010
	 */
	public class YAMLSiteView extends ComplexSiteView
	{
	
		public function YAMLSiteView()
		{
			super();
			
            //Setting default parameters
			parameters.defaultExtension   = "yaml"

            //Initialize tracking
            Tracker.instance.config = new YAMLConfig(parameters.tagsFile);
			
			//Boot
			startup(new YAMLConfig(parameters.configFile));
		}
	
	}

}
