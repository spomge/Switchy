const std = @import("std");
const windows = std.os.windows;

// Import custom modules
const input = @import("input.zig");
const window = @import("window.zig");
const args = @import("args.zig");

pub fn main() !void {
    // Get command line arguments
    const commandLineArgs = args.getProcessArgs() orelse return error.FailedToGetArgs;

    //checks if the user has entered the correct number of arguments
    _ = try args.checkArgs(commandLineArgs);

    // Check if the windows are open
    _ = window.findAWindow(commandLineArgs[1]) orelse return error.WindowNotFound1;
    _ = window.findAWindow(commandLineArgs[2]) orelse return error.WindowNotFound2;

    // Check if the arguments are valid
    if (try args.checkArgs(commandLineArgs)) {
        // Start listening for key inputs
        try input.listen_for_key(struct {
            fn callback(key: []const u8) void {
                // Get fresh command line arguments
                const commandLineArgs2 = args.getProcessArgs() orelse return;

                // Extract window titles and key bindings from arguments
                const WindowTitle1 = commandLineArgs2[1];
                const WindowTitle2 = commandLineArgs2[2];
                const Key1 = commandLineArgs2[3];
                const Key2 = commandLineArgs2[4];

                // Handle key presses
                if (std.mem.eql(u8, key, Key1)) {
                    // Find and focus the first window
                    // IMPORTANT: This is necessary to make the window appear on top of other windows
                    // Without it, the window will not be focused
                    // You can change this to whatever you want (key press or mouse click)
                    input.send_mouse_click(std.heap.page_allocator, 1920 / 2, 1080 / 2) catch {};

                    const FirstWindow = window.findAWindow(WindowTitle1) orelse {
                        std.debug.print("Window 1 is no longer open\n", .{});
                        return;
                    };
                    _ = window.showWindow(FirstWindow);
                    _ = window.setForegroundWindow(FirstWindow);

                    // If you want to do run a command after the window is focused, you can do it here

                    // Example:
                    // This hits the enter key after the window is focused
                    // input.send_key_press(std.heap.page_allocator, &.{input.Keys.ENTER}) catch {};

                    // For Roblox studio the default play key is F5
                    input.send_key_press(std.heap.page_allocator, &.{input.Keys.F5}) catch {};
                } else if (std.mem.eql(u8, key, Key2)) {

                    // For Roblox studio the default stop key is F5 + shift
                    input.send_key_press(std.heap.page_allocator, &.{
                        input.Keys.left_shift,
                        input.Keys.F5,
                    }) catch {};

                    // Find and focus the second window
                    const SecondWindow = window.findAWindow(WindowTitle2) orelse {
                        std.debug.print("Window 2 is no longer open\n", .{});
                        return;
                    };
                    _ = window.showWindow(SecondWindow);
                    _ = window.setForegroundWindow(SecondWindow);

                    // If you want to do run a command after the window is focused, you can do it here

                    // Example:
                    // This hits the enter key after the window is focused
                    // input.send_key_press(std.heap.page_allocator, &.{input.Keys.ENTER}) catch {};

                }
            }
        }.callback);
    }
}
