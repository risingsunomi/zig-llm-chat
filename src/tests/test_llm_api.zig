const std = @import("std");
const testing = @import("std").testing;

test "using http client" {
    // Create a general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // Create a HTTP client
    var client = std.http.Client{ .allocator = gpa.allocator() };
    defer client.deinit();

    // Allocate a buffer for server headers
    var buf: [4096]u8 = undefined;

    // Start the HTTP request
    const uri = try std.Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=39.952583&longitude=-75.165222&current=temperature_2m,rain&temperature_unit=fahrenheit");
    var req = try client.open(.GET, uri, .{ .server_header_buffer = &buf });
    defer req.deinit();

    // Send the HTTP request headers
    try req.send();

    // Finish the body of a request
    try req.finish();

    // Waits for a response from the server and parses any headers that are sent
    try req.wait();

    std.debug.print("status={d}\n", .{req.response.status});

    // Read the body
    const body_max_size = 65536;
    var bbuffer: [body_max_size]u8 = undefined;
    const blength = try req.readAll(&bbuffer);
    if (blength == 0) {
        return error.NoBodyLength;
    }

    // Display the result
    std.debug.print("usize of {d} bytes returned:\n{s}\n", .{ blength, bbuffer[0..blength] });
}
