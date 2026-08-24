const std = @import("std");
const assert = std.debug.assert;
const fatal = std.process.fatal;
const Io = std.Io;

const mct = @import("mct");

const log = std.log.scoped(.default);

const Command = enum { help, encode, decode };
const cmd_map: std.StaticStringMap(Command) = .initComptime(.{
    .{ "help", .help },
    .{ "encode", .encode },
    .{ "decode", .decode },
});

pub fn main(init: std.process.Init) !void {
    const gpa = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(gpa);

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;
    defer stdout_writer.flush() catch {};

    if (args.len < 2) {
        try printHelp(stdout_writer);
        fatal("Requires at least 2 arguments.", .{});
    }

    const cmd = cmd_map.get(args[1]) orelse fatal("Invalid command: {s}", .{args[1]});
    switch (cmd) {
        .help => try printHelp(stdout_writer),
        .encode => {
            if (args.len != 3) fatal("Missing argument {{message}}", .{});
            const msg = try mct.encode(gpa, try gpa.dupe(u8, args[2]));
            try stdout_writer.print("{s}\n", .{msg});
        },
        .decode => {
            if (args.len != 3) fatal("Missing argument {{message}}", .{});
            const msg = try mct.decode(gpa, try gpa.dupe(u8, args[2]));
            try stdout_writer.print("{s}\n", .{msg});
        },
    }
}

fn printHelp(w: *Io.Writer) !void {
    try w.print("Usage: {s}", .{usage});
}

const usage =
    \\ mct [help | encode | decode] "{message}"
    \\ commands:
    \\   help   - print this help
    \\   encode - encode {message}
    \\   decode - decode {message}
    \\
;
