package potato.modules.navigation
{
	import potato.core.config.JSONConfig;
    import potato.modules.tracking.Tracker;
	import potato.modules.i18n.I18n;

	/**
	 * Complex view (I18n, tracking) configured with JSON syntax
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin, Fernando França
	 * @since  16.06.2010
	 */
	public class JSONSiteView extends ComplexSiteView
	{
	
		public function JSONSiteView()
		{
			super();
			
            //Setting default parameters
			parameters.defaults.defaultExtension   = "json"

            //Initialize tracking
            Tracker.instance.config = new JSONConfig(parameters.tagsFile);

            //I18n type
            I18n.parser = JSONConfig;
			
			//Boot
			startup(new JSONConfig(parameters.configFile));
		}
	
	}

}
