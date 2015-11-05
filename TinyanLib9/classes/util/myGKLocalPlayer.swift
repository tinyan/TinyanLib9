//
//  myGKLocalPlayer.swift
//  TinyanLib9
//
//  Created by Tinyan on 7/24/15.
//  Copyright © 2015 bugnekosoft. All rights reserved.
//

import Foundation
import GameKit


class myGKLocalPlayer
{
	static var m_localPlayer : GKLocalPlayer? = nil
	
	static func localPlayer() -> GKLocalPlayer
	{
		if m_localPlayer == nil
		{
			m_localPlayer = GKLocalPlayer()
		}
		
		return m_localPlayer!
	}
	
}