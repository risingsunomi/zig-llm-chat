// Test Windows API via zigwin32
const testing = @import("std").testing;
const win32 = @import("zigwin32");
const win32_UIWM = @import("zigwin32").ui.windows_and_messaging;
const win32_FND = @import("zigwin32").foundation;

test "Display a test MessageWindowA" {
    const mb_style = win32_UIWM.MESSAGEBOX_STYLE{ .OKCANCEL = 1, .ICONASTERISK = 1 };

    _ = win32_UIWM.MessageBoxA(null, "Testing", "test", mb_style);
}

fn WinProc(hwnd: win32_FND.HWND, uMsg: u32, wParam: win32_FND.WPARAM, lParam: win32_FND.LPARAM) win32_FND.LRESULT {
    switch (uMsg) {
        win32_UIWM.WM_DESTROY => {
            win32_UIWM.PostQuitMessage(0);
            return 0;
        },
        else => {},
    }
    return win32_UIWM.DefWindowProc(hwnd, uMsg, wParam, lParam);
}

test "Register a window class" {
    const wc: win32_UIWM.WNDCLASSW = undefined;
    wc.lpfnWndProc = WinProc;
    wc.hInstance = win32_UIWM.GetModuleHandleW(null);
    wc.lpszClassName = win32.zig.L("Test Register");

    try testing.expect(win32_UIWM.RegisterClass(&wc) != 0);
    //win32.graphics.

}
