# zig-wiiu

Building works, but running in cemu crashes. Not sure why this is the case.

## Getting started

- [zig](https://ziglang.org/download/)
- [devkitPro](https://devkitpro.org/wiki/Getting_Started)

```
pacman -S wiiu-dev
git clone https://github.com/zig-homebrew/zig-wiiu
cd zig-wiiu/
zig build # then run zig-out/zig-wiiu.rpx with cemu
```

## Resources

- [wii-examples](https://github.com/devkitPro/wii-examples)
- [libogc repository](https://github.com/devkitPro/libogc)
- [libogc documentation](https://libogc.devkitpro.org/files.html)
