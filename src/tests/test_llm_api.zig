const std = @import("std");
const testing = @import("std").testing;

// test "using http client" {
//     // Create a general purpose allocator
//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     defer _ = gpa.deinit();

//     // Create a HTTP client
//     var client = std.http.Client{ .allocator = gpa.allocator() };
//     defer client.deinit();

//     // Allocate a buffer for server headers
//     var buf: [4096]u8 = undefined;

//     // Start the HTTP request
//     const uri = try std.Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=39.952583&longitude=-75.165222&current=temperature_2m,rain&temperature_unit=fahrenheit");
//     var req = try client.open(.GET, uri, .{ .server_header_buffer = &buf });
//     defer req.deinit();

//     // Send the HTTP request headers
//     try req.send();

//     // Finish the body of a request
//     try req.finish();

//     // Waits for a response from the server and parses any headers that are sent
//     try req.wait();

//     //std.debug.print("status={d}\n", .{req.response.status});
//     const req_status: std.http.Status = req.response.status;
//     if (req_status == std.http.Status.ok) {
//         // Read the body
//         const body_max_size = 65536;
//         var bbuffer: [body_max_size]u8 = undefined;
//         const blength = try req.readAll(&bbuffer);
//         if (blength == 0) {
//             return error.NoBodyLength;
//         }

//         // Display the result
//         // std.debug.print("usize of {d} bytes returned:\n{s}\n", .{ blength, bbuffer[0..blength] });
//     }
// }

test "using ollama" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var client = std.http.Client{ .allocator = gpa.allocator() };
    defer client.deinit();

    var buf: [4096]u8 = undefined;

    const uri = try std.Uri.parse("http://localhost:11434/api/generate");

    const fetch_loc = std.http.Client.FetchOptions.Location{ .uri = uri };
    const fetch_resp_store = std.http.Client.FetchOptions.ResponseStorage{ .ignore = {} };
    const fetch_opts = std.http.Client.FetchOptions{
        .payload = "{ \"model\": \"llama3\", \"prompt\": \"What is zig?\"}",
        .method = .POST,
        .server_header_buffer = &buf,
        .location = fetch_loc,
        .headers = std.http.Client.Request.Headers{
            .content_type = std.http.Client.Request.Headers.Value{ .override = "application/json" },
        },
        .response_storage = fetch_resp_store,
    };

    const resp: std.http.Client.FetchResult = try client.fetch(
        fetch_opts,
    );

    if (resp.status == std.http.Status.ok) {
        const resp_body = fetch_resp_store.dynamic.?;
        // Display the result
        std.debug.print("returned resp storage:\n", .{});
        for (0..resp_body.items.len) |i| {
            std.debug.print("{d} ", .{resp_body.items[i]});
        }
    }
}
