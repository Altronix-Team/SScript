
# SScript

SScript is an easy to use Haxe script parser and interpreter, including class support and more. It aims to support all of the Haxe structures while being fast and easy to use.

(Classes are supported with [hscript-ex](https://github.com/ianharrigan/hscript-ex "hscript-ex") by [ianharrigan](https://github.com/ianharrigan), files have been modified to make it compatible with SScript)

## Installation
`haxelib install SScript`

Enter this command in command prompt to get the latest release from Haxe library.
All of the versions except 1.9.9 have been tested and they are stable.

------------

`haxelib git SScript https://github.com/TheWorldMachinima/SScript.git`

Enter this command in command prompt to get the latest git release from Github. 
Git releases have the latest features but they are unstable and can cause problems.

After installing SScript, don't forget to add it to your Haxe project.
### OpenFL projects
Add this to `Project.xml` to add SScript to your OpenFL project:
```xml
<haxelib name="SScript"/>
<haxedef name="hscriptPos"/>
```
### Haxe Projects
Add this to `build.hxml` to add SScript to your Haxe build.
```hxml
-lib SScript
-D hscriptPos
```

Flag `hscriptPos` is needed for error handling at runtime. It is optional but definitely recommended.
## Usage
To use SScript, you will need a file or a script. Using a file is recommended.
Also define 

### Using without a file
```haxe
var script:SScript = new SScript(); // Create a new SScript instance
script.doString("
	import Math; // Importing Math is unnecessary since SScript will set basic classes to script instance including Math but we do it just in case
	
	function returnRandom():Float
		return Math.random() * 100;
"); // Implement the script
var call = script.call('returnRandom');
var randomNumber:Float = call.returnValue; // Access the returned value with returnValue
```
Usage of `doString` should be minimalized.

### Using with a file
```haxe
var script:SScript = new SScript("script.hx"); // Has the same contents with the script above
var randomNumber:Float = script.call('returnRandom').returnValue;
```

## Using classes with SScript
SScript has 2 modes: Ex and Normal. 
If SScript has been created with a class, it will automatically switch to Ex mode. Ex mode allows only 3 expressions: imports, package and classes. 

So a script like this isn't valid in Ex mode:
```hscript
package mypackage;

import sys.io.File;

class SomeClass {
}

trace(1); // This is the part that will cause problems in Ex mode
```

Classes can be extended aswell, just like vanilla Haxe. (You can also implement things but it will do nothing for now).

Let's create a file named `script.hx`:
```hscript
class ParentClass {
	var A:Int = 1;
	function overrideThis():Float
	{
		trace('overriden');
		return A;
	}
}

class Child extends ParentClass {
	override public function overrideThis()
	{
		trace('Parent returns ' + super.overrideThis());
		return super.A + 1;
	}
}
```
Let's create our haxe project:
```haxe
class Main
{
	static function main()
	{
		var script:SScript = new SScript("script.hx");
		var c = script.call('overrideThis', 'Child'); // You need to specify the Child class, if it isn't specified SScript will call the function from ParentClass
		trace(c);
	}
}
```
When we compile it, it will print out like below:
![](https://i.ibb.co/1qJPfM0/Ekran-Resmi-2023-04-03-23-39-24.png)

In this case it succeeds but it may not for some scripts. You can always check `exceptions` array to see why it failed for you (exceptions will not be thrown to avoid crashes, you need to throw them manually if you want your program to crash).


------------

Parent classes don't need to be scripted, they can be Haxe classes aswell.
Let's create an example project:
```haxe
class Main {
	static function main()
	{
		var script:SScript = new SScript();
		script.set('ParentClass', ParentClass); // Set ParentClass to SScript
		// To set classes, you can use these alternatives below
		script.setClass(ParentClass);
		script.setClassString('ParentClass');
		script.doString("
				class Child extends Parent
				{
					override function overrideThis()
					{
						trace('Parent returns ' + super.overrideThis());
						return super.A + 1;
					}
				}
			");
		var c = script.call('overrideThis'); // You don't need to specify Child since it is the only class in script
		trace(c);
	}
}

class ParentClass {
	public var A:Int = 1;
	
	function overrideThis():Float
	{
		trace('overriden $A');
		return A;
	}
}
```
When it is compiled, it will print out like this:
![](https://i.ibb.co/VJ7Bz8s/Ekran-Resmi-2023-04-04-00-01-07.png)



------------

## Extending SScript
You can create a class extending SScript to customize it better.
```haxe
class SScriptExtended extends SScript
{
	public function new(scriptFile:String)
	{
		super(scriptFile);
	}
	
	override function preset():Void
	{
		super.preset();
		
		// Only use 'set', 'setClass' or 'setClassString' in 'preset', avoid using 'interp.variables.set'!
		// Macro classes are not allowed to be set
		setClass(StringTools);
		set('NaN', Math.NaN);
		setClassString('sys.io.File');
	}
}
```
It is recommended to override only `preset`, other functions were not written with overridability in mind.

## Addiotional variables
1. `unset` will remove a variable from script, making it unavailable for later use.

2. `get` will return the variable you've asked for from the script. It will return null if the variable doesn't exist.

3. `clear` will clear all of the variables in script, excluding `true`, `false`, `null` and `trace`.

4. `exists` will check if the variable exists in script, will return true if it exists; will return false it does not.

5. `currentClass` is the current class name in script. When a script is created, if there are any classes `currentClass` will be the first class in script. Changing this will change `currentScriptClass` and `currentSuperClass`.

6. `currentScriptClass` changes based on `currentClass`, it is not an actual class but it is an abstract containing useful variables like `listFunctions` and more.

7. `currentSuperClass` is the actual parent class of `currentScriptClass`. It's type is `Class<Dynamic>`.