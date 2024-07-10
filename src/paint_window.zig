// Painting wWinMain window using zigwin32
// Source/Inspiration https://learn.microsoft.com/en-us/windows/win32/learnwin32/your-first-windows-program
// This is a simple windows application with a simple painting request

// tried using usingnamespace but caused some import errors
// as things are redefined a bit in the API and causes issues with
// getting the proper type. Something to look into.
const logger = @import("std").log;
const WINAPI = @import("std").os.windows.WINAPI;

const win32_zig = @import("zigwin32").zig;
const win32_UIWM = @import("zigwin32").ui.windows_and_messaging;
const win32_FND = @import("zigwin32").foundation;
const win32_LL = @import("zigwin32").system.library_loader;
const win32_SS = @import("zigwin32").system.system_services;
const win32_GDI = @import("zigwin32").graphics.gdi;

const win32_tools = @import("win_tools.zig");

// WinProcess
// Cant really make it a CALLBACK type so will try and see
pub export fn WinProc(hwnd: win32_FND.HWND, uMsg: u32, wParam: win32_FND.WPARAM, lParam: win32_FND.LPARAM) callconv(WINAPI) win32_FND.LRESULT {
    switch (uMsg) {
        win32_UIWM.WM_DESTROY => {
            win32_UIWM.PostQuitMessage(0);
            return 0;
        },
        win32_UIWM.WM_PAINT => {
            // WM_PAINT message to request painting of the app window
            var ps: win32_GDI.PAINTSTRUCT = win32_GDI.PAINTSTRUCT{
                .hdc = null,
                .fErase = 0,
                .rcPaint = win32_FND.RECT{
                    .bottom = 0,
                    .left = 0,
                    .right = 0,
                    .top = 0,
                },
                .fIncUpdate = 0,
                .fRestore = 0,
                .rgbReserved = undefined,
            };

            if (@TypeOf(hwnd) == ?*opaque {}) {
                return 0;
            }

            const hdc: ?win32_GDI.HDC = win32_GDI.BeginPaint(hwnd, &ps);

            const brush: ?win32_GDI.HBRUSH = win32_GDI.CreateSolidBrush(128);
            _ = win32_GDI.FillRect(hdc, &ps.rcPaint, brush);

            _ = win32_GDI.EndPaint(hwnd, &ps);
        },
        else => {},
    }

    return win32_UIWM.DefWindowProcA(hwnd, uMsg, wParam, lParam);
}

// Main Window instance
pub export fn wWinMain(hInstance: ?win32_FND.HINSTANCE, _: ?win32_FND.HINSTANCE, _: ?win32_FND.PWSTR, nCmdShow: u32) i32 {
    const class_name = "Sample Windows Class IN ZIG";
    var wc: win32_UIWM.WNDCLASSA = win32_UIWM.WNDCLASSA{
        .style = win32_UIWM.WNDCLASS_STYLES{},
        .lpfnWndProc = WinProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = win32_LL.GetModuleHandleA(null),
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = "",
        .lpszClassName = class_name.ptr,
    };

    // register window
    if (win32_UIWM.RegisterClassA(&wc) == 0) {
        const error_code = win32_FND.GetLastError();
        //const error_message = try winh_zig.getErrorMessage(allocator, error_code);
        logger.err("RegisterClassW error code: {any}\n", .{error_code});
        return 0;
    }

    const window_name = "Win32API via ZIG";
    const hwnd: ?win32_FND.HWND = win32_UIWM.CreateWindowExA(
        win32_UIWM.WINDOW_EX_STYLE{},
        class_name.ptr,
        window_name,
        win32_UIWM.WS_OVERLAPPEDWINDOW,
        win32_UIWM.CW_USEDEFAULT,
        win32_UIWM.CW_USEDEFAULT,
        win32_UIWM.CW_USEDEFAULT,
        win32_UIWM.CW_USEDEFAULT,
        null,
        null,
        hInstance,
        null,
    );

    if (@TypeOf(hwnd) == ?*opaque {}) {
        logger.err("hwnd returned null", .{});
        return 0;
    }

    const swc_ncmdshow = win32_tools.ncmdshow_vals[nCmdShow];
    _ = win32_UIWM.ShowWindow(hwnd, swc_ncmdshow);

    var msg = win32_UIWM.MSG{
        .hwnd = null,
        .lParam = 0,
        .message = 0,
        .pt = win32_FND.POINT{ .x = 0, .y = 0 },
        .time = 0,
        .wParam = 0,
    };

    while (win32_UIWM.GetMessageA(&msg, null, 0, 0) > 0) {
        _ = win32_UIWM.TranslateMessage(&msg);
        _ = win32_UIWM.DispatchMessageA(&msg);
    }

    return 0;
}
