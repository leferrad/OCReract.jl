__precompile__()

module OCReract

export 
    run_tesseract, 
    run_and_get_output

include("tesseract.jl")

"""
OCReract is a simple Julia wrapper of the well-known OCR engine called Tesseract.

Here, a simple example of usage:

# Example
```julia-repl
julia> using Images;
julia> using OCReract;
julia> img_path = "/path/to/img.png";
julia> img = Images.load(img_path);
julia> res_text = run_and_get_output(img, psm=3, oem=1);
julia> println(res_text);
```

For more information, check the homepage in https://github.com/leferrad/OCReract.jl.
"""
OCReract

end # module