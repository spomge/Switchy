const std = @import("std");
const windows = std.os.windows;
const HWND = windows.HWND;
const BOOL = windows.BOOL;
const LPARAM = windows.LPARAM;

const WNDENUMPROC = *const fn (hWnd: ?HWND, lParam: LPARAM) BOOL;
const user32 = struct {
    pub extern "user32" fn GetWindowTextA(hWnd: ?HWND, lpString: [*:0]u8, nMaxCount: c_int) c_int;
    pub extern "user32" fn SetForegroundWindow(hWnd: ?HWND) BOOL;
    pub extern "user32" fn ShowWindow(hWnd: ?HWND, nCmdShow: c_int) BOOL;
    pub extern "user32" fn EnumWindows(lpEnumFunc: ?WNDENUMPROC, lParam: LPARAM) BOOL;
};

const EnumWindowsContext = struct {
    foundWindow: ?HWND,
    title: []const u8,
};

fn enumWindowsProc(hWnd: ?HWND, lparam: LPARAM) BOOL {
    var title: [256:0]u8 = undefined;

    _ = user32.GetWindowTextA(hWnd, &title, @intCast(title.len));

    const to_usize: usize = @intCast(lparam);
    const context: *EnumWindowsContext = @ptrFromInt(to_usize);

    const hasRobloxStudioTitle = std.mem.indexOf(u8, &title, context.title) != null;

    if (hasRobloxStudioTitle) {
        context.foundWindow = hWnd;
        return 0;
    }

    return 1; // Continue enumeration
}

pub fn findAWindow(text: []const u8) ?HWND {
    var context = EnumWindowsContext{
        .foundWindow = null,
        .title = text,
    };

    _ = user32.EnumWindows(enumWindowsProc, @intCast(@intFromPtr(&context)));

    return context.foundWindow;
}

pub fn showWindow(hWnd: ?HWND) void {
    _ = user32.ShowWindow(hWnd, 3);
}

pub fn setForegroundWindow(hWnd: ?HWND) void {
    _ = user32.SetForegroundWindow(hWnd);
}
