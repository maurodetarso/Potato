/* Copyright (c) 2007 Derek Wischusen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of 
 * this software and associated documentation files (the "Software"), to deal in 
 * the Software without restriction, including without limitation the rights to 
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
 * SOFTWARE.
 */

package org.as3yaml {

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import org.as3yaml.nodes.*;

public class BaseConstructor implements Constructor {
    private static var yamlConstructors : Dictionary = new Dictionary();
    private static var yamlMultiConstructors : Dictionary = new Dictionary();
    private static var yamlMultiRegexps : Dictionary = new Dictionary();
   
    public function getYamlConstructor(key : Object) : Function {
        return yamlConstructors[key] as Function;
    }

    public function getYamlMultiConstructor(key : Object) : Function {
        return yamlMultiConstructors[key] as Function;
    }

    public function getYamlMultiRegexp(key : Object) : RegExp {
        return yamlMultiRegexps[key] as RegExp;
    }

    public function getYamlMultiRegexps() : Dictionary {
        return yamlMultiRegexps;
    }

    public function addConstructor(tag : String, ctor : Function) : void {
        yamlConstructors[tag] = ctor;
    }

    public function addMultiConstructor(tagPrefix : String, ctor : Function) : void {
        yamlMultiConstructors[tagPrefix] = ctor;
        yamlMultiRegexps[tagPrefix] =  new RegExp("^"+tagPrefix);
    }

    private var composer : Composer;
    private var constructedObjects : Dictionary = new Dictionary();
    private var recursiveObjects : Dictionary = new Dictionary();

    public function BaseConstructor(composer : Composer) {
        this.composer = composer;
    }

    public function checkData() : Boolean {
        return composer.checkNode();
    }

    public function getData() : Object {
        if(composer.checkNode()) {
            var node : Node = composer.getNode();
            if(null != node) {
                return constructDocument(node);
            }
        }
        return null;
    }

    
    public function constructDocument(node : Node) : Object {
        var data : Object = constructObject(node);
        constructedObjects = new Dictionary();
        recursiveObjects = new Dictionary();
        return data;
    }

    public function constructObject(node : Node) : Object {
        if(constructedObjects[node]) {
            return constructedObjects[node];
        }
        if(recursiveObjects[node]) {
            throw new ConstructorException(null,"found recursive node",null);
        }
        recursiveObjects[node] = null;
        var data : Object;
        var ctor : Function = getYamlConstructor(node.getTag());
        if(ctor == null) {
            var through : Boolean = true;
            
            for (var tagPrefix : String in yamlMultiRegexps) {
                var reg : RegExp = yamlMultiRegexps[tagPrefix];
                if(reg.exec(node.getTag())) {
                    var tagSuffix : String = node.getTag().substring(tagPrefix.length);
                    ctor = getYamlMultiConstructor(tagPrefix);
                    data = ctor(this, tagSuffix, node);
                    through = false;
                    break;
                }
            }
            if(through) {
                var xctor : Function = getYamlMultiConstructor(null);
                if(null != xctor) {
                    data = xctor(this, node.getTag(), node);
                } else {
                    ctor = getYamlConstructor(null);
                    if(ctor != null) {
                        data = ctor(this,node)
                    }
                }
            }
        } else {
        	data = ctor(this,node);
        }
        constructedObjects[node] = data;
        delete recursiveObjects[node];
        return data;
    }

    public function constructPrimitive(node : Node) : Object {
        if(node is ScalarNode) {
            return constructScalar(node);
        } else if(node is SequenceNode) {
            return constructSequence(node);
        } else if(node is MappingNode) {
            return constructMapping(node);
        } else {
            trace("error", node.getTag());
        }
        return null;
    }

    public function constructScalar(node : Node) : Object {
        if(!(node is ScalarNode)) {
            if(node is MappingNode) {
                var vals : Dictionary = node.getValue() as Dictionary;
                for(var key : Object in vals) {
                    if("tag:yaml.org,2002:value" == (key.getTag())) {
                        return constructScalar(Node(vals.get(key)));
                    }
                }
            }
            throw new ConstructorException(null,"expected a scalar node, but found " + getQualifiedClassName(node),null);
        }
        return node.getValue();
    }

    public function constructPrivateType(node : Node) : Object {
        var val : Object = null;
        if(node.getValue() is Dictionary) {
            val = constructMapping(node);
        } else if(node.getValue() is Array) {
            val = constructSequence(node);
        } else if (node.getValue() is Dictionary) {
        	val = constructMapping(node);
    	} else {
            val = node.getValue().toString();
        }
        return new PrivateType(node.getTag(),val);
    } 
    
    public function constructSequence(node : Node) : Object {
        if(!(node is SequenceNode)) {
            throw new ConstructorException(null,"expected a sequence node, but found " + getQualifiedClassName(node),null);
        }
        var seq : Array = node.getValue() as Array;
        var val : Array = [];
        for each(var item:Node in seq) {
            val.push(constructObject(item));
        }
        return val;
    }

    public function constructMapping(node : Node) : Object {
        if(!(node is MappingNode)) {
            throw new ConstructorException(null,"expected a mapping node, but found " + getQualifiedClassName(node),null);
        }
        var mapping : Dictionary = new Dictionary();
        var merge : Array;
        var val : Dictionary = node.getValue() as Dictionary;
       	for (var key : Object in val) {
            var key_v : Node = key as Node;
            var value_v : Node = val[key];
            if(key_v.getTag() == ("tag:yaml.org,2002:merge")) {
                if(merge != null) {
                    throw new ConstructorException("while constructing a mapping", "found duplicate merge key",null);
                }
                if(value_v is MappingNode) {
                    merge = [];
                    merge.push(constructMapping(value_v));
                } else if(value_v is SequenceNode) {
                    merge = [];
                    var vals : Array = value_v.getValue() as Array;
                    for each(var subnode : Node in vals) {
                        if(!(subnode is MappingNode)) {
                            throw new ConstructorException("while constructing a mapping","expected a mapping for merging, but found " + getQualifiedClassName(subnode),null);
                        }
                        merge.unshift(constructMapping(subnode));
                    }
                } else {
                    throw new ConstructorException("while constructing a mapping","expected a mapping or list of mappings for merging, but found " + getQualifiedClassName(value_v),null);
                }
            } else if(key_v.getTag() == ("tag:yaml.org,2002:value")) {
                if(mapping["="]) {
                    throw new ConstructorException("while construction a mapping", "found duplicate value key", null);
                }
                mapping["="] = constructObject(value_v);
            } else {
            	var kObj : Object = constructObject(key_v), vObj : Object = constructObject(value_v);
                mapping[kObj] = vObj;
            }
        }
        if(null != merge) {
            merge.push(mapping);
            mapping = new Dictionary();
            for each(var item : Dictionary in merge) {
                for (var key: Object in item)
                	mapping[key] = item[key];
            }
        }
        return mapping;
    }

    public function constructPairs(node : Node) : Object {
        if(!(node is MappingNode)) {
            throw new ConstructorException(null,"expected a mapping node, but found " + getQualifiedClassName(node), null);
        }
        var value : Array = [];
        var vals : Dictionary = node.getValue() as Dictionary;
        for (var key : Object in vals) {
            var val : Node = vals[key] as Node;
            value.push([constructObject(key as Node),constructObject(val)]);
        }
        return value;
    }
    
    
    public function constructOmap (node : Node) : Object {
        if(!(node is SequenceNode)) {
            throw new ConstructorException(null,"expected a sequence node, but found " + getQualifiedClassName(node), null);
        }
        var value : Array = [];
        var vals : Array = node.getValue() as Array;
		var addedKeyValHash : Object = new Object();
		
        for each(var val : Node in vals) {  
          
            var hash : Dictionary = constructObject(val) as Dictionary;
			var hashSize: int = 0;
            var hashKey: Object;
            for (var key: Object in hash)
            {  
            	hashKey = key;
            	hashSize++;
            }
            
            if (hashSize > 1)
            	throw new YAMLException("Each Map in an Ordered Map (!omap) is permitted to have only one key");
          
            var hashValue : Object = hash[hashKey];
            
            if(!(addedKeyValHash[hashKey] && (addedKeyValHash[hashKey] == hashValue)))
            {
            	value.push(hash);
            	addedKeyValHash[hashKey] = hashValue;
            }
           
        }
        
        return value;    	
    }
    

    public function CONSTRUCT_PRIMITIVE(self : Constructor, node : Node) : Object {
                return self.constructPrimitive(node);
            }
    public function CONSTRUCT_SCALAR(self : Constructor, node : Node) : Object {
                return self.constructScalar(node);
            }
    public function CONSTRUCT_PRIVATE(self : Constructor, node : Node) : Object {
                return self.constructPrivateType(node);
            }
    public function CONSTRUCT_SEQUENCE(self : Constructor, node : Node) : Object {
                return self.constructSequence(node);
            }
    public function CONSTRUCT_MAPPING(self : Constructor, node : Node) : Object {
                return self.constructMapping(node);
            }
}// BaseConstructorImpl
}
	
