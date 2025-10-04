//
//  lib.swift
//  AppleMusicCtrlLib
//
//  Created by Frederick Lahde on 03.10.25.
//


import Foundation

public class AppleMusicCtrl {
    private var songNameScript: NSAppleScript
    private var albumNameScript: NSAppleScript
    private var artistNameScript: NSAppleScript
    private var playTimeScript: NSAppleScript
    private var isCompiled: Bool = false

    public init() {
       self.songNameScript = NSAppleScript(source: """
        tell application "Music"
            if (exists current track) then
                return name of current track
            else
                return "nothing"
            end if
        end tell
        """)!

       self.albumNameScript = NSAppleScript(source: """
        tell application "Music"
            if (exists current track) then
                return album of current track
            else
                return "nothing"
            end if
        end tell
        """)!
        
        self.artistNameScript = NSAppleScript(source: """
         tell application "Music"
             if (exists current track) then
                 return artist of current track
             else
                 return "nothing"
             end if
         end tell
         """)!
        
        self.playTimeScript = NSAppleScript(source: """
         tell application "Music"
             if (exists current track) then
                 return player position as string & ""
             else
                 return "nothing"
             end if
         end tell
         """)!
    }

    public func compile() {
        assert(!self.isCompiled)
        
        var error: NSDictionary?
        songNameScript.compileAndReturnError(&error)
        
        if let error = error {
            NSLog("Compile error: \(error)")
        }
        
        isCompiled = true
    }

    public func getSongName() -> String {
        assert(self.isCompiled)
        var error: NSDictionary?
        let result = songNameScript.executeAndReturnError(&error)
        if let error = error {
            NSLog("Execution error: \(error)")
            return "error"
        }
        return result.stringValue ?? "unknown"
    }

    public func getAlbumName() -> String {
        assert(self.isCompiled)
        var error: NSDictionary?
        let result = albumNameScript.executeAndReturnError(&error)
        if let error = error {
            NSLog("Execution error: \(error)")
            return "error"
        }
        return result.stringValue ?? "unknown"
    }
    
    public func getArtistName() -> String {
        assert(self.isCompiled)
        var error: NSDictionary?
        let result = artistNameScript.executeAndReturnError(&error)
        if let error = error {
            NSLog("Execution error: \(error)")
            return "error"
        }
        return result.stringValue ?? "unknown"
    }
    
    public func getPlayTime() -> String {
        assert(self.isCompiled)
        var error: NSDictionary?
        let result = playTimeScript.executeAndReturnError(&error)
        if let error = error {
            NSLog("Execution error: \(error)")
            return "error"
        }
        return result.stringValue ?? "unknown"
    }
}

@_cdecl("AppleMusicCtrl_create")
public func AppleMusicCtrl_create() -> UnsafeMutableRawPointer {
    let instance = AppleMusicCtrl()
    return UnsafeMutableRawPointer(Unmanaged.passRetained(instance).toOpaque())
}

@_cdecl("AppleMusicCtrl_compile")
public func AppleMusicCtrl_compile(ptr: UnsafeMutableRawPointer) {
    let instance = Unmanaged<AppleMusicCtrl>.fromOpaque(ptr).takeUnretainedValue()
    instance.compile()
}

@_cdecl("AppleMusicCtrl_get_song_name")
public func AppleMusicCtrl_get_song_name(ptr: UnsafeMutableRawPointer) -> UnsafeMutablePointer<CChar>? {
    let instance = Unmanaged<AppleMusicCtrl>.fromOpaque(ptr).takeUnretainedValue()
    let name = instance.getSongName()
    return strdup(name)
}

@_cdecl("AppleMusicCtrl_get_album_name")
public func AppleMusicCtrl_get_album_name(ptr: UnsafeMutableRawPointer) -> UnsafeMutablePointer<CChar>? {
    let instance = Unmanaged<AppleMusicCtrl>.fromOpaque(ptr).takeUnretainedValue()
    let name = instance.getAlbumName()
    return strdup(name)
}

@_cdecl("AppleMusicCtrl_get_artist_name")
public func AppleMusicCtrl_get_artist_name(ptr: UnsafeMutableRawPointer) -> UnsafeMutablePointer<CChar>? {
    let instance = Unmanaged<AppleMusicCtrl>.fromOpaque(ptr).takeUnretainedValue()
    let name = instance.getArtistName()
    return strdup(name)
}

@_cdecl("AppleMusicCtrl_get_play_time")
public func AppleMusicCtrl_get_play_time(ptr: UnsafeMutableRawPointer) -> UnsafeMutablePointer<CChar>? {
    let instance = Unmanaged<AppleMusicCtrl>.fromOpaque(ptr).takeUnretainedValue()
    let time = instance.getPlayTime()
    return strdup(time)
}

@_cdecl("AppleMusicCtrl_destroy")
public func AppleMusicCtrl_destroy(ptr: UnsafeMutableRawPointer) {
    Unmanaged<AppleMusicCtrl>.fromOpaque(ptr).release()
}
