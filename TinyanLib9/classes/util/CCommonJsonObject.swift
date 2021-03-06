//
//  CCommonJsonObject.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/18/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameKit

public class CCommonJsonObject
{
	init()
	{
	}
	
	public var m_json : AnyObject! = nil
	public var m_errorPrintFlag = false
	
	public class func loadByFilename(filename:String,ofType:String = "json",errorPrintFlag:Bool = false) -> CCommonJsonObject?
	{
		if let path : String = NSBundle.mainBundle().pathForResource(filename, ofType: ofType)
		{
			if let fileHandle : NSFileHandle = NSFileHandle(forReadingAtPath: path)
			{
				let data : NSData = fileHandle.readDataToEndOfFile()
				
				do {
					let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
					let myClass = CCommonJsonObject()
					myClass.m_json = jsonObject
					myClass.m_errorPrintFlag = errorPrintFlag
					return myClass
				} catch _ {
					if errorPrintFlag
					{
						print("no json data:\(filename)")
					}
				}
			}
			else
			{
				if errorPrintFlag
				{
					print("file handle error:\(filename)")
				}
			}
		}
		else
		{
			if errorPrintFlag
			{
				print("path error:\(filename).\(ofType)")
			}
		}
		
	
		return nil
	}
	
	/*
	public func getAnyObject(name:String) -> AnyObject?
	{
		if m_json != nil
		{
			return m_json!.valueForKey(name)
		}
		
		return nil
	}
	*/
	
	public func getObject<T>(name:String) -> T?
	{
		let nameArray = name.componentsSeparatedByString(".")
		return getObject(nameArray)
/*
		if var obj : AnyObject = getAnyObject(name)
		{
			return obj as? T
		}

		return nil
*/
	}

	public func getObject<T>(keyArray:[String]) -> T?
	{
		
		if let obj : AnyObject = getAnyObject(keyArray)
		{
			
			let check : T? = nil
			
			
			if check is CGPoint? || check is CGSize? || check is CGVector?
			{
				var p = obj as! [Int]
				if p.count < 2
				{
					return nil
				}

				if check is CGPoint?
				{
					return CGPoint(x:p[0],y:p[1]) as? T
				}
				if check is CGSize?
				{
					return CGSize(width:p[0],height:p[1]) as? T
				}
				if check is CGVector?
				{
					return CGVector(dx:p[0],dy:p[1]) as? T
				}
			}
			
			
			
			return obj as? T
		}

		return nil
	}
	
	public func getObject<T>(keyList keyList:String...) -> T?
	{
		return getObject(keyList)
		/*
		if var obj : AnyObject = getAnyObject(keyList)
		{
			return obj as? T
		}
		return nil
*/
	}
	
	
	public func getArrayObject<T>(name:String) -> [T]?
	{
		let nameArray = name.componentsSeparatedByString(".")
		return getArrayObject(nameArray)
	}
	
	public func getArrayObject<T>(keyArray:[String]) -> [T]?
	{
		if let obj : AnyObject = getAnyObject(keyArray)
		{
			var p = obj as! [AnyObject]
			if p.count > 0
			{
				var ret : [T] = []
				for i  in 0 ..< p.count
				{
					ret.append(p[i] as! T)
				}
				return ret
			}
		}
		return nil
	}
	
	public func getArrayObject<T>(keyList keyList:String...) -> [T]?
	{
		return getArrayObject(keyList)
	}
	
	
	
	/*
	public func getCGVectorObject(name:String) -> CGVector?
	{
		var keyArray = name.componentsSeparatedByString(".")
		return getCGVectorObject(keyArray)
	}

	public func getCGVectorObject(keyArray:[String]) -> CGVector?
	{
		if var point = getCGPointObject(keyArray)
		{
			return CGVector(dx:point.x,dy:point.y)
		}
		return nil
	}
	
	public func getCGVectorObject(#keyList:String...) -> CGVector?
	{
		return getCGVectorObject(keyList)
	}
	

	public func getCGSizeObject(name:String) -> CGSize?
	{
		var keyArray = name.componentsSeparatedByString(".")
		return getCGSizeObject(keyArray)
	}
	
	public func getCGSizeObject(keyArray:[String]) -> CGSize?
	{
		if var point = getCGPointObject(keyArray)
		{
			return CGSize(width:point.x,height:point.y)
		}
		return nil
	}
	
	public func getCGSizeObject(#keyList:String...) -> CGSize?
	{
		return getCGSizeObject(keyList)
	}
	
	
	
	public func getCGPointObject(name:String) -> CGPoint?
	{
		var keyArray = name.componentsSeparatedByString(".")
		return getCGPointObject(keyArray)
	}
	
	public func getCGPointObject(keyArray:[String]) -> CGPoint?
	{
		if var obj: AnyObject = getAnyObject(keyArray)
		{
			var p = obj as! [Int]
			if p.count < 2
			{
				return nil
			}
			
			return CGPoint(x:p[0],y:p[1])
		}
		
		return nil
	}
	
	
	
	public func getCGPointObject(#keyList:String...) -> CGPoint?
	{
		return getCGPointObject(keyList)
	}
	
*/
	
	
	//common
	
	public func getAnyObject(keyArray:[String]) -> AnyObject?
	{
		if m_json != nil
		{
			var k = 0
			if keyArray.count > 0
			{
				if var obj: AnyObject = m_json!.valueForKey(keyArray[k])
				{
					k++
					while k < keyArray.count
					{
						if let subObj : AnyObject = obj.valueForKey(keyArray[k])
						{
							obj = subObj
						}
						else
						{
							if m_errorPrintFlag
							{
								print("not found json name list[\(k)]:\(keyArray[k])")
							}
							return nil
						}
						
						k++
					}
					
					return obj
				}
				else
				{
					if m_errorPrintFlag
					{
						print("not found json name top:\(keyArray[k])")
					}
				}
			}
		}
		
		return nil
	}

	public func getAnyObject(keyList keyList:String...) -> AnyObject?
	{
		return getAnyObject(keyList)
	}
	
	public func getAnyObject(keys:String) -> AnyObject?
	{
		let keyArray = keys.componentsSeparatedByString(".")
		return getAnyObject(keyArray)
	}
	
}
