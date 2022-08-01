using FileIO
using Images
using Logging

export
    run_tesseract

# Tesseract settings
command = "tesseract"
psm_valid_range = 0:14
oem_valid_range = 0:4

"""Util to check and inform whether Tesseract is installed or not"""
function check_tesseract_installed()
    try
        read(`$command --version`, String);
    catch IOError
        @error "Tesseract is not properly installed. Command $command not recognized"
    end
end

check_tesseract_installed()

"""Util to get version of Tesseract installed"""
function get_tesseract_version()
    info = read(`$command --version`, String)
    version = split(info, "\n")[1]
    return version
end

@info "Using Tesseract version: $(get_tesseract_version())"

"""
    run_tesseract(input_path, output_path, extra_args...; kwargs...) -> Bool

Wrapper function to run Tesseract over a image stored in disk,
    and write the results in a given path.
Errors / Warnings are reported through `Logging`, so no exceptions are thrown.

# Arguments
- `input_path::String`: Path to the image to be processed
- `output_path::String`: Path to the text result to be written
- `extra_args` (`String`s): Optional arguments to change the nature of the output
  (e.g, [`"tsv"`](https://tesseract-ocr.github.io/tessdoc/Command-Line-Usage.html))

# Keywords
- `lang::Union{String, Nothing}` Language to be configured in Tesseract (optional).
- `psm::Integer`: Page segmentation modes (PSM):
    - `psm=0`:   Orientation and script detection (OSD) only.
    - `psm=1`:   Automatic page segmentation with OSD.
    - `psm=2`:   Automatic page segmentation, but no OSD, or OCR.
    - `psm=3`:   Fully automatic page segmentation, but no OSD. (Default)
    - `psm=4`:   Assume a single column of text of variable sizes.
    - `psm=5`:   Assume a single uniform block of vertically aligned text.
    - `psm=6`:   Assume a single uniform block of text.
    - `psm=7`:   Treat the image as a single text line.
    - `psm=8`:   Treat the image as a single word.
    - `psm=9`:   Treat the image as a single word in a circle.
    - `psm=10`:  Treat the image as a single character.
    - `psm=11`:  Sparse text. Find as much text as possible in no particular order.
    - `psm=12`:  Sparse text with OSD.
    - `psm=13`:  Raw line. Treat the image as a single text line,
        bypassing hacks that are Tesseract-specific.
- `oem::Integer`: OCR Engine modes (OEM):
    - `oem=0`:   Legacy engine only.
    - `oem=1`:   Neural nets LSTM engine only. (Default)
    - `oem=2`:   Legacy + LSTM engines.
    - `oem=3`:   Default, based on what is available.
- `kwargs`: Other key-value pairs to be sent to Tesseract command as "-c" config variables.
    You can check the options with `tesseract --print-parameters`.

# Returns
- `Bool`: indicating whether execution was successful or not

# Examples
```julia-repl
julia> using OCReract;
julia> img_path = "/path/to/img.png";
julia> out_path = "/tmp/tesseract_result.txt";
julia> run_tesseract(img_path, out_path, psm=3, oem=1)
```

"""
function run_tesseract(
    input_path::String,
    output_path::String,
    extra_args::String...;
    lang::Union{String, Nothing}=nothing,
    psm::Integer=3,
    oem::Integer=1,
    kwargs...
)
    # Check arguments
    if !isfile(input_path)
        @error "Input path '$input_path' doesn't exist!"
        return false
    end

    if isfile(output_path)
        @warn "Output path '$output_path' already exists!"
    end

    if !(psm in psm_valid_range)
        psm = 3
        @warn "PSM parameter not in valid range: [$(string(psm_valid_range))]. "*
              "Changing to default value: psm=$psm"
    end

    if !(oem in oem_valid_range)
        oem = 1
        @warn "OEM parameter not in valid range: [$(string(oem_valid_range))]. "*
              "Changing to default value: oem=$oem"
    end

    # Build command to execute
    cmd = "tesseract $input_path $output_path"

    # Add language if specified
    if lang !== nothing
        cmd = join([cmd, "-l $lang"], " ")
    end

    # Add config variables from kwargs
    config_vars = ""
    for (k, v) in kwargs
        config_vars *= "-c $k=$v "
    end

    # Join arguments to final command
    cmd = join([cmd, "--oem $oem", "--psm $psm", config_vars, extra_args...], " ")
    @debug "Running command '$cmd' ..."

    # Run command
    try
        run(`$(split(cmd))`)
    catch e
        @error "Error ocurred while running Tesseract! $e"
        return false
    end

    # NOTE: tesseract ALWAYS add a suffix ".txt" to the result
    # so, rename the resulting file to call it as the user defined
    output_file = output_path*".txt"
    try
        mv(output_file, output_path, force=true)
    catch e
        # At least, inform that to the user
        @warn "Result was stored in '$output_file'"
    end

    return true
