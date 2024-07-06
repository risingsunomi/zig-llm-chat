// building out gui
// first focus is windows.h
const winh = @cImport(@cInclude("windows.h"));
const win_mbx = @import("win_msgbox.zig");

pub fn main() anyerror!void {
    const message = "Hello from Windows API!";
    const title = "Testing win_msgbox.zig";

    try win_mbx.winMsgBox(message, title);
}
