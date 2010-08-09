package example.views
{
	import potato.modules.navigation.presets.YAMLSiteView;
	import example.text.CustomTextField;
	import potato.modules.i18n._;

	public class About extends YAMLSiteView
	{
	
		public function About()
		{
			super();
		}
		
		override public function init():void
		{
			addDisposableChild(new CustomTextField(140, 200, _("about"), true));
		}
	
	}

}