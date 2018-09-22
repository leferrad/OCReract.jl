# OCReract.jl

*A simple Julia wrapper for Tesseract OCR*

[![Build Status](https://travis-ci.org/leferrad/OCReract.jl.svg?branch=master)](https://travis-ci.org/leferrad/OCReract.jl)
[![Coverage Status](https://coveralls.io/repos/github/leferrad/OCReract.jl/badge.svg?branch=master)](https://coveralls.io/github/leferrad/OCReract.jl?branch=master)
[![Join the chat at https://gitter.im/OCReract.jl](https://badges.gitter.im/OCReract.jl.svg)]
(https://gitter.im/OCReract-jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

> NOTE: still in development

Nowadays, this library only supports Julia v1.0.

## Installation

As with any unregistered package, just use `Pkg.clone()` with the repository url:

```julia
Pkg.clone("https://github.com/leferrad/OCReract.jl.git")
```

## Testing

In a Julia session, run `Pkg.test("OCReract", coverage=true)`, or just run `julia --code-coverage=all --inline=no test/runtests.jl`.

## Next steps
- Make a Dockerfile
- Develop a module for image pre-processing (to improve OCR results)