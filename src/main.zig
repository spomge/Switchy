const std = @import("std");
const windows = std.os.windows;
const HWND = windows.HWND;
const BOOL = windows.BOOL;
const SW_SHOWMAXIMIZED = 3;

extern "user32" fn SetForegroundWindow(hWnd: ?HWND) BOOL;
extern "user32" fn ShowWindow(hWnd: ?HWND, nCmdShow: c_int) BOOL;

const input = @import("input.zig");
const window = @import("window.zig");

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len != 3) {
        std.debug.print("You gave me the wrong amount of arguments: {}\n", .{args.len});
        std.debug.print("Usage: Switchy <window_title> <window_title>\n", .{});
        return error.InvalidArgumentCount;
    }

    try input.listen_for_key(struct {
        fn callback(key: []const u8) void {
            const args1 = std.process.argsAlloc(std.heap.page_allocator) catch return;
            defer std.process.argsFree(std.heap.page_allocator, args1);

            if (std.mem.eql(u8, key, "F5")) {
                input.send_key_press(std.heap.page_allocator, &[_]input.Keys{input.Keys.F5}) catch {};
                const FirstWindow = window.findAWindow(args1[1]) orelse return;
                _ = SetForegroundWindow(FirstWindow);
                _ = ShowWindow(FirstWindow, SW_SHOWMAXIMIZED);
            } else if (std.mem.eql(u8, key, "F4")) {
                input.send_key_press(std.heap.page_allocator, &[_]input.Keys{ input.Keys.left_shift, input.Keys.F5 }) catch {};
                const SecondWindow = window.findAWindow(args1[2]) orelse return;
                _ = SetForegroundWindow(SecondWindow);
                _ = ShowWindow(SecondWindow, SW_SHOWMAXIMIZED);
            }
        }
    }.callback);
}
