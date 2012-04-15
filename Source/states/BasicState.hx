package states;

import data.Library;
import org.flixel.FlxState;
import org.flixel.FlxText;

class BasicState extends FlxState {
	function newText(x:Float, y:Float, w:Int, text:String, color:Int, ?alignment:String=null) {
		var text = new FlxText(x,y,w,text);
		text.setColor(color);
		text.setFont(Library.getFont().fontName);
		if(alignment!=null)
		text.setAlignment(alignment);
		add(text);
		
		return text;
	}	
}