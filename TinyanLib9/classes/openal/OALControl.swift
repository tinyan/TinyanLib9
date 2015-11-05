//
//  OALControlSwift.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 4/25/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
import OpenAL

public class OALControlSwift
{

	var isInited = false
	var listenerPos = OAL3DVectorSwift()
	var listenerFace = OAL3DVectorSwift()
	var listenerUp = OAL3DVectorSwift()

	init()
		
	{
		initOpenAL()
	}
	
	func initOpenAL() -> Bool
	{
		let device = alcOpenDevice(nil)
		
		if device != nil
		{
			let context = alcCreateContext(device, nil)
			if context != nil
			{
				alcMakeContextCurrent(context)
				setListenerPosition(0.0, 0.0, 0.0)
				setListenerFace(0.0,1.0,0.0,0.0,0.0,1.0)
				return true
			}
		}
		
		alGetError()
		return false
	}

	public func setListenerPosition(x:Float,_ y:Float, _ z:Float)
	{
		listenerPos.set(x, y, z)
		alListener3f(AL_POSITION, x, y, z)
	}

	public func setListenerPosition(vec:OAL3DVectorSwift)
	{
		listenerPos.set(vec)
		alListenerfv(AL_POSITION, listenerPos.m_vec)
	}

	public func setListenerFace(fx:Float, _ fy:Float, _ fz:Float, _ ux:Float, _ uy:Float, _ uz:Float)
	{
		listenerFace.set(fx, fy, fz)
		listenerUp.set(ux,uy,uz)
		
		let vec:[Float] = [fx,fy,fz,ux,uy,uz]
		alListenerfv(AL_ORIENTATION, vec)
	}
	

	public func setListenerFace(face:OAL3DVectorSwift,up:OAL3DVectorSwift)
	{
		listenerFace.set(face)
		listenerUp.set(up)
		let vec:[Float] = [face.x,face.y,face.z,up.x,up.y,up.z]
		alListenerfv(AL_ORIENTATION, vec)
	}

	public func moveListenerForward(dist:Float)
	{
		let face = listenerFace.copy()
		face.scaleTo(dist)
		listenerPos.add(face)
		setListenerPosition(listenerPos)
	}
	

	public func rotateListener(degree:Float)
	{
		let rad = degree * Float(M_PI) / 180.0
		listenerFace.rotateZ(rad)
		setListenerFace(listenerFace,up:listenerUp)
	}

	

	deinit
	{
		let Context = alcGetCurrentContext()
		let Device = alcGetContextsDevice(Context)
		alcMakeContextCurrent(nil)
		alcDestroyContext(Context)
		alcCloseDevice(Device)
	}
}


/*
#define		DEFAULT_VOLUME	 1.0

void* GetOpenALAudioData(CFURLRef inFileURL, NSString* extension,ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);


@implementation OALControl


- (id) init
{
if (self = [super init])
{
listenerPos		= [[OAL3DVector alloc] init];		// Position
listenerFace	= [[OAL3DVector alloc] init];		// Forward Vector
listenerUp		= [[OAL3DVector alloc] init];		// Up Vector

BOOL b = [self initOpenAL];
if (!b)
{
//
}
}
return self;
}


- (BOOL) initOpenAL
{
ALCcontext		*context	= NULL;
ALCdevice		*device		= NULL;

device = alcOpenDevice(NULL);
if (device != NULL){
context = alcCreateContext(device, 0);
if (context != NULL){
alcMakeContextCurrent(context);
} else {
return NO;
}
} else {
return NO;
}

alGetError();

[self setListenerPosition: 0 : 0 : 0];
[self setListenerFace: 0 : 1 : 0 up: 0 : 0 : 1];
return YES;
}


- (void) setListenerPosition: (float) x : (float) y : (float) z
{
[listenerPos	set: x : y : z];

alListener3f(AL_POSITION, x, y, z);
}

- (void) setListenerPosition: (OAL3DVector *) vec
{
[listenerPos	set: vec];

alListenerfv(AL_POSITION, listenerPos.vec);
}



- (void) setListenerFace: (float) fx : (float) fy : (float) fz up: (float) ux : (float) uy : (float) uz
{
[listenerFace	set: fx : fy : fz];
[listenerUp		set: ux : uy : uz];

float vec[6];
vec[0] = fx;	//forward vector x value
vec[1] = fy;	//forward vector y value
vec[2] = fz;	//forward vector z value
vec[3] = ux;	//up vector x value
vec[4] = uy;	//up vector y value
vec[5] = uz;	//up vector z value

//set current listener orientation
alListenerfv(AL_ORIENTATION, vec);
}

- (void) setListenerFace: (OAL3DVector *)face up: (OAL3DVector *)up
{
[listenerFace	set: face];
[listenerUp		set: up];

float vec[6];
vec[0] = face.x;	//forward vector x value
vec[1] = face.y;	//forward vector y value
vec[2] = face.z;	//forward vector z value
vec[3] = up.x;		//up vector x value
vec[4] = up.y;		//up vector y value
vec[5] = up.z;		//up vector z value

alListenerfv(AL_ORIENTATION, vec);
}

- (void) moveListenerForward: (float) dist
{
OAL3DVector *face	= [listenerFace copy];
[face scaleTo: dist];
[listenerPos add: face];
[self setListenerPosition: listenerPos];
}

- (void) rotateListener: (float) degree
{
float rad = degree * M_PI / 180.0;
[listenerFace rotateZ:rad];
[self setListenerFace: listenerFace	up: listenerUp];
}


- (void) dealloc
{
ALCcontext *Context = alcGetCurrentContext();

ALCdevice *Device = alcGetContextsDevice(Context);

alcMakeContextCurrent(NULL);

alcDestroyContext(Context);

alcCloseDevice(Device);

}


*/