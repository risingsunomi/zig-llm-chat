// Test Windows API via zigwin32
const WINAPI = @import("std").os.windows.WINAPI;
const testing = @import("std").testing;
const log = @import("std").log;
const win32_zig = @import("zigwin32").zig;
const win32_UIWM = @import("zigwin32").ui.windows_and_messaging;
const win32_FND = @import("zigwin32").foundation;
const win32_LL = @import("zigwin32").system.library_loader;

test "Display a test MessageWindowA" {
    const mb_style = win32_UIWM.MESSAGEBOX_STYLE{ .OKCANCEL = 1, .ICONASTERISK = 1 };

    _ = win32_UIWM.MessageBoxA(null, "Testing", "test", mb_style);
}

fn WinProc(hwnd: win32_FND.HWND, uMsg: u32, wParam: win32_FND.WPARAM, lParam: win32_FND.LPARAM) callconv(WINAPI) win32_FND.LRESULT {
    switch (uMsg) {
        win32_UIWM.WM_DESTROY => {
            win32_UIWM.PostQuitMessage(0);
            return 0;
        },
        else => {},
    }
    return win32_UIWM.DefWindowProcA(hwnd, uMsg, wParam, lParam);
}

test "Register a window class" {
    log.info("testing window registering", .{});
    var wc: win32_UIWM.WNDCLASSA = undefined;
    wc.lpfnWndProc = WinProc;
    wc.hInstance = win32_LL.GetModuleHandleW(null);
    wc.lpszClassName = "Test Register";

    log.info("Registering Class: {s}", .{"Test Register"});

    const rg_class = win32_UIWM.RegisterClassA(&wc);
    var rg_bool = false;

    log.info("rg_class: {any}", .{rg_class});

    if (rg_class != 0) {
        rg_bool = true;
    }

    //try testing.expectEqual(true, rg_bool);
    //win32.graphics.

}
