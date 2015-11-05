//
//  CCommonSoundControl.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 2014/08/24.
//  Copyright (c) 2014 bugnekosoft. All rights reserved.
//

import Foundation
import AVFoundation


import OpenAL

let MY_OAL_SOUND_MAX = 256

public class CCommonSoundControl
{
	var m_soundMax : Int
	
	var a : ALuint = 0
	
	
	
//	var m_openALControl : OALControlSwift?
//	var m_openALData = [OALDataSwift?](count: MY_OAL_SOUND_MAX, repeatedValue: nil)
//	var m_openALControl : OALControl?
//	var m_openALData = [OALData?](count: MY_OAL_SOUND_MAX, repeatedValue: nil)
	
	var m_player  = [AVAudioPlayer?](count:MY_OAL_SOUND_MAX,repeatedValue:nil)
	
	public init()
	{
		m_soundMax = MY_OAL_SOUND_MAX
		let session : AVAudioSession = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryAmbient)
		
//		m_openALControl = OALControlSwift()
		//m_openALControl = OALControl()
	}
	
	public func loadCAF(n:Int , name:String) -> Bool
	{
		return self.load(n , name:name , ofType:"caf")
	}
	
	public func loadAiff(n : Int , name : String) -> Bool
	{
		return self.load(n , name:name , ofType:"aiff")
	}

	public func loadWave(n : Int , name : String) -> Bool
	{
		return self.load(n , name:name , ofType:"wav")
	}
	
	public func load(n : Int , name : String , ofType : String) -> Bool
	{
		if (n < 0) || (n >= m_soundMax) {return false}
		
		if m_player[n] != nil
		{
			return false
		}
		
		let path : String = NSBundle.mainBundle().pathForResource(name, ofType: ofType)!
		let url : NSURL = NSURL.fileURLWithPath(path)
		try! m_player[n] = AVAudioPlayer(contentsOfURL: url)
		
		
		
		
//		if m_openALData[n] != nil {return false}
		
//		m_openALData[n] = OALDataSwift(file: name , ofType : ofType)
//		m_openALData[n] = OALData(file: name , ofType : ofType)
		
		return true
	}
	
	public func setPositon(n : Int , position : [Float])
	{
		if (n>=0) && (n<m_soundMax)
		{
//			m_openALData[n]?.setPosition(position[0]  ,position[1]  ,position[2])
		}
	}
	
	
	public func setVolume(n : Int , volume : Float)
	{
		if (n>=0) && (n<m_soundMax)
		{
//			m_openALData[n]?.setVolume(volume)
		}
	}
	
	public func play(n : Int)
	{
		if (n>=0) && (n<m_soundMax)
		{
			if let player = m_player[n]
			{
				player.play()
			}
//			m_openALData[n]?.play()
		}
	}
	
	public func stop(n : Int)
	{
		if (n>=0) && (n<m_soundMax)
		{
//			m_openALData[n]?.stop()
		}
	}
	
}

