package
{	
	import flash.display.Sprite;
	import potato.modules.parameters.Parameters;
	import potato.core.config.ObjectConfig;
	public class parameters extends Sprite
	{

		public function parameters()
		{
			undefinedParamter();
			nullParameter();
			parameterInjecting();
			parameterSetting();
			parameterDefaults();
			parametersOverrideOrder();
			parameterInterpolation();
			defaultsInterpolation();
			inheritance();
		}
		
		private var p:Parameters;
		public function get parameter():Parameters
		{
			if(!p)
				p = new Parameters();
			
			//Loaded values
			p.inject(new ObjectConfig({
				"name": "value",
				"name2": "value2",
				"name3": "value3",
				"name4": null,
				"name5": "%(name)s"
			}))
			
			//Defaults
			p.defaults.name2 = "otherValue"
			p.defaults.defaultName = "default"
			p.defaults.interpolated = "%(name2)s"
			
			//Overriding values
			p.name3 = "changed value";
			
			return p;
		}
		
		public function undefinedParamter():void
		{
			trace(parameter.sbrubles == undefined);
		}
		public function nullParameter():void
		{
			trace(parameter.name4 == null);
		}
		public function parameterInjecting():void
		{
			trace(parameter.name == "value");
		}
		public function parameterSetting():void
		{
			trace(parameter.name3 == "changed value");
		}
		public function parameterDefaults():void
		{
			trace(parameter.defaultName == "default");
		}
		public function parametersOverrideOrder():void
		{
			trace(parameter.name2 == "value2");
		}
		public function parameterInterpolation():void
		{
			trace(parameter.name5 == parameter.name)
		}
		public function defaultsInterpolation():void
		{
			trace(parameter.interpolated == parameter.name2);
		}
		public function inheritance():void
		{
			var inh:Parameters = new Parameters(new ObjectConfig({
				inheritedProp: "yep"
			}));
			parameter.inherit = inh;
			
			trace(parameter.inheritedProp == "yep");
			
		}

	}
}