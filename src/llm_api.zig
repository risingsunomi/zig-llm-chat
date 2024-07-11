// LLM API
// Defines the API interface for various LLMs
// Current focus is ollama local LLM

const std = @import("std");

// OllamaGenResponse
pub const OllamaGenResponse = struct {
    model: []const u8,
    created_at: []const u8,
    response: []const u8,
    done: bool,
    context: []const u32,
    total_duration: u64,
    load_duration: u64,
    prompt_eval_count: u32,
    prompt_eval_duration: u64,
    eval_count: u32,
    eval_duration: u64,
};

// OllamaGenerate
// reaches out to ollama generate api with prompt
// returns llm response
pub fn OllamaGenerate(allocator: std.mem.Allocator, prompt: []const u8) anyerror![]const u8 {
    // setup http client
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    // setup fetch
    var buf: [4096]u8 = undefined;
    const uri = try std.Uri.parse("http://localhost:11434/api/generate");
    const fetch_loc: std.http.Client.FetchOptions.Location = .{ .uri = uri };
    var fetch_dynamic_list = std.ArrayList(u8).init(allocator);
    defer fetch_dynamic_list.deinit();

    // combine prompt string (messy in zig still)
    const ollama_params = try std.fmt.allocPrint(
        allocator,
        "{{ \"model\": \"llama3\", \"prompt\": \"{s}\", \"stream\": false }}",
        .{prompt},
    );
    defer allocator.free(ollama_params);

    std.debug.print("ollama_params:\n{s}\n", .{ollama_params});

    // fetch to ollama generate api
    const resp: std.http.Client.FetchResult = try client.fetch(.{
        .payload = ollama_params,
        .method = .POST,
        .server_header_buffer = &buf,
        .location = fetch_loc,
        .headers = .{
            .content_type = .{ .override = "application/json" },
        },
        .response_storage = .{ .dynamic = &fetch_dynamic_list },
    });

    // get reponse if status is ok
    if (resp.status == std.http.Status.ok) {
        const ollama_response = try allocator.dupe(u8, fetch_dynamic_list.items);

        // Parse JSON
        const json_parse = try std.json.parseFromSlice(
            OllamaGenResponse,
            allocator,
            ollama_response,
            .{},
        );
        defer json_parse.deinit();

        const parsed_oresp = json_parse.value;

        // Duplicate the response string to ensure it outlives this function
        const response_copy = try allocator.dupe(u8, parsed_oresp.response);
        allocator.free(ollama_response);

        std.debug.print("Ollama Response\n{s}\n", .{response_copy});
        return response_copy;
    } else {
        std.debug.print("status not ok: {any}", .{resp.status});
        return error.HttpStatusNotOk;
    }
}
