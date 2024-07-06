// Interface to show messages via MessageBoxA Windows API
const std = @import("std");
const log = @import("std").log.info;
const winh = @cImport(@cInclude("windows.h"));

pub fn winMsgBox(msg: [*c]const u8, title: [*c]const u8) anyerror!void {
    // Call MessageBox from Windows API
    _ = winh.MessageBoxA(
        null,
        msg,
        title,
        winh.MB_OK | winh.MB_ICONINFORMATION,
    );
}
