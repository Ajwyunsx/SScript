package tea.backend;

import haxe.ds.StringMap;
import haxe.ds.IntMap;
import haxe.ds.ObjectMap;
import haxe.ds.EnumValueMap;
import haxe.Constraints.IMap;

/**
    A custom type of map which sets values to scripts in global.
**/
typedef Tea3LLuaGlobalMap = Tea3LLuaTypedGlobalMap<String, Dynamic>;

@:transitive
@:multiType(@:followWithAbstracts K)
@:access(tea.SScript)
abstract Tea3LLuaTypedGlobalMap<K, V>(IMap<K, V>) 
{
	public function new();

	public inline function set(key:K, value:V)
    {
		this.set(key, value);
        
        var key:String = cast key;
        var value:Dynamic = cast value;
        for (i in SScript.global)
        {
            if (!i._destroyed)
                i.set(key, value #if THREELLUA, SScript.getMode(1) #end);
        }
    }

	@:arrayAccess public inline function get(key:K)
		return this.get(key);

	public inline function exists(key:K)
		return this.exists(key);

	public inline function remove(key:K)
	{
		var k:String = cast key;
		for (i in SScript.global)
        {
            for (i in SScript.global)
			{
				if (!i._destroyed)
					i.unset(k);
			}
        }

		return this.remove(key);
	}

	public inline function keys():Iterator<K> 
		return this.keys();

	public inline function iterator():Iterator<V> 
		return this.iterator();

	public inline function keyValueIterator():KeyValueIterator<K, V> 
		return this.keyValueIterator();

	public inline function copy():Map<K, V> 
		return cast this.copy();

	public inline function toString():String 
		return this.toString();

	public inline function clear():Void 
		this.clear();

	@:arrayAccess @:noCompletion public inline function arrayWrite(k:K, v:V):V 
    {
		this.set(k, v);
        var key:String = cast k;
        var value:Dynamic = cast v;
        for (i in SScript.global)
        {
            if (!i._destroyed)
                i.set(key, value #if THREELLUA, SScript.getMode(1) #end);
        }
		return v;
	}

	@:to static inline function toStringMap<K:String, V>(t:IMap<K, V>):StringMap<V> 
		return new StringMap<V>();

	@:to static inline function toIntMap<K:Int, V>(t:IMap<K, V>):IntMap<V> 
		return new IntMap<V>();

	@:to static inline function toEnumValueMapMap<K:EnumValue, V>(t:IMap<K, V>):EnumValueMap<K, V> 
		return new EnumValueMap<K, V>();

	@:to static inline function toObjectMap<K:{}, V>(t:IMap<K, V>):ObjectMap<K, V> 
		return new ObjectMap<K, V>();

	@:from static inline function fromStringMap<V>(map:StringMap<V>):Tea3LLuaTypedGlobalMap<String, V> 
		return cast map;

	@:from static inline function fromIntMap<V>(map:IntMap<V>):Tea3LLuaTypedGlobalMap<Int, V> 
		return cast map;

	@:from static inline function fromObjectMap<K:{}, V>(map:ObjectMap<K, V>):Tea3LLuaTypedGlobalMap<K, V> 
		return cast map;
}
