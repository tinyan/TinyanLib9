//
//  OALDataSwift.swift
//  TinyanLibSwift
//
//  Created by Tinyan on 4/25/15.
//  Copyright (c) 2015 bugnekosoft. All rights reserved.
//

import UIKit
import Foundation
//import OpenAL.AL
import OpenAL

import AudioToolbox



public class OALDataSwift
{
	var position = OAL3DVectorSwift()
	var velocity = OAL3DVectorSwift()
	var direction = OAL3DVectorSwift()
	


	
	var alSourceID:ALuint = 0
	var alBufferID:ALuint = 0
	
	var isLoaded = false
	
	var theData:[UInt8] = []
	
	init()
	{
	}

	init(file:String,ofType:String)
	{
		loadFile(file, ofType: ofType)
		setVolume(1.0)
	}
	
	
	deinit
	{
		if isLoaded
		{
			
			alSourceStop(alSourceID)
			alDeleteSources(1, &alSourceID)
			alDeleteBuffers(1, &alBufferID)
		}
	}
	
	public var isPlaying:Bool
	{
		get
		{
			var playing:ALint = 0
			alGetSourcei(alSourceID, AL_SOURCE_STATE, &playing)
			return playing == AL_PLAYING
		}
	}
	
	public var isLooped:Bool
	{
		get
		{
			
			var looped:ALint = 0
			alGetSourcei(alSourceID, AL_LOOPING, &looped);
			if looped != 0
			{
				return true
			}
			
			return false
		}
	}

	public func setLooped(looped:Bool)
	{
		if looped
		{
			alSourcei(alSourceID, AL_LOOPING, AL_TRUE)
		}
		else
		{
			alSourcei(alSourceID, AL_LOOPING, AL_FALSE)
		}
	}


	public func loadFile(filename:String,ofType:String)
	{
		
	//	char*	alBuffer;            //data for the buffer
		var alFormatBuffer:ALenum = 0 //for the buffer format
		var alFreqBuffer:ALsizei = 0 //for the frequency of the buffer
		var alBufferLen:ALsizei = 0 //the bit depth
		
		
		let path = NSBundle.mainBundle().pathForResource(filename, ofType: ofType)

		
	//	println("loadwave path=\(path)")
		
//		NSString* path		= [[NSBundle mainBundle] pathForResource: filename ofType: extension];
		if path == nil
		{
			return
		}

		let path0:NSString = path! as NSString
		
		let fpath = path!.cStringUsingEncoding(NSUTF8StringEncoding)
		_ = path0.cStringUsingEncoding(NSUTF8StringEncoding)
		
		
	//	let flen = Int(strlen(fpath!))
	//	let fptr = UnsafePointer<UInt8>(fpath!)
		
		let fileURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, UnsafePointer<UInt8>(fpath!), Int(strlen(fpath!)), false)
//		let fileURL = CFURLCreateFromFileSystemRepresentation(nil, UnsafePointer<UInt8>(fpath!), strlen(fpath!), 0)
		
//		print("create")
		
		let alBuffer = GetOpenALAudioData(fileURL, ofType:ofType,outDataSize:&alBufferLen, outDataFormat:&alFormatBuffer, outSampleRate:&alFreqBuffer)
		//CFRelease(fileURL)
		
	//	println("loadwave path0=\(path0)")
		
	////	println("loadwave fpath=\(fpath)")
	//	println("loadwave fpath0=\(fpath0)")
		
		
		if alBuffer == nil
		{
			return
		}
		
//		print("createok")
		
		alGenSources(1, &alSourceID)
		alGenBuffers(1, &alBufferID)
		
		alBufferData(alBufferID, alFormatBuffer, alBuffer, alBufferLen, alFreqBuffer)
		let err = alGetError()
		if (err == AL_OUT_OF_MEMORY)
		{
		}
		else if (err == AL_INVALID_VALUE)
		{
		}
		
		
		alSourcei(alSourceID, AL_BUFFER, ALint(alBufferID))
		alSourcef(alSourceID, AL_REFERENCE_DISTANCE, 25.0)
		
		setPosition(0,0,0)
		
