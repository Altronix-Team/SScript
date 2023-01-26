# SScript 
SScript is a project made to extend HScript and make it eaiser to use. It supports almost all of the Haxe structures.

Things done so far:
- [x] It's own class
- [x] Import
- [x] Public and Private
- [x] Final declaration
- [x] Inline variables and functions
- [x] Private access
- [x] Advanced call
- [x] Null Coalescing
- [x] Package
- [x] Macro Support (Using macro will return haxe.macro.Expr, macro functions are not supported. See [Macro](https://github.com/TheWorldMachinima/SScript#Macro));
- [ ] True type declaration (In progress)
- [ ] Enum
- [ ] Abstract
- [ ] Class

## Function in its class

### New
Creates a new **SScript**, which you can create with a file or script.
New function sets some basic classes (Math, File, FileSystem etc.) which you can disable.

### Set
Sets any variable to script. You can access to set variable anywhere.

### Get
Gets a variable in script's variables. Will return null if the variable does not exist.

### Call
Calls a function in the script. Will return null if the called function does not exist.

### Error
Calls itself when an exception is thrown, caused by script issues.
Also calls **errorThrow** in script.

### Macro
Macro support is a little bit complicated.
If you use macro in a script, that variable will be turned to [haxe.macro.Expr](https://api.haxe.org/haxe/macro/Expr.html).
Example:

```haxe
var v = macro 1; //v becomes {pos: {min: 10247, max: 10254, file: hscriptBase/Interp.hx}, expr: ...}

macro function func()
{
     
} //not supported


var v = macro function func() {

}; //supported but v becomes {pos: {min: 10247, max: 10254, file: hscriptBase/Interp.hx}, expr: ...}
```