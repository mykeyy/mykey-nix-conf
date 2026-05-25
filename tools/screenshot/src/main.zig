const std = @import("std");

const Child = std.process.Child;

fn runCapture(allocator: std.mem.Allocator, argv: []const []const u8) ![]u8 {
    const result = try Child.run(.{
        .allocator = allocator,
        .argv = argv,
        .max_output_bytes = 4096,
    });
    defer allocator.free(result.stderr);

    if (result.term.Exited != 0) return error.CommandFailed;
    return result.stdout;
}

fn run(allocator: std.mem.Allocator, argv: []const []const u8) !void {
    const result = try Child.run(.{
        .allocator = allocator,
        .argv = argv,
        .max_output_bytes = 4096,
    });
    defer allocator.free(result.stdout);
    defer allocator.free(result.stderr);

    if (result.term.Exited != 0) return error.CommandFailed;
}

fn trimNewline(value: []const u8) []const u8 {
    return std.mem.trim(u8, value, "\r\n");
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const dir = "/home/mykey/Pictures/screenshots";
    try run(allocator, &.{ "mkdir", "-p", dir });

    const timestamp = std.time.timestamp();
    const file = try std.fmt.allocPrint(allocator, "{s}/{d}.png", .{ dir, timestamp });
    defer allocator.free(file);

    const geometry = try runCapture(allocator, &.{ "slurp" });
    defer allocator.free(geometry);
    const selected = trimNewline(geometry);
    if (selected.len == 0) return;

    try run(allocator, &.{ "grim", "-g", selected, file });

    try run(allocator, &.{ "sh", "-c", "wl-copy --type image/png < \"$1\"", "sh", file });
    try run(allocator, &.{ "sh", "-c", "printf %s \"$1\" | wl-copy --primary", "sh", file });

    try run(allocator, &.{ "notify-send", "Screenshot saved", file });
}