		isLoaded	= true
	}
	
	
	public func setPosition(vec:OAL3DVectorSwift)
	{
		setPosition(vec.x,vec.y,vec.z)
	}
	
	public func setPosition(x:Float,_ y:Float, _ z:Float)
	{
		position.set(x,y,z)
		alSource3f(alSourceID, AL_POSITION, x, y, z)
	}

	public func setDirection(vec:OAL3DVectorSwift)
	{
		setDirection(vec.x,vec.y,vec.z)
	}

	public func setDirection(x:Float,_ y:Float, _ z:Float)
	{
		direction.set(x, y, z)
		alSource3f(alSourceID, AL_DIRECTION, x, y, z)
	}
	
	public func setVelocity(vec:OAL3DVectorSwift)
	{
		setVelocity(vec.x,vec.y,vec.z)
	}
	
	public func setVelocity(x:Float,_ y:Float, _ z:Float)
	{
		velocity.set(x,y,z)
		alSource3f(alSourceID, AL_VELOCITY, x, y, z)
	}

	public func setReferenceDistance(dist:Float)
	{
		alSourcef(alSourceID, AL_REFERENCE_DISTANCE, dist);
	}

	public func play()
	{
		alSourcePlay(alSourceID)		
	}

	public func stop()
	{
		alSourceStop(alSourceID)
	}
	

	public func setVolume(vol:Float)
	{
		alSourcef(alSourceID, AL_GAIN, vol);
	}
	
	public var volume:Float
	{
		get
		{
			var vol:ALfloat = 0
			alGetSourcef(alSourceID, AL_LOOPING, &vol)
			return vol
		}
	}
	
	func GetOpenALAudioData(inFileURL:CFURLRef, ofType:String,inout outDataSize:ALsizei, inout outDataFormat:ALenum,inout outSampleRate:ALsizei) -> UnsafePointer<UInt8>
	{
		var err = noErr
		
		
		var fileFormat:AudioStreamBasicDescription = AudioStreamBasicDescription()
		var outputFormat:AudioStreamBasicDescription = AudioStreamBasicDescription()
		var audioFileID:AudioFileID = AudioFileID()
		
//		void*							theData = NULL;
		
		var types:AudioFileTypeID = AudioFileTypeID(kAudioFileAIFFType)
		if ofType == "wav"
		{
			types = AudioFileTypeID(kAudioFileWAVEType)
		}
		
		
		
		while true
		{

			print("open1")
			
			err	=	AudioFileOpenURL ( inFileURL,
			AudioFilePermissions.ReadPermission, //fsRdPerm,						// read only
			types, &audioFileID);

			if err != noErr
			{
				break
			}
			print("openok")
			
			var sizeOfASBD:UInt32 = UInt32(sizeofValue(fileFormat))
//			var sizeOfASBD = sizeof(fileFormat.dynamicType)
			
			// Get the AudioStreamBasicDescription format for the playback file
			AudioFileGetProperty (audioFileID,  AudioFilePropertyID(kAudioFilePropertyDataFormat),
				&sizeOfASBD, &fileFormat);
			
			
			if err != noErr
			{
//				print("GetOpenALAudioData: AudioFileGetProperty FAILED, Error = %d", Int(err))
				print("GetOpenALAudioData: AudioFileGetProperty FAILED, Error = ???")
				break
			}
			
			if fileFormat.mChannelsPerFrame > 2
			{
				print("GetOpenALAudioData - Unsupported Format, channel count is greater than stereo")
				break
			}

			let channel = fileFormat.mChannelsPerFrame
			let bitsPerChannel = fileFormat.mBitsPerChannel
			
			print("ch=\(channel) bitsPerCh=\(bitsPerChannel)\n")
			
			// Set the client format to 16 bit signed integer (native-endian) data
			// Maintain the channel count and sample rate of the original source format
			outputFormat.mSampleRate = fileFormat.mSampleRate
			outputFormat.mChannelsPerFrame = channel
			
			outputFormat.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
			outputFormat.mBytesPerPacket = (bitsPerChannel / 8) * channel
			outputFormat.mFramesPerPacket = 1
			
			outputFormat.mBytesPerFrame = (bitsPerChannel / 8) * channel
			outputFormat.mBitsPerChannel = bitsPerChannel
			outputFormat.mFormatFlags = fileFormat.mFormatFlags
			
			//outputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
			
			//Set the desired client (output) data format
			//	err	= AudioFileSetProperty(audioFileID, kAudioFilePropertyDataFormat, sizeOfASBD, &outputFormat);
			//	if(err) { printf("GetOpenALAudioData: AudioFileSetProperty(kAudioFilePropertyDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
			
			// Get the total frame count
			var	fileLengthInFrames:UInt64	= 0
			var	propertySize:UInt32	= UInt32(sizeofValue(fileLengthInFrames))
			err = AudioFileGetProperty(audioFileID, AudioFilePropertyID(kAudioFilePropertyAudioDataPacketCount), &propertySize, &fileLengthInFrames)
			
			if err != noErr
			{
//				print("GetOpenALAudioData: AudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %d", Int(err))
				print("GetOpenALAudioData: AudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = ??")
				break
			}

			// Read all the data into memory
			var	dataSize:UInt32	= UInt32(fileLengthInFrames * UInt64(outputFormat.mBytesPerFrame))
			theData = [UInt8](count:Int(dataSize),repeatedValue:0)

			print("datasize=\(dataSize)")
		//	var ttt:UnsafeMutablePointer<Void> = &theData
			
			//theData					= malloc(dataSize);
			if !theData.isEmpty
			{
				var theDataBuffer:AudioBufferList = AudioBufferList()
				theDataBuffer.mNumberBuffers = 1;
				theDataBuffer.mBuffers.mDataByteSize = dataSize;
				theDataBuffer.mBuffers.mNumberChannels = outputFormat.mChannelsPerFrame;
				theDataBuffer.mBuffers.mData = UnsafeMutablePointer<Void>(theData)
//				theDataBuffer.mBuffers.mData = &theData
				
				//				theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
				//				theDataBuffer.mBuffers[0].mNumberChannels = outputFormat.mChannelsPerFrame;
				//				theDataBuffer.mBuffers[0].mData = theData;
				
				// Read the data into an AudioBufferList
				err = AudioFileReadBytes( audioFileID, Bool(0), Int64(0), &dataSize, &theData)
				// ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
				if err == noErr
				{
					if types == AudioFileTypeID(kAudioFileAIFFType)
					{
						
					//	char* ptr = (char*)theData;
						let lp = Int(dataSize)
						for (var i=0;i<lp;i+=2)
						{
							let c1:UInt8 = theData[i]
							let c2:UInt8 = theData[i+1]
							theData[i] = c2
							theData[i+1] = c1
						}
					}
					
					// success
					outDataSize = ALsizei(dataSize)
					outDataFormat = (outputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16
					outSampleRate = ALsizei(outputFormat.mSampleRate)

				}
				else
				{
					theData = []; // make sure to return NULL
//					print("GetOpenALAudioData: AudioFileReadBytes FAILED, Error = %d", Int(err))
					print("GetOpenALAudioData: AudioFileReadBytes FAILED, Error = ???")
					
				}
			}
			break
		}
		
		if audioFileID != nil
		{
			AudioFileClose(audioFileID)
		}
			
		return UnsafePointer<UInt8>(theData)
		
	}
	
/*
		OSStatus						err = noErr;
		AudioStreamBasicDescription		fileFormat;
		AudioStreamBasicDescription		outputFormat;
		AudioFileID						audioFileID;
		
		void*							theData = NULL;
		
		// Open the File
		int types = kAudioFileAIFFType;
		if ([extension isEqualToString:@"wav"])
		{
		types = kAudioFileWAVEType;
		}
		
		err	=	AudioFileOpenURL ( inFileURL,
		0x01, //fsRdPerm,						// read only
		//							  kAudioFileWAVEType, &audioFileID);
		types, &audioFileID);
		//							  kAudioFileM4AType, &audioFileID);
		
		
		
		
		if (err) { printf("GetOpenALAudioData: AudioFileOpenURL FAILED, Error = %d\n", (int)err); goto Exit; }
		
		UInt32 sizeOfASBD					= sizeof (fileFormat);
		
		// Get the AudioStreamBasicDescription format for the playback file
		AudioFileGetProperty (audioFileID,  kAudioFilePropertyDataFormat,
		&sizeOfASBD, &fileFormat);
		if(err) { printf("GetOpenALAudioData: AudioFileGetProperty FAILED, Error = %d\n", (int)err); goto Exit; }
		if (fileFormat.mChannelsPerFrame > 2)  { printf("GetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n"); goto Exit;}
		
		
		int channel = fileFormat.mChannelsPerFrame;
		int bitsPerChannel = fileFormat.mBitsPerChannel;
		
		// Set the client format to 16 bit signed integer (native-endian) data
		// Maintain the channel count and sample rate of the original source format
		outputFormat.mSampleRate = fileFormat.mSampleRate;
		outputFormat.mChannelsPerFrame = channel;
		
		outputFormat.mFormatID = kAudioFormatLinearPCM;
		outputFormat.mBytesPerPacket = (bitsPerChannel / 8) * channel;
		outputFormat.mFramesPerPacket = 1;
		
		outputFormat.mBytesPerFrame = (bitsPerChannel / 8) * channel;
		outputFormat.mBitsPerChannel = bitsPerChannel;
		outputFormat.mFormatFlags = fileFormat.mFormatFlags;
		
		//outputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
		
		//Set the desired client (output) data format
		//	err	= AudioFileSetProperty(audioFileID, kAudioFilePropertyDataFormat, sizeOfASBD, &outputFormat);
		//	if(err) { printf("GetOpenALAudioData: AudioFileSetProperty(kAudioFilePropertyDataFormat) FAILED, Error = %ld\n", err); goto Exit; }
		
		// Get the total frame count
		SInt64	fileLengthInFrames	= 0;
		UInt32	propertySize		= sizeof(fileLengthInFrames);
		err = AudioFileGetProperty(audioFileID, kAudioFilePropertyAudioDataPacketCount, &propertySize, &fileLengthInFrames);
		if(err) { printf("GetOpenALAudioData: AudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %d\n", (int)err); goto Exit; }
		
		// Read all the data into memory
		UInt32		dataSize	= (UInt32)(fileLengthInFrames * outputFormat.mBytesPerFrame);
		theData					= malloc(dataSize);
		if (theData)
		{
		AudioBufferList		theDataBuffer;
		theDataBuffer.mNumberBuffers = 1;
		theDataBuffer.mBuffers[0].mDataByteSize = dataSize;
		theDataBuffer.mBuffers[0].mNumberChannels = outputFormat.mChannelsPerFrame;
		theDataBuffer.mBuffers[0].mData = theData;
		
		// Read the data into an AudioBufferList
		err = AudioFileReadBytes( audioFileID, false, 0, &dataSize, theData);
		// ExtAudioFileRead(extRef, (UInt32*)&theFileLengthInFrames, &theDataBuffer);
		if(err == noErr)
		{
		if (types == kAudioFileAIFFType)
		{
		
		char* ptr = (char*)theData;
		for (int i=0;i<dataSize;i+=2)
		{
		char c1 = *ptr;
		char c2 = *(ptr+1);
		*ptr = c2;
		*(ptr+1) = c1;
		ptr += 2;
		
		}
		}
		
		
		// success
		*outDataSize = (ALsizei)dataSize;
		*outDataFormat = (outputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
		*outSampleRate = (ALsizei)outputFormat.mSampleRate;
		}
		else
		{
		// failure
		free (theData);
		theData = NULL; // make sure to return NULL
		printf("GetOpenALAudioData: AudioFileReadBytes FAILED, Error = %d\n", (int)err); goto Exit;
		}
		}
		
		Exit:
		// Dispose the ExtAudioFileRef, it is no longer needed
		if (audioFileID) AudioFileClose(audioFileID);
		return theData;
		
*/

	

	
}



/*
@interface OALData : NSObject {
//OALModel	*model;

OAL3DVector	*position;
OAL3DVector	*velocity;
OAL3DVector	*direction;

unsigned int	alSourceID;
unsigned int	alBufferID;

BOOL			isLoaded;
}

@property (readonly) BOOL isLoaded;
@property (readwrite, getter=isLooped) BOOL looped;
@property (readonly) BOOL isPlaying;
@property (readwrite, assign) OAL3DVector *position;
@property (readwrite, assign) OAL3DVector *velocity;
@property (readwrite, assign) OAL3DVector *direction;

- (id) initWithFile: (NSString *) filename ofType: (NSString *) extension;

- (void) loadFile: (NSString *) filename ofType: (NSString *) extension;

- (void) setPosition: (float) x : (float) y : (float) z;
- (void) setDirection: (float) x : (float) y : (float) z;
- (void) setVelocity: (float) x : (float) y : (float) z;

- (void) setReferenceDistance: (float) dist;

- (void) play;
- (void) stop;
- (BOOL) isPlaying;

- (void) setLooped: (BOOL) looped;
- (BOOL) isLooped;

- (void) setVolume: (float) vol;
- (float) volume;
*/