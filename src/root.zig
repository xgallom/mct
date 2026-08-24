//! Morse code
const std = @import("std");
const Io = std.Io;
const Allocator = std.mem.Allocator;

const log = std.log.scoped(.mct);

pub fn decode(gpa: Allocator, src: []u8) ![]u8 {
    if (src.len == 0) return "";
    var w = Io.Writer.Allocating.init(gpa);
    errdefer w.deinit();
    var walk = src;
    var end: usize = 0;
    while (end < walk.len) {
        switch (walk[end]) {
            '.', '-' => end += 1,
            '_' => {
                walk[end] = '-';
                end += 1;
            },
            ' ' => {
                const result = decode_map.get(walk[0..end]);
                if (result) |str| {
                    try w.writer.writeAll(str);
                } else {
                    log.err("Invalid sequence: {s}", .{walk[0..end]});
                    return error.InvalidSequence;
                }
                walk = walk[end + 1 ..];
                end = 0;
            },
            '/' => {
                try w.writer.writeByte(' ');
                walk = walk[end + 1 ..];
                end = 0;
            },
            else => {
                log.err("Invalid character: {c}", .{walk[end]});
                return error.InvalidCharacter;
            },
        }
    }
    const result = decode_map.get(walk);
    if (result) |str| {
        try w.writer.writeAll(str);
    } else {
        log.err("Invalid sequence: {s}", .{walk});
        return error.InvalidSequence;
    }
    try w.writer.flush();
    return try w.toOwnedSlice();
}

pub fn encode(gpa: Allocator, src: []const u8) ![]const u8 {
    if (src.len == 0) return "";
    var w = Io.Writer.Allocating.init(gpa);
    errdefer w.deinit();
    for (0..src.len) |n| {
        const result = encode_map.get(src[n .. n + 1]);
        if (result) |str| {
            try w.writer.writeAll(str);
        } else {
            log.err("Invalid character: {c}", .{src[n]});
            return error.InvalidCharacter;
        }
    }
    try w.writer.flush();
    return std.mem.trimEnd(u8, try w.toOwnedSlice(), &std.ascii.whitespace);
}

const decode_map: std.StaticStringMap([]const u8) = .initComptime(.{
    .{ "", "" },
    .{ ".", "E" },
    .{ "-", "T" },
    .{ "..", "I" },
    .{ ".-", "A" },
    .{ "-.", "N" },
    .{ "--", "M" },
    .{ "...", "S" },
    .{ "..-", "U" },
    .{ ".-.", "R" },
    .{ ".--", "W" },
    .{ "-..", "D" },
    .{ "-.-", "K" },
    .{ "--.", "G" },
    .{ "---", "O" },
    .{ "....", "H" },
    .{ "...-", "V" },
    .{ "..-.", "F" },
    .{ ".-..", "L" },
    .{ ".--.", "P" },
    .{ ".---", "J" },
    .{ "-...", "B" },
    .{ "-..-", "X" },
    .{ "-.-.", "C" },
    .{ "-.--", "Y" },
    .{ "--.-", "Q" },
    .{ "--..", "Z" },
    .{ ".....", "5" },
    .{ "....-", "4" },
    .{ "...--", "3" },
    .{ "..---", "2" },
    .{ ".----", "1" },
    .{ "-....", "6" },
    .{ "--...", "7" },
    .{ "---..", "8" },
    .{ "----.", "9" },
    .{ "-----", "0" },
    .{ ".-.-.-", "." },
    .{ "--..--", "," },
    .{ "..--..", "?" },
    .{ "-..-.", "/" },
});

const encode_map: std.StaticStringMap([]const u8) = .initComptime(.{
    .{ "E", ". " },
    .{ "T", "- " },
    .{ "I", ".. " },
    .{ "A", ".- " },
    .{ "N", "-. " },
    .{ "M", "-- " },
    .{ "S", "... " },
    .{ "U", "..- " },
    .{ "R", ".-. " },
    .{ "W", ".-- " },
    .{ "D", "-.. " },
    .{ "K", "-.- " },
    .{ "G", "--. " },
    .{ "O", "--- " },
    .{ "H", ".... " },
    .{ "V", "...- " },
    .{ "F", "..-. " },
    .{ "L", ".-.. " },
    .{ "P", ".--. " },
    .{ "J", ".--- " },
    .{ "B", "-... " },
    .{ "X", "-..- " },
    .{ "C", "-.-. " },
    .{ "Y", "-.-- " },
    .{ "Q", "--.- " },
    .{ "Z", "--.. " },
    .{ "e", ". " },
    .{ "t", "- " },
    .{ "i", ".. " },
    .{ "a", ".- " },
    .{ "n", "-. " },
    .{ "m", "-- " },
    .{ "s", "... " },
    .{ "u", "..- " },
    .{ "r", ".-. " },
    .{ "w", ".-- " },
    .{ "d", "-.. " },
    .{ "k", "-.- " },
    .{ "g", "--. " },
    .{ "o", "--- " },
    .{ "h", ".... " },
    .{ "v", "...- " },
    .{ "f", "..-. " },
    .{ "l", ".-.. " },
    .{ "p", ".--. " },
    .{ "j", ".--- " },
    .{ "b", "-... " },
    .{ "x", "-..- " },
    .{ "c", "-.-. " },
    .{ "y", "-.-- " },
    .{ "q", "--.- " },
    .{ "z", "--.. " },
    .{ "5", "..... " },
    .{ "4", "....- " },
    .{ "3", "...-- " },
    .{ "2", "..--- " },
    .{ "1", ".---- " },
    .{ "6", "-.... " },
    .{ "7", "--... " },
    .{ "8", "---.. " },
    .{ "9", "----. " },
    .{ "0", "----- " },
    .{ ".", ".-.-.- " },
    .{ ",", "--..-- " },
    .{ "?", "..--.. " },
    .{ "/", "-..-. " },
    .{ " ", "/ " },
});
