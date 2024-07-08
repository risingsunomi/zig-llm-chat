const std = @import("std");
const win32 = @import("zigwin32");

pub fn main() void {
    const winUI = win32.ui.windows_and_messaging;
    const mb_style = winUI.MESSAGEBOX_STYLE{ .OKCANCEL = 1, .ICONASTERISK = 1 };

    _ = winUI.MessageBoxA(null, "Testing", "test", mb_style);
}