end

"""
    run_tesseract(image, extra_args...; kwargs...) -> String

Function to run Tesseract over an image in memory, and get the results in a `String`.
Errors / Warnings are reported through `Logging`, so no exceptions are thrown.

# Arguments
- `image`: Image to be processed, in a format compatible with `Images` module.
- `extra_args` (`String`s): Optional arguments to change the nature of the output
  (e.g, [`"tsv"`](https://tesseract-ocr.github.io/tessdoc/Command-Line-Usage.html))

# Keywords
- `lang::Union{String, Nothing}` Language to be configured in Tesseract (optional)
- `psm::Integer`: Page segmentation modes (PSM):
    - `psm=0`:   Orientation and script detection (OSD) only.
    - `psm=1`:   Automatic page segmentation with OSD.
    - `psm=2`:   Automatic page segmentation, but no OSD, or OCR.
    - `psm=3`:   Fully automatic page segmentation, but no OSD. (Default)
    - `psm=4`:   Assume a single column of text of variable sizes.
    - `psm=5`:   Assume a single uniform block of vertically aligned text.
    - `psm=6`:   Assume a single uniform block of text.
    - `psm=7`:   Treat the image as a single text line.
    - `psm=8`:   Treat the image as a single word.
    - `psm=9`:   Treat the image as a single word in a circle.
    - `psm=10`:  Treat the image as a single character.
    - `psm=11`:  Sparse text. Find as much text as possible in no particular order.
    - `psm=12`:  Sparse text with OSD.
    - `psm=13`:  Raw line. Treat the image as a single text line,
        bypassing hacks that are Tesseract-specific.
- `oem::Integer`: OCR Engine modes (OEM):
    - `oem=0`:   Legacy engine only.
    - `oem=1`:   Neural nets LSTM engine only. (Default)
    - `oem=2`:   Legacy + LSTM engines.
    - `oem=3`:   Default, based on what is available.
- `kwargs`: Other key-value pairs to be sent to Tesseract command as "-c" config variables.
    You can check the options with `tesseract --print-parameters`.

# Returns
- `String`: text extracted, or empty string in case an error occurs

# Examples
```julia-repl
julia> using Images;
julia> using OCReract;
julia> img_path = "/path/to/img.png";
julia> img = Images.load(img_path);
julia> res_text = run_tesseract(img, psm=3, oem=1);
julia> println(strip(res_text));
```
"""
function run_tesseract(
    image::AbstractArray,
    extra_args::String...;
    lang::Union{String, Nothing}=nothing,
    psm::Integer=3,
    oem::Integer=1,
    kwargs...
)
    input_path = tempname() * ".png"   # PNG image resulting
    output_path = tempname() * ".txt"  # TXT file resulting

    # Save image into disk to be handled by Tesseract
    FileIO.save(input_path, image)

    # Run Tesseract!
    run_tesseract(input_path, output_path, extra_args...; lang=lang, psm=psm, oem=oem, kwargs...)

    # Read output into a string
    txt = ""
    open(output_path, "r") do f
        txt = read(f, String)
    end

    # Now remove these temporary files generated
    try
        @debug "Removing temporary files generated..."
        rm(input_path)
        rm(output_path)
    catch e
        @warn "Error ocurred while removing temporary files! $e"
    end

    return txt
end
