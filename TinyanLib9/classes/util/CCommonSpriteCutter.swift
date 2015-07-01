//
//  CCommonSpriteCutter.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 1/24/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


public class CCommonSpriteCutter
{
	var m_texture : SKTexture
	var m_blockX : Int
	var m_blockY : Int
	
	var m_cutTexture : [SKTexture?]
	
	public init(filename:String , x:Int , y:Int)
	{
		m_texture = SKTexture(imageNamed: filename)
		m_blockX = x
		m_blockY = y
		m_cutTexture = [SKTexture?](count:x*y , repeatedValue:nil)
		
	}
	
	public func cutSprite(n:Int) -> SKTexture
	{
		let nx:Int = n % m_blockX
		let ny:Int = n / m_blockX
		return self.cutSprite(x: nx, y: ny)
	}
	
	public func cutSprite(x x:Int , y:Int) -> SKTexture
	{
		//println("x=\(x)y=\(y)")
		var n = y * m_blockX
		n += x
		
		if let existTtexture = m_cutTexture[n]
		{
			return existTtexture
		}
		
		let sizeX = CGFloat(1.0) / CGFloat(m_blockX)
		let sizeY = CGFloat(1.0) / CGFloat(m_blockY)
		
		let startX = CGFloat(x) * sizeX
		var startY = CGFloat(y) * sizeY
		startY *= -1.0
		startY += 1.0
		
		startY -= sizeY
		
		
		let texture = SKTexture(rect: CGRect(x:startX,y:startY,width:sizeX,height:sizeY), inTexture: m_texture)
		m_cutTexture[n] = texture
		
		return texture
	}
}


