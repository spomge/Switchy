const std = @import("std");

const process = std.process;

pub fn getProcessArgs() ?[][]u8 {
    const argsAlloc = process.argsAlloc(std.heap.page_allocator) catch {
        std.debug.print("Failed to allocate memory for args\n", .{});
        return null;
    };
    return argsAlloc;
}

pub fn printUsage() void {
    std.debug.print("\nUsage: Switchy <window_title1> <window_title2> <key1> <key2>\n", .{});
}

pub fn checkArgs(args: [][]u8) !bool {
    if (args.len != 5) {
        printUsage();
        return error.InvalidArgumentCount;
    }
    return true;
}
