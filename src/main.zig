const c = @import("wiiu/c.zig");

export fn _start(_: c_int, _: [*]const [*:0]const u8) void {
    c.WHBProcInit();
    defer c.WHBProcShutdown();
    _ = c.WHBLogConsoleInit();
    defer c.WHBLogConsoleFree();
    _ = c.WHBLogPrintf("Hello World!");

    while (true) {
        c.WHBLogConsoleDraw();
    }
}
