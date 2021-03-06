//
//  CCommonButtonSetup.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2/23/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


public class CCommonButtonSetup
{
	public var m_point : CGPoint!
	public var m_size :  CGSize!
	public var m_sound : Int!
	public var m_number : Int!
	public var m_filename : String!
	public var m_customPicFlag = false
	
	public init(json:CCommonJsonObject,buttonName:String="button")
	{
		if let point : CGPoint = json.getObject(keyList:buttonName,"point")
		{
			m_point = point
		}

		if let buttonSize : CGSize = json.getObject(keyList:buttonName,"size")
		{
			m_size = buttonSize
		}
		
		if let sound : Int = json.getObject(keyList: buttonName,"sound")
		{
			m_sound = sound
		}
		
		if let nm : Int = json.getObject(keyList:buttonName,"number")
		{
			m_number = nm
		}
		
		if let customFlag : Bool = json.getObject(keyList:buttonName,"customPic")
		{
			m_customPicFlag = customFlag
		}
		
		if let filename : String = json.getObject(keyList:buttonName,"filename")
		{
			m_filename = filename
		}
	}
	
}
