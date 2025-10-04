const std = @import("std");
const Meta = @This();
title: []const u8,
artist: []const u8,
album: []const u8,
length: f64,
trackid: []const u8,

pub fn deinit(self: Meta, allocator: std.mem.Allocator) void {
    allocator.free(self.title);
    allocator.free(self.artist);
    allocator.free(self.album);
    allocator.free(self.trackid);
}

pub fn clone(self: Meta, allocator: std.mem.Allocator) !Meta {
    const title = try allocator.dupe(u8, self.title);
    const artist = try allocator.dupe(u8, self.artist);
    const album = try allocator.dupe(u8, self.album);
    const track_id = try allocator.dupe(u8, self.trackid);

    return .{
        .title = title,
        .album = album,
        .artist = artist,
        .trackid = track_id,
        .length = self.length,
    };
}

pub fn eql(self: Meta, maybe_other: ?Meta) bool {
    const other = maybe_other orelse return false;
    const title_eq = std.mem.eql(u8, self.title, other.title);
    const artist_eq = std.mem.eql(u8, self.artist, other.artist);
    const album_eq = std.mem.eql(u8, self.album, other.album);
    const track_id_eq = std.mem.eql(u8, self.trackid, other.trackid);

    return title_eq and artist_eq and album_eq and self.length == other.length and track_id_eq;
}
