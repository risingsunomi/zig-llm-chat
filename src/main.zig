const std = @import("std");
const winh = @cImport(@cInclude("windows.h"));
const winh_zig = @import("win_h.zig");

pub fn main() anyerror!void {
    const message = "Hello from Windows API";
    const title = "Testing win_msgbox.zig";

    try winh_zig.winMsgBox(message, title);

    const hInstance = winh.GetModuleHandleW(null);
    const nCmdShow = winh.SW_SHOW;
    try runApp(hInstance, nCmdShow);
}

pub fn runApp(hInstance: winh.HINSTANCE, nCmdShow: winh.INT) anyerror!void {
    const CLASS_NAME = "Sample Window Class";

    var wc: winh.WNDCLASSW = undefined;
    wc.lpfnWndProc = winh_zig.winProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = winh_zig.convertU8ToUShort(CLASS_NAME);

    if (winh.RegisterClassW(&wc) == 0) {
        return error.RegisterClassFailed;
    }

    const hwnd = winh.CreateWindowExW(0, // Optional window styles.
        CLASS_NAME.ptr, // Window class
        "Learn to Program Windows".ptr, // Window text
        winh.WS_OVERLAPPEDWINDOW, // Window style

    // Size and position
        winh.CW_USEDEFAULT, winh.CW_USEDEFAULT, winh.CW_USEDEFAULT, winh.CW_USEDEFAULT, null, // Parent window
        null, // Menu
        hInstance, // Instance handle
        null // Additional application data
    );

    if (hwnd == null) {
        return error.CreateWindowFailed;
    }

    winh.ShowWindow(hwnd, nCmdShow);

    // Run the message loop
    var msg: winh.MSG = undefined;
    while (winh.GetMessageW(&msg, null, 0, 0) > 0) {
        winh.TranslateMessage(&msg);
        winh.DispatchMessageW(&msg);
    }
}
