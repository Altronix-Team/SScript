package macro;

import haxe.macro.Compiler;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
import haxe.macro.Printer;
import haxe.macro.TypeTools;
import haxe.macro.TypedExprTools;

class Macro
{
	public static var macroClasses:Array<Class<Dynamic>> = [
		Compiler,
		Context,
		MacroStringTools,
		Printer,
		ComplexTypeTools,
		TypedExprTools,
		ExprTools,
		TypeTools,
	];

	public static macro function checkSys()
	{
		final defines = Context.getDefines();
		if (!defines.exists('sys'))
			throw 'You cannot access the sys package while targeting ${defines.get('target.name')}';

		return macro null;
	}
}
