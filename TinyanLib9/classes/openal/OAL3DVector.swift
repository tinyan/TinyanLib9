//
//  OAL3DVectorSwift.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 4/25/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import Foundation
//import OpenAL

public class OAL3DVectorSwift
{
	public var m_vec:[Float] = [0.0,0.0,0.0]
	
	init()
	{
		self.x = 0
		self.y = 0
		self.z = 0
	}

	init(_x:Float,_y:Float,_z:Float)
	{
		self.x = _x
		self.y = _y
		self.z = _z
	}
	
	public func copy() -> OAL3DVectorSwift
	{
		let obj = OAL3DVectorSwift()
		obj.set(self)
		return obj
	}
	
	public func set(x:Float,_ y:Float,_ z:Float)
	{
		self.x = x
		self.y = y
		self.z = z
	}
	
	public func set(vec:OAL3DVectorSwift)
	{
		self.m_vec = vec.m_vec
	}
	
	public func normalize()
	{
		let s = scale()
		
		if s > 0.0
		{
			mul(1.0/s)
		}
	}
	
	public func distanceFrom(vec:OAL3DVectorSwift) -> Float
	{
		
		let dx:Float = vec.x - self.x
		let dy:Float = vec.y - self.y
		let dz:Float = vec.z - self.z
		
		return sqrt(dx*dx + dy*dy + dz*dz);
	}
	
	public func add(vec:OAL3DVectorSwift)
	{
		x += vec.x
		y += vec.y
		z += vec.z
	}

	public func sub(vec:OAL3DVectorSwift)
	{
		x -= vec.x
		y -= vec.y
		z -= vec.z
	}
	
	public func mul(m:Float)
	{
		x *= m
		y *= m
		z *= m
	}
	
	public func scaleTo(scale:Float)
	{
		normalize()
		mul(scale)
	}
	
	public func scale() -> Float
	{
		return sqrt(x*x + y*y + z*z)
	}

	public var x:Float
	{
		get
		{
			return m_vec[0]
		}
		
		set
		{
			m_vec[0] = newValue
		}
	}
	public var y:Float
		{
		get
		{
			return m_vec[1]
		}
		
		set
		{
			m_vec[1] = newValue
		}
	}
	public var z:Float
		{
		get
		{
			return m_vec[2]
		}
		
		set
		{
			m_vec[2] = newValue
		}
	}
	
	public func rotateZ(radian:Float)
	{
		let _x	= m_vec[0] * cos(radian) - m_vec[1] * sin(radian);
		let _y	= m_vec[0] * sin(radian) + m_vec[1] * cos(radian);
		m_vec[0]		= _x;
		m_vec[1]		= _y;
	}
	
	
}




/*
@interface OAL3DVector : NSObject
{
float* m_vec;
float x,y,z;
}

@property float* vec;


- (id) init;
- (id) init: (float) _x : (float) _y : (float) _z;

- (void) set: (float) _x : (float) _y : (float) _z;
- (void) set: (OAL3DVector *) vector;

- (void) normalize;
- (float) distanceFrom: (OAL3DVector *) vector;

- (void) add: (OAL3DVector *) vector;
- (void) sub: (OAL3DVector *) vector;
- (void) mul: (float) m;
- (void) scaleTo: (float) scale;
- (float) scale;

-(float)x;
-(float)y;
-(float)z;

-(void)setx:(float)_x;
-(void)sety:(float)_y;
-(void)setz:(float)_z;

- (void) rotateZ: (float) radian;
*/



/*
-(id)init
{
if ((self = [super init]))
{
m_vec = (float*)malloc(sizeof(float)*3);
[self set:0:0:0];
}
return self;
}

- (id) init:(float)_x :(float)_y :(float)_z
{
if ((self = [super init]))
{
[self set:_x:_y:_z];
}
return self;
}


- (void) set: (float) _x : (float) _y : (float) _z
{
m_vec[0] = _x;
m_vec[1] = _y;
m_vec[2] = _z;
}

- (void) set: (OAL3DVector *) vector
{
m_vec[0] = [vector x];
m_vec[1] = [vector y];
m_vec[2] = [vector z];
}

- (void) normalize
{
float sum = 0.0;
for (int i = 0;i <3 ;i++)
{
sum += m_vec[i] * m_vec[i];
}

float scale = sqrt(sum);
if (scale > 0.0)
{
m_vec[0] /= scale;
m_vec[1] /= scale;
m_vec[2] /= scale;
}
}



- (void) rotateZ: (float) radian
{
float _x	= m_vec[0] * cos(radian) - m_vec[1] * sin(radian);
float _y	= m_vec[0] * sin(radian) + m_vec[1] * cos(radian);
m_vec[0]		= _x;
m_vec[1]		= _y;
}


- (float) distanceFrom: (OAL3DVector *) vector
{
float dx = [vector x] - m_vec[0];
float dy = [vector y] - m_vec[1];
float dz = [vector z] - m_vec[2];
return sqrt(dx*dx + dy*dy + dz*dz);
}

-(float)x
{
return m_vec[0];
}
-(float)y
{
return m_vec[1];
}
-(float)z
{
return m_vec[2];
}

-(void)setx:(float)_x
{
m_vec[0] = _x;
}
-(void)sety:(float)_y
{
m_vec[1] = _y;
}
-(void)setz:(float)_z
{
m_vec[2] = _z;
}


- (void) add: (OAL3DVector *) vector
{
int i;
for (i = 0; i < 3; i++) m_vec[i] += vector.vec[i];
}

- (void) sub: (OAL3DVector *) vector
{
int i;
for (i = 0; i < 3; i++) m_vec[i] -= vector.vec[i];
}

- (void) mul: (float) m
{
int i;
for (i = 0; i < 3; i++) m_vec[i] *= m;
}

- (void) scaleTo: (float) scale
{
[self normalize];
[self mul: scale];
}

- (float) scale
{
int i;
float sum = 0.0;
for (i = 0; i < 3; i++) sum += m_vec[i] * m_vec[i];
return sqrt(sum);
}


- (void) dealloc
{
free(m_vec);
}

*/