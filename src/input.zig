const std = @import("std");
const windows = std.os.windows;
const WINAPI = windows.WINAPI;

const HWND = windows.HWND;
const BOOL = windows.BOOL;
const WPARAM = windows.WPARAM;
const LPARAM = windows.LPARAM;
const DWORD = windows.DWORD;
const POINT = windows.POINT;

const KBDLLHOOKSTRUCT = extern struct {
    vkCode: DWORD,
    scanCode: DWORD,
    flags: DWORD,
    time: DWORD,
    dwExtraInfo: usize,
};

const MSG = extern struct {
    hwnd: ?HWND,
    message: u32,
    wParam: WPARAM,
    lParam: LPARAM,
    time: u32,
    pt: POINT,
};

const user32 = struct {
    pub extern "user32" fn SendInput(nInputs: usize, pInputs: [*]const WINDOW_INPUT_STRUCT, cbSize: c_int) u32;
    pub extern "user32" fn SetWindowsHookExA(idHook: i32, lpfn: ?*const anyopaque, hmod: ?windows.HMODULE, dwThreadId: DWORD) callconv(WINAPI) windows.LRESULT;
    pub extern "user32" fn CallNextHookEx(hhk: windows.LRESULT, nCode: i32, wParam: WPARAM, lParam: LPARAM) callconv(WINAPI) windows.LRESULT;
    pub extern "user32" fn UnhookWindowsHookEx(hHook: windows.LRESULT) BOOL;
    pub extern "user32" fn GetMessageW(lpMsg: ?*MSG, hwnd: ?HWND, wMsgFilterMin: u32, wMsgFilterMax: u32) callconv(WINAPI) windows.LRESULT;
};

const KEYEVENTF_KEYDOWN: u32 = 0x0000;
const KEYEVENTF_KEYUP: u32 = 0x0002;

const LISTEN_FOR_KEYINPUT = 13;
const LISTEN_FOR_MOUSEINPUT = 7;

const stringToKeys = std.StaticStringMap(Keys).initComptime(.{
    .{ "a", Keys.a },
    .{ "b", Keys.b },
    .{ "c", Keys.c },
    .{ "d", Keys.d },
    .{ "e", Keys.e },
    .{ "f", Keys.f },
    .{ "g", Keys.g },
    .{ "h", Keys.h },
    .{ "i", Keys.i },
    .{ "j", Keys.j },
    .{ "k", Keys.k },
    .{ "l", Keys.l },
    .{ "m", Keys.m },
    .{ "n", Keys.n },
    .{ "o", Keys.o },
    .{ "p", Keys.p },
    .{ "q", Keys.q },
    .{ "r", Keys.r },
    .{ "s", Keys.s },
    .{ "t", Keys.t },
    .{ "u", Keys.u },
    .{ "v", Keys.v },
    .{ "w", Keys.w },
    .{ "x", Keys.x },
    .{ "y", Keys.y },
    .{ "z", Keys.z },
    .{ "0", Keys.key_0 },
    .{ "1", Keys.key_1 },
    .{ "2", Keys.key_2 },
    .{ "3", Keys.key_3 },
    .{ "4", Keys.key_4 },
    .{ "5", Keys.key_5 },
    .{ "6", Keys.key_6 },
    .{ "7", Keys.key_7 },
    .{ "8", Keys.key_8 },
    .{ "9", Keys.key_9 },
    .{ "F1", Keys.F1 },
    .{ "F2", Keys.F2 },
    .{ "F3", Keys.F3 },
    .{ "F4", Keys.F4 },
    .{ "F5", Keys.F5 },
    .{ "F6", Keys.F6 },
    .{ "F7", Keys.F7 },
    .{ "F8", Keys.F8 },
    .{ "F9", Keys.F9 },
    .{ "F10", Keys.F10 },
    .{ "F11", Keys.F11 },
    .{ "alt", Keys.alt },
});

