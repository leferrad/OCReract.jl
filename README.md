# OCReract.jl

*A simple Julia wrapper for Tesseract OCR*

[![CI](https://github.com/leferrad/OCReract.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/leferrad/OCReract.jl/actions/workflows/CI.yml)
[![Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://leferrad.github.io/OCReract.jl/dev)
[![Coverage Status](https://codecov.io/gh/leferrad/OCReract.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/leferrad/OCReract.jl)
[![Join the chat at https://gitter.im/OCReract.jl](https://badges.gitter.im/OCReract.jl.svg)](https://gitter.im/OCReract-jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Installation

From the Julia REPL, type `]` to enter the Pkg REPL mode and run:
```julia-repl
pkg> add OCReract
```

This is just a wrapper, so it assumes you already have installed [Tesseract](https://tesseract-ocr.github.io/tessdoc/Installation.html).

## Usage

This is a simple example of usage. For more details check the [Documentation](https://leferrad.github.io/OCReract.jl/dev).

```julia
julia> using Images
julia> using OCReract
julia> img_path = "/path/to/img.png";
# In disk
julia> run_tesseract(img_path, "/tmp/res.txt", psm=3, oem=1)
# In memory
julia> img = Images.load(img_path);
julia> res_text = run_tesseract(img, psm=3, oem=1);
julia> println(strip(res_text));
```

## Testing

In a Julia session, run `Pkg.test("OCReract", coverage=true)`, or just run `julia --code-coverage=all --inline=no test/runtests.jl`.

## Next steps
- Develop a module for image pre-processing (to improve OCR results)
