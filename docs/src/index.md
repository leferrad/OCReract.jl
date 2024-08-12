# OCReract.jl

OCReract is a simple Julia wrapper of the well-known OCR engine called [Tesseract OCR](https://github.com/tesseract-ocr/tesseract). It is intended to be a very simple package used for two goals:

1. **In disk:** Run `tesseract` command from a Julia session to load an image in disk and write the results in a text file.
2. **In memory:** Process an image loaded in memory and get OCR results as a string in a Julia session.

## Installation

The Tesseract OCR engine must be installed manually. On ubuntu, this may be as simple as

```
sudo apt-get install -y tesseract-ocr
```

but the [installation instructions](https://tesseract-ocr.github.io/tessdoc/Installation.html) are the authoritative source.

The Julia wrapper can be installed using the Julia package manager. From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```julia-repl
pkg> add OCReract
```

## Usage

In this simple example, we will process the following image through the two options mentioned:

![Test Image](https://raw.githubusercontent.com/leferrad/OCReract.jl/master/test/files/noisy.png)

### In disk

Let's execute `run_tesseract` to process the image from repository's test folder, and then `cat` the resulting text file.

```julia-repl
julia> using OCReract
julia> img_path = "test/files/noisy.png";
julia> res_path = "/tmp/res.txt";
julia> run_tesseract(img_path, res_path);
julia> read(`cat $res_path`, String)
"Noisy image\nto test\nOCReract.jl\n\f"
```

### In memory

`OCReract` uses [JuliaImages](https://juliaimages.org/latest/) module to process images in memory. So, the image should be loaded with `Images` module (or the lighter-weight combination `using ImageCore, FileIO`) to then execute `run_tesseract` to retrieve the result as a `String`.

```julia-repl
julia> using Images
julia> using OCReract
julia> img_path = "https://raw.githubusercontent.com/leferrad/OCReract.jl/master/test/files/noisy.png";
julia> img = load(img_path);
julia> res_text = run_tesseract(img);
julia> println(strip(res_text))
Noisy image
to test
OCReract.jl

```

## API Reference

```@index
```

```@docs
OCReract.OCReract
```

```@autodocs
Modules = [OCReract]
Private = false
Order = [:type, :function]
```
