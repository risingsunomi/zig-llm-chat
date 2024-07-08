// win_h.zig testing
const std = @import("std");
const winh = @cImport(@cInclude("windows.h"));
const winh_zig = @import("win_h.zig");

test "Display a Message Box" {
    std.debug.print("Running winMsgBox\n", .{});

    const msg = "Test message";
    const title = "Test title";
    try winh_zig.winMsgBox(msg, title);
}

test "Start Windows Process" {
    std.debug.print("Running winProce\n", .{});

    const hInstance = winh.GetModuleHandleW(null);
    const nCmdShow = winh.SW_SHOW;
    try winh_zig.winProc(hInstance, nCmdShow);
}
