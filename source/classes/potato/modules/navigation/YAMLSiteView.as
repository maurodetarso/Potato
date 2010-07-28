package potato.modules.navigation
{
	import potato.core.config.YAMLConfig;
    import potato.modules.tracking.Tracker;

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
			parameters.defaults.defaultExtension   = "yaml"

            //Initialize tracking
            Tracker.instance.config = new YAMLConfig(parameters.tagsFile);
			
			//Boot
			startup(new YAMLConfig(parameters.configFile));
		}
	
	}

}
