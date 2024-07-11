const std = @import("std");
const testing = @import("std").testing;
const ogen = @import("llm_api.zig");

test "using OllamaGenerate" {
    const oresp = try ogen.OllamaGenerate("What is zig?");
    std.debug.print("Ollama Response\n{s}\n", .{oresp});
}
