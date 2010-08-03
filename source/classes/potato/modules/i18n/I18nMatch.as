package potato.modules.i18n
{
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * Contains the fillWithLocale function and related functionalities.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Lucas Dupin, Fernando França
	 * @since  03.08.2010
	 */
	public class I18nMatch extends Object
	{
		public static const MATCH_BY_TEXT:Function = matchByText;
		public static const MATCH_BY_INSTANCE:Function = matchByInstance;
		public static const MATCH_BY_INSTANCE_WITH_PREFIX:Function = matchByInstanceWithPrefix;
		public static const MATCH_BY_INSTANCE_WITH_SUFFIX:Function = matchByInstanceWithSuffix;
	
		public static function matchByText(e:TextField):String {
			if (e.text.charAt(0) == "{" && e.text.charAt(e.text.length -1) == "}")
				return e.text.substr(1, e.text.length - 2);
			return null;
		}
	
		public static function matchByInstance(e:TextField):String
		{
			return e.name;
		}
	
		public static function matchByInstanceWithPrefix(e:TextField, prefix:String):String
		{
			return prefix + e.name;
		}
	
		public static function matchByInstanceWithSuffix(e:TextField, prefix:String):String
		{
			return e.name + prefix;
		}
	
	
	
		/**
		 * Fills a DisplayObjectContainer's children with the i18n
		 * @param	haystack	The DisplayObjectContainer object to be searched and replaced.
		 * @param	miner   	The mining function being used to match the TextFields with the locale strings. 
		 * 
		 */
		public static function fillWithLocale(haystack:DisplayObjectContainer, miner:Function = null, ...rest):void
		{
			// Gets the dictionary containing the locale strings
			var strings:Object = I18n.instance.proxy;

			// Sefault match function
			if (miner == null) miner = I18nMatch.MATCH_BY_TEXT;

			// Function used to fill with text and traverse the display list
			var traverseDisplayTree:Function = function(where: DisplayObject, maxDepth:int):void {

				//Did we reach the max depth?
				if(maxDepth <= 0) return;
				
				//Check if it's a TextField
				if (where is TextField)
				{
					//Get the id from the miner function
					var id:String = miner.apply(where, [where].concat(rest));
					
					//Check if it exists in the list
					if (strings[id])
						where["text"] = strings[id];
					else
						trace("ID NOT FOUND:", id)

				} 
				//No let's loop through the children
				else if (where is DisplayObjectContainer)
				{
					var c:DisplayObjectContainer = where as DisplayObjectContainer;
					//Going deeper
					for (var i:int = 0; i < c.numChildren; i++)
						traverseDisplayTree(c.getChildAt(i), maxDepth-1)
				}
			}
			//Loop
			traverseDisplayTree(haystack, 10);
		}
	}
}
