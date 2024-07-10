// Toolset for win32 programming
// some short cuts and things for generating structs

const win32_UIWM = @import("zigwin32").ui.windows_and_messaging;

// nCmdShow values
pub const ncmdshow_vals = [11]win32_UIWM.SHOW_WINDOW_CMD{
    win32_UIWM.SW_HIDE,
    win32_UIWM.SW_SHOWNORMAL,
    win32_UIWM.SW_SHOWMINIMIZED,
    win32_UIWM.SW_SHOWMAXIMIZED,
    win32_UIWM.SW_SHOWNOACTIVATE,
    win32_UIWM.SW_SHOW,
    win32_UIWM.SW_MINIMIZE,
    win32_UIWM.SW_SHOWNA,
    win32_UIWM.SW_RESTORE,
    win32_UIWM.SW_SHOWDEFAULT,
    win32_UIWM.SW_FORCEMINIMIZE,
};
