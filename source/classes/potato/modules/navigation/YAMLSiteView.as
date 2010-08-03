package potato.modules.navigation
{
	import potato.core.config.YAMLConfig;
    import potato.modules.tracking.Tracker;
	import potato.modules.i18n.I18n;

	/**
	 * Complex view (I18n, tracking) configured with YAML syntax.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
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
			parameters.defaults.defaultExtension = "yaml";

            //Initialize tracking
            Tracker.instance.config = new YAMLConfig(parameters.tagsFile);
            
            //I18n type
            I18n.parser = YAMLConfig;
			
			//Boot
			startup(new YAMLConfig(parameters.configFile));
		}
	
	}

}
