const std = @import("std");
const win32 = @import("zigwin32");
const ogen = @import("llm_api.zig");

pub fn main() anyerror!void {
    // win32 constants
    const winUI = win32.ui.windows_and_messaging;
    const mb_style = winUI.MESSAGEBOX_STYLE{ .OKCANCEL = 1, .ICONASTERISK = 1 };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const oresp = try ogen.OllamaGenerate(
        allocator,
        "What is zig?",
    );
    defer allocator.free(oresp);

    std.debug.print("main oresp: {s}", .{oresp});

    // convert from a const u8 to sentinel-terminated const u8
    const cll_oresp = try allocator.dupeZ(u8, oresp);
    defer allocator.free(cll_oresp);

    // pass cll_oresp as pointer
    _ = winUI.MessageBoxA(null, cll_oresp.ptr, "LLM Response", mb_style);
}
