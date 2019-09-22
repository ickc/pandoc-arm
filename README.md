# pandoc-arm
experimental precompiled pandoc binaries for Raspberry Pi 4

# Security

Unlike the official pandoc executables or those in pandoc-nightly, this is not compiled on a cloud but a local RPi. It could potentially has security problem since who knows what was injected in the code.

I tried compiling pandoc and pandoc-citeproc on 2 different RPi and they have identical sha256sum. i.e. it satisfies reproducibility.

So the simple practice here is to provide the executable with its checksum, together with the dependencies (TODO: is ghc, cabal/stack version enough? How about LLVM?). In principle, other people can verify the same executable can be reproduced using an independent setup.