pub const Keys = enum(u16) {
    a = 0x41,
    b = 0x42,
    c = 0x43,
    d = 0x44,
    e = 0x45,
    f = 0x46,
    g = 0x47,
    h = 0x48,
    i = 0x49,
    j = 0x4A,
    k = 0x4B,
    l = 0x4C,
    m = 0x4D,
    n = 0x4E,
    o = 0x4F,
    p = 0x50,
    q = 0x51,
    r = 0x52,
    s = 0x53,
    t = 0x54,
    u = 0x55,
    v = 0x56,
    w = 0x57,
    x = 0x58,
    y = 0x59,
    z = 0x5A,
    key_0 = 0x30,
    key_1 = 0x31,
    key_2 = 0x32,
    key_3 = 0x33,
    key_4 = 0x34,
    key_5 = 0x35,
    key_6 = 0x36,
    key_7 = 0x37,
    key_8 = 0x38,
    key_9 = 0x39,
    F1 = 0x70,
    F2 = 0x71,
    F3 = 0x72,
    F4 = 0x73,
    F5 = 0x74,
    F6 = 0x75,
    F7 = 0x76,
    F8 = 0x77,
    F9 = 0x78,
    F10 = 0x79,
    F11 = 0x7A,
    F12 = 0x7B,
    F13 = 0x7C,
    F14 = 0x7D,
    F15 = 0x7E,
    F16 = 0x7F,
    F17 = 0x80,
    F18 = 0x81,
    F19 = 0x82,
    F20 = 0x83,
    F21 = 0x84,
    F22 = 0x85,
    F23 = 0x86,
    F24 = 0x87,
    space = 0x20,
    left_shift = 0x10,
    alt = 0x12,
};

const INPUT_TYPE = enum(u32) {
    MOUSE = 0,
    KEYBOARD = 1,
    HARDWARE = 2,
};

const WINDOW_INPUT_STRUCT = extern struct {
    type: u32,
    u: extern union {
        mi: extern struct {
            dx: i32,
            dy: i32,
            mouseData: u32,
            dwFlags: u32,
            time: u32,
            dwExtraInfo: usize,
        },
        ki: extern struct {
            wVk: u16,
            wScan: u16,
            dwFlags: u32,
            time: u32,
            dwExtraInfo: usize,
        },
    },
};

pub fn stringToKey(str: []const u8) ?Keys {
    return stringToKeys.get(str);
}

pub fn send_mouse_click(allocator: std.mem.Allocator, x: i32, y: i32) !void {
    var mouse_codes = std.ArrayList(WINDOW_INPUT_STRUCT).init(allocator);
    defer mouse_codes.deinit();

    try mouse_codes.append(.{
        .type = @intFromEnum(INPUT_TYPE.MOUSE),
        .u = .{ .mi = .{
            .dx = x,
            .dy = y,
            .mouseData = 0,
            .dwFlags = 0,
            .time = 0,
            .dwExtraInfo = 0,
        } },
    });
    _ = user32.SendInput(@intCast(2), mouse_codes.items.ptr, @sizeOf(WINDOW_INPUT_STRUCT));
}

pub fn send_key_press(allocator: std.mem.Allocator, keys: []const Keys) !void {
    var key_codes = std.ArrayList(WINDOW_INPUT_STRUCT).init(allocator);
    defer key_codes.deinit();

    for (keys) |key_code| {
        try key_codes.append(.{
            .type = @intFromEnum(INPUT_TYPE.KEYBOARD),
            .u = .{ .ki = .{
                .wVk = @intFromEnum(key_code),
                .wScan = 0,
                .dwFlags = KEYEVENTF_KEYDOWN,
                .time = 0,
                .dwExtraInfo = 0,
            } },
        });
    }

    for (keys) |key_code| {
        try key_codes.append(.{
            .type = @intFromEnum(INPUT_TYPE.KEYBOARD),
            .u = .{ .ki = .{
                .wVk = @intFromEnum(key_code),
                .wScan = 0,
                .dwFlags = KEYEVENTF_KEYUP,
                .time = 0,
                .dwExtraInfo = 0,
            } },
        });
    }

    _ = user32.SendInput(@intCast(keys.len * 2), key_codes.items.ptr, @sizeOf(WINDOW_INPUT_STRUCT));
}

pub fn listen_for_key(callback: fn (key: []const u8) void) !void {
    const hKeyboardHook = user32.SetWindowsHookExA(LISTEN_FOR_KEYINPUT, struct {
        pub fn func(nCode: c_int, wParam: WPARAM, lParam: LPARAM) windows.LRESULT {
            if (nCode == 0) {
                if (wParam == 0x100) {
                    const parse: usize = @intCast(lParam);
                    const kbd: *KBDLLHOOKSTRUCT = @ptrFromInt(parse);
                    inline for (std.meta.fields(Keys)) |field| {
                        if (kbd.vkCode == field.value) {
                            callback(field.name);
                        }
                    }
                }
            }
            return user32.CallNextHookEx(LISTEN_FOR_KEYINPUT, nCode, wParam, lParam);
        }
    }.func, null, 0);
    if (hKeyboardHook == 0) {
        return error.FailedToSetKeyboardHook;
    }
    defer _ = user32.UnhookWindowsHookEx(hKeyboardHook);

    std.debug.print("Listening\n", .{});
    var msg: MSG = undefined;
    while (user32.GetMessageW(&msg, null, 0, 0) != 0) {}
}
