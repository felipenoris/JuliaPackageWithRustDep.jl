# JuliaPackageWithRustDep.jl

## Installation

```julia
(v1.0) pkg> add https://github.com/felipenoris/JuliaPackageWithRustDep.jl.git
  Updating registry at `~/.julia/registries/General`
  Updating git-repo `https://github.com/JuliaRegistries/General.git`
   Cloning git-repo `https://github.com/felipenoris/JuliaPackageWithRustDep.jl.git`
  Updating git-repo `https://github.com/felipenoris/JuliaPackageWithRustDep.jl.git`
 Resolving package versions...
  Updating `~/.julia/environments/v1.0/Project.toml`
  [b3cfa77a] + JuliaPackageWithRustDep v0.1.0 #master (https://github.com/felipenoris/JuliaPackageWithRustDep.jl.git)
  Updating `~/.julia/environments/v1.0/Manifest.toml`
  [b3cfa77a] + JuliaPackageWithRustDep v0.1.0 #master (https://github.com/felipenoris/JuliaPackageWithRustDep.jl.git)
  Building JuliaPackageWithRustDep → `~/.julia/packages/JuliaPackageWithRustDep/ezsMI/deps/build.log`

julia> using JuliaPackageWithRustDep
[ Info: Recompiling stale cache file /Users/felipenoris/.julia/compiled/v1.0/JuliaPackageWithRustDep/JYL3H.ji for JuliaPackageWithRustDep [b3cfa77a-c005-11e8-2503-c57ef66cec51]

julia> JuliaPackageWithRustDep.rustdylib_printhello()
Hello from Rust!
```

## Tutorial

### Create a Rust project inside deps folder

```shell
$ cargo new RustDylib --lib
```

## Resources

* [Exposing a Rust Library to C](http://greyblake.com/blog/2017/08/10/exposing-rust-library-to-c/)

* [std::ffi docs](https://doc.rust-lang.org/std/ffi/index.html)

* [Rust FFI Guide](https://michael-f-bryan.github.io/rust-ffi-guide/)
