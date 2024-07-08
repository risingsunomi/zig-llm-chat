// Test Windows API via zigwin32

const std = @import("std");
const win32 = @import("zigwin32");

test "Display a test MessageWindowA" {
    std.debug.print("Running MessageBoxA\n", .{});

    const winUI = win32.ui.windows_and_messaging;
    const mb_style = winUI.MESSAGEBOX_STYLE{ .OKCANCEL = 1, .ICONASTERISK = 1 };

    _ = winUI.MessageBoxA(null, "Testing", "test", mb_style);
}
