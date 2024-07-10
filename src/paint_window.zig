// Painting wWinMain window using zigwin32
// Source/Inspiration https://learn.microsoft.com/en-us/windows/win32/learnwin32/your-first-windows-program
// This is a simple windows application with a simple painting request

const WINAPI = @import("std").os.windows.WINAPI;
usingnamespace @import("zigwin32").zig;
usingnamespace @import("zigwin32").system.system_services;
usingnamespace @import("zigwin32").ui.windows_and_messaging;
usingnamespace @import("zigwin32").graphics.gdi;
usingnamespace @import("zigwin32").foundation;

// Window Process
// Cant really make it a CALLBACK type so will try and see
pub export fn WindowProc(hwnd: HWND, uMsg: u32, wParam: WPARAM, lParam: LPARAM) LRESULT {
    switch(uMsg) {
        WM_DESTROY => {
            PostQuitMessage(0);
            return 0;
        },
        WM_PAINT => {
            // WM_PAINT message to request painting of the app window
            const ps: PAINTSTRUCT = null;
            const hdc: HDC = BeginPaint(hwnd, &ps);
        }
    }

    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}
// Main Window instance
pub export fn wWinMain(hinstance: HINSTANCE, hPrevInstance: HINSTANCE, pCmdLine PWSTR, nCmdShow: i32) i32 {
    const class_name = L("Sample Windows Class IN ZIG");
    
    const wc: WNDCLASS = null;
    wc.lpfnWndProc;
}