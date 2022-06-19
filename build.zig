const std = @import("std");
const builtin = @import("builtin");

const flags = .{"-lwut"};
const devkitpro = "/opt/devkitpro";

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const obj = b.addObject("zig-wiiu", "src/main.zig");
    obj.setOutputDir("zig-out");
    obj.linkLibC();
    obj.setLibCFile(std.build.FileSource{ .path = "libc.txt" });
    obj.addIncludeDir(devkitpro ++ "/wut/include");
    obj.addIncludeDir(devkitpro ++ "/portlibs/wiiu/include");
    obj.addIncludeDir(devkitpro ++ "/portlibs/ppc/include");
    obj.setTarget(.{
        .cpu_arch = .powerpc,
        .os_tag = .freestanding,
        .abi = .eabi,
        .cpu_model = .{ .explicit = &std.Target.powerpc.cpu.@"750" },
        .cpu_features_add = std.Target.powerpc.featureSet(&.{.hard_float}),
    });
    obj.setBuildMode(mode);

    const extension = if (builtin.target.os.tag == .windows) ".exe" else "";
    const elf = b.addSystemCommand(&(.{
        devkitpro ++ "/devkitPPC/bin/powerpc-eabi-gcc" ++ extension,
        "-g",
        "-Wl,-Map,zig-out/zig-wiiu.map",
        "zig-out/zig-wiiu.o",
        "-L" ++ devkitpro ++ "/wut/lib",
        "-L" ++ devkitpro ++ "/portlibs/wiiu/lib",
        "-L" ++ devkitpro ++ "/portlibs/ppc/lib",
    } ++ flags ++ .{
        "-o",
        "zig-out/zig-wiiu.elf",
    }));

    const rpx = b.addSystemCommand(&.{
        devkitpro ++ "/tools/bin/elf2rpl" ++ extension,
        "zig-out/zig-wiiu.elf",
        "zig-out/zig-wiiu.rpx",
    });

    const wuhb = b.addSystemCommand(&.{
        devkitpro ++ "/tools/bin/wuhbtool" ++ extension,
        "zig-out/zig-wiiu.rpx",
        "zig-out/zig-wiiu.wuhb",
    });
    wuhb.stdout_action = .ignore;

    b.default_step.dependOn(&wuhb.step);
    wuhb.step.dependOn(&rpx.step);
    rpx.step.dependOn(&elf.step);
    elf.step.dependOn(&obj.step);
}
