package org.rxr.actionscript.io
{
	
	public class StringReader
	{
		private var source: String;
		public var peekCache: String;
			
		public function get charsAvailable(): int
		{
			return source.length;
		}
				
		public function StringReader(string:String="")
		{
			source = string;
			peekCache = source.charAt(0);
		}
		
		public function peek(offset: int = 0): String
		{
			return source.charAt(offset);
		}
		
		public function peekFor(length: int, offset:int = 0): String
		{
			return source.substr(offset, length);
		}

		public function peekRemaining(): String
		{
			return peekFor(source.length);
		}

		public function read(): String
		{
			var val: String = peekCache;
			forward();
			return val;
		}
		
		public function readFor(length:int):String
		{
			var str: String = source.substr(0, length);
			forwardBy(length);
			return str;
		}
		
		public function readRemaining(): String
		{
			return readFor(charsAvailable);
		}
				
		public function writeChar(char:String):void
		{
			source += char;
		}		

		public function forward(): void
		{
			source = source.slice(1);
			peekCache = source.charAt(0);
		}
		
		public function forwardBy(num: int): void
		{
			source = source.slice(num);
			peekCache = source.charAt(0);
		}			
	}
}