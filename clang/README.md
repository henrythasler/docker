# clang + lld based on alpine

## build

```
docker build -t="clang-alpine:latest" .
```

## run

```
docker run --rm -ti clang-alpine:latest
```

to get a shell inside the container:

```
docker run --rm -ti --entrypoint=sh clang-alpine:latest
```

## References

- [The LLVM Compiler Infrastructure](https://github.com/llvm/llvm-project)
- [LLD - The LLVM Linker](https://lld.llvm.org/) 
- [Clang: a C language family frontend for LLVM](https://clang.llvm.org/)
