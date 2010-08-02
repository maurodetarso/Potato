package potato.modules.i18n
{	
import flash.text.TextField;
import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
	
	/**
	* Searches for TextFields in the haystack using the miner function
	* 
	* The miner function always receives the TextField as a parameter and should return an String
	* which is the id of the localized string in the I18n locale file, other parameter can be passed usind
	* the rest parameters
	* 
	* Ex matching by instance:
	* function(s:TextField):String {
	* 	return s.name;
	* }
	* 
	 * @param haystack DisplayObjectContainer Where to search
	 * @param miner Function How to search
	 * @param ... Array Miner parameters
	 * @private 
	 * 
	 * 
	* @example
	* 
	* //Default uses MATCH_BY_TEXT
	* fillWithLocale(this);
	* 
	* //Function with no parameters
	* fillWithLocale(this, Locale.MATCH_BY_TEXT);
	* 
	* //Functions with parameters
	* fillWithLocale(this, Locale.MATCH_BY_INSTANCE_WITH_PREFIX, "prefix_");
	* fillWithLocale(this, Locale.MATCH_BY_INSTANCE_WITH_SUFFIX, "_suf");
	* 
	* //Important Note:
	* //MATCH_BY_TEXT searches for {my_text}, between braces
	 * */
	
	public function fillWithLocale(haystack:DisplayObjectContainer, miner:Function = null, ...rest):void
	{
		
		//Gets the dictionary containing the locale strings
		var strings:Object = I18n.instance.proxy;
		
		//Set the default function?
		if (miner == null) miner = I18n.MATCH_BY_TEXT;
		
		//Function used to fill with text and traverse the display list
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
