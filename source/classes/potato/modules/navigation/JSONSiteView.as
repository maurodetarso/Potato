package potato.modules.navigation
{
	import potato.core.config.JSONConfig;

	/**
	 * Description
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
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
			parameters.defaultExtension   = "json"

            //Initialize tracking
            Tracker.instance.config = new JSONConfig(parameters.tagsFile);
			
			//Boot
			startup(new JSONConfig(parameters.configFile));
		}
	
	}

}
