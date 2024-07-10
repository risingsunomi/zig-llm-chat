const std = @import("std");
const winh = @cImport(@cInclude("windows.h"));
const winh_zig = @import("win_h.zig");

pub fn main() anyerror!void {
    // const message = "Hello from Windows API";
    // const title = "Testing win_msgbox.zig";

    // try winh_zig.winMsgBox(message, title);

    const hInstance = winh.GetModuleHandleW(null);
    const nCmdShow = winh.SW_SHOW;
    try runApp(hInstance, nCmdShow);
}

pub fn runApp(hInstance: winh.HINSTANCE, nCmdShow: winh.INT) anyerror!void {
    const allocator = std.heap.page_allocator;

    const CLASS_NAME: []const u8 = "Class Name";

    var wc: winh.WNDCLASSW = undefined;
    wc.lpfnWndProc = winh_zig.winProc;
    wc.hInstance = hInstance;

    const class_name_ushort: [*]const c_ushort = @ptrCast(@alignCast(CLASS_NAME));
    wc.lpszClassName = class_name_ushort;

    if (winh.RegisterClassW(&wc) == 0) {
        const error_code = winh.GetLastError();
        //const error_message = try winh_zig.getErrorMessage(allocator, error_code);
        std.debug.print("RegisterClassW error code: {any}\n", .{error_code});
        return error.RegisterClassFailed;
    }

    const lp_window_name: [*]const c_ushort = @ptrCast(@alignCast("Learn to Program Windows"));

    const hwnd = winh.CreateWindowExW(0, // Optional window styles.
        class_name_ushort, // Window class
        lp_window_name, // Window text
        winh.WS_OVERLAPPEDWINDOW, // Window style
        winh.CW_USEDEFAULT, winh.CW_USEDEFAULT, winh.CW_USEDEFAULT, winh.CW_USEDEFAULT, null, // Parent window
        null, // Menu
        hInstance, // Instance handle
        null // Additional application data
    );

    if (hwnd == null) {
        return error.CreateWindowFailed;
    }

    _ = winh.ShowWindow(hwnd, nCmdShow);

    // Run the message loop
    var msg: winh.MSG = undefined;
    while (winh.GetMessageW(&msg, null, 0, 0) > 0) {
        _ = winh.TranslateMessage(&msg);
        _ = winh.DispatchMessageW(&msg);
    }
}
