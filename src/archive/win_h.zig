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

// get the last error message from win API as a string
// pub fn getErrorMessage(allocator: std.mem.Allocator, error_code: winh.DWORD) anyerror![]const u8 {
//     const FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000;
//     const FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100;
//     const FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200;

//     var buffer: [*]u8 = false;

//     const length = winh.FormatMessageA(
//         FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_IGNORE_INSERTS,
//         null,
//         error_code,
//         0,
//         buffer,
//         0,
//         null,
//     );

//     if (length == 0 or buffer == undefined) {
//         return error.ConversionFailed;
//     }

//     // Copy the buffer to allocator-allocated memory
//     const result: []u8 = try allocator.dupe(u8, std.mem.sliceAsBytes(buffer[0..length]));

//     // Free the buffer allocated by FormatMessage
//     _ = winh.LocalFree(buffer);

//     return result;
// }

// --------------------------------------------------------------- //
