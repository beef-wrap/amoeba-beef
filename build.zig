const std = @import("std");
const zbh = @import("zbh");

pub fn build(b: *std.Build) !void {
    const upstream = b.dependency("upstream", .{});
    const target = b.option([]const u8, "target", "");

    _ = try zbh.lib(b, .{
        .name = "amoeba",
        .target = target,
        .includes = &.{
            upstream.path(""),
        },
        .files = .{
            .files = &.{"src/amoeba.c"},
        },
    });
}
