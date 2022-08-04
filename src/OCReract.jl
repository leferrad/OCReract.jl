module OCReract

export
    run_tesseract

include("tesseract.jl")

"""
OCReract is a simple Julia wrapper of the well-known OCR engine called Tesseract.

Here, a simple example of usage:

# Example
```julia-repl
julia> using Images
julia> using OCReract
julia> img_path = "/path/to/img.png";
# In disk
julia> run_tesseract(img_path, "/tmp/res.txt", psm=3, oem=1)
# In memory
julia> img = load(img_path);
julia> res_text = run_tesseract(img, psm=3, oem=1);
julia> println(strip(res_text));
```

For more information, check the homepage in https://github.com/leferrad/OCReract.jl.
"""
OCReract

end # module
