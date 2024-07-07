// Interface for the Windows API in Zig

const std = @import("std");
const winh = @cImport(@cInclude("windows.h"));

// -- API -- //

// MessageBoxA
pub fn winMsgBox(msg: [*c]const u8, title: [*c]const u8) anyerror!void {
    // Call MessageBox from Windows API
    _ = winh.MessageBoxA(
        null,
        msg,
        title,
        winh.MB_OK | winh.MB_ICONINFORMATION,
    );
}

// Window Process
pub fn winProc(hwnd: winh.HWND, uMsg: winh.UINT, wParam: winh.WPARAM, lParam: winh.LPARAM) callconv(.C) winh.LRESULT {
    switch (uMsg) {
        winh.WM_DESTROY => {
            winh.PostQuitMessage(0);
            return 0;
        },
        winh.WM_PAINT => {
            var ps: winh.PAINTSTRUCT = undefined;
            const hdc = winh.BeginPaint(hwnd, &ps);

            // All painting occurs here, between BeginPaint and EndPaint.
            const brush: winh.HBRUSH = @as(winh.HBRUSH, (winh.COLOR_WINDOW + 1));

            _ = winh.FillRect(hdc, &ps.rcPaint, brush);

            _ = winh.EndPaint(hwnd, &ps);
            return 0;
        },
        else => return winh.DefWindowProcW(hwnd, uMsg, wParam, lParam),
    }
}

// --------------------------------------------------------------- //

// -- Helpers -- //
pub fn convertU8ToUShort(u8_input: *const []u8) anyerror![*c]const c_ushort {
    // convert u8 string to ushort for windows
    const short_out: [*c]const c_ushort = undefined;

    for (u8_input, 0..) |val, idx| {
        short_out[idx] = @as(c_ushort, val);
    }

    return short_out;
}

// -- Tests -- //

test "Display a Message Box" {
    std.debug.print("Running winMsgBox\n", .{});

    const msg = "Test message";
    const title = "Test title";
    try winMsgBox(msg, title);
}

test "Start Windows Process" {
    std.debug.print("Running winProce\n", .{});

    const hInstance = winh.GetModuleHandleW(null);
    const nCmdShow = winh.SW_SHOW;
    try winProc(hInstance, nCmdShow);
}
