package org.as3yaml
{
	public class YamlDecoder
	{
		private var yaml: String;
		
		public function YamlDecoder(yaml : String)
		{
			this.yaml = yaml;
		}

	    public function decode (config: YAMLConfig = null) : Object
	    {
	    	var cfg: YAMLConfig = config || new DefaultYAMLConfig();
			var obj : Object = load(yaml, cfg);
			
			return obj;
	    }
	
	    private function load(io : String, cfg : YAMLConfig) : Object 
	    {
	        var ctor : SafeConstructor = createConstructor(createComposer(createParser(createScanner(io),cfg),createResolver()));
	        if(ctor.checkData()) {
	            return ctor.getData();
	        } else {
	            return null;
	        }
	    }
	    public function createScanner(io : String) : Scanner {
	        return new Scanner(io);
	    }
	    public function createParser(scanner : Scanner, cfg : YAMLConfig) : Parser {
	        return new Parser(scanner,cfg);
	    }
	    public function createResolver() : Resolver {
	        return new Resolver();
	    }
	    public function createComposer(parser : Parser,  resolver : Resolver) : Composer {
	        return new Composer(parser,resolver);
	    }
	    public function createConstructor(composer : Composer) : SafeConstructor {
	        return new SafeConstructor(composer);
	    }


	}
}