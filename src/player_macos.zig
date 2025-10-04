const std = @import("std");
const assert = std.debug.assert;
const Meta = @import("Meta.zig");

const C = @cImport({
    @cInclude("AppleMusicCtrlLib-Bridging-Header.h");
    @cInclude("stdlib.h");
});

const Music = struct {
    ptr: ?*anyopaque = null,

    pub fn init() Music {
        const p = C.AppleMusicCtrl_create();
        assert(p != null);
        C.AppleMusicCtrl_compile(p);

        return .{ .ptr = p };
    }

    pub fn deinit(self: Music) void {
        C.AppleMusicCtrl_destroy(self.ptr);
    }

    pub fn song_name(self: Music, allocator: std.mem.Allocator) ![]const u8 {
        const ret = C.AppleMusicCtrl_get_song_name(self.ptr);
        assert(ret != null);
        defer C.free(@ptrCast(@constCast(ret)));

        const len = std.mem.len(ret);
        const buffer = try allocator.alloc(u8, len);

        std.mem.copyForwards(u8, buffer, ret[0..len]);
        if (std.mem.eql(u8, buffer, "nothing")) {
            return error.notReady;
        }

        return buffer;
    }

    pub fn album_name(self: Music, allocator: std.mem.Allocator) ![]const u8 {
        const ret = C.AppleMusicCtrl_get_album_name(self.ptr);
        assert(ret != null);
        defer C.free(@ptrCast(@constCast(ret)));

        const len = std.mem.len(ret);
        const buffer = try allocator.alloc(u8, len);

        std.mem.copyForwards(u8, buffer, ret[0..len]);
        if (std.mem.eql(u8, buffer, "nothing")) {
            return error.notReady;
        }

        return buffer;
    }

    pub fn artist_name(self: Music, allocator: std.mem.Allocator) ![]const u8 {
        const ret = C.AppleMusicCtrl_get_artist_name(self.ptr);
        assert(ret != null);
        defer C.free(@ptrCast(@constCast(ret)));

        const len = std.mem.len(ret);
        const buffer = try allocator.alloc(u8, len);

        std.mem.copyForwards(u8, buffer, ret[0..len]);
        if (std.mem.eql(u8, buffer, "nothing")) {
            return error.notReady;
        }

        return buffer;
    }

    pub fn play_time(self: Music, allocator: std.mem.Allocator) !f64 {
        const ret = C.AppleMusicCtrl_get_play_time(self.ptr);
        assert(ret != null);
        defer C.free(@ptrCast(@constCast(ret)));

        const len = std.mem.len(ret);
        const buffer = try allocator.alloc(u8, len);
        defer allocator.free(buffer);

        std.mem.copyForwards(u8, buffer, ret[0..len]);
        if (std.mem.eql(u8, buffer, "nothing")) {
            return error.notReady;
        }

        const replaced = try std.mem.replaceOwned(u8, allocator, buffer, ",", ".");
        defer allocator.free(replaced);

        const f = try std.fmt.parseFloat(f64, replaced);

        return f;
    }
};

const Player = @This();

music: Music,

pub fn init() !Player {
    return .{ .music = Music.init() };
}

fn allocPrintZ(
    allocator: std.mem.Allocator,
    comptime fmt: []const u8,
    args: anytype,
) ![:0]u8 {
    const tmp = try std.fmt.allocPrint(allocator, fmt, args);
    defer allocator.free(tmp);
    var result = try allocator.allocSentinel(u8, tmp.len, 0);
    @memcpy(result[0..tmp.len], tmp);
    return result;
}

fn deinit(player: Player) void {
    player.music.deinit();
}

fn fetchMetadata(player: Player, allocator: std.mem.Allocator, player_name: []const u8, meta: *Meta) !void {
    _ = player_name; // autofix

    meta.artist = try player.music.artist_name(allocator);
    meta.album = try player.music.album_name(allocator);
    meta.title = try player.music.song_name(allocator);
    meta.length = 1024;
}

pub fn getPosition(player: Player, allocator: std.mem.Allocator, player_name: []const u8) f64 {
    _ = player_name; // autofix
    return player.music.play_time(allocator) catch return 0.0;
    // }
}

pub fn getStatus(player: Player, allocator: std.mem.Allocator, player_name: []const u8) []const u8 {
    _ = player_name; // autofix
    _ = allocator; // autofix
    _ = player; // autofix
    return "Playing";
}

pub fn getMeta(player: Player, allocator: std.mem.Allocator, player_name: []const u8) Meta {
    var m = Meta{
        .title = allocator.dupe(u8, "") catch unreachable,
        .artist = allocator.dupe(u8, "") catch unreachable,
        .album = allocator.dupe(u8, "") catch unreachable,
        .length = 0.0,
        .trackid = allocator.dupe(u8, "") catch unreachable,
    };

    player.fetchMetadata(allocator, player_name, &m) catch {};
    return m;
}

pub fn listPlayers(player: Player, allocator: std.mem.Allocator) ![][]u8 {
    _ = player; // autofix
    var ret = std.ArrayList([]u8).empty;
    try ret.append(allocator, @constCast("apple-music"));
    return try ret.toOwnedSlice(allocator);
}

pub fn waitForChange(player: Player, player_name: []const u8, timeout_ms: i32) !bool {
    _ = player_name; // autofix
    _ = player; // autofix
    _ = timeout_ms; // autofix
    return true;
}
