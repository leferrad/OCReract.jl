using FileIO
using Images
using Logging

export
    run_and_get_output,
    run_tesseract

# Tesseract settings
command = "tesseract"
psm_valid_range = 0:14
oem_valid_range = 0:4

"""Util to check and inform whether Tesseract is installed or not"""
function check_tesseract_installed()
    try
        read(`$command --version`, String);
        @info "Tesseract is properly installed!"
    catch IOError
        @error "Tesseract is not properly installed!"
    end
end

check_tesseract_installed()

# TODO: function to set command for executing tesseract?

"""Util to get version of Tesseract installed"""
function get_tesseract_version()
    info = read(`$command --version`, String)
    version = split(info, "\n")[1]
    return version
end

@info "Using Tesseract version: $(get_tesseract_version())"

"""To be implemented"""
function image_to_boxes(image; lang="eng", config="", nice=0, boxes=false) end

"""To be implemented"""
function image_to_osd(image; lang="eng", config="", nice=0, boxes=false) end

"""
    run_tesseract(args...; kwargs...) -> Bool

Wrapper function to run Tesseract for a image stored in disk,
    and write the results in a given path.
Errors / Warnings are reported through logging, so no exceptions are thrown.

# Arguments
- `input_path::String`: Path to the image to be OCRed
- `output_path::String`: Path to the text result to be stored

# Keywords
- `lang::Union{String, Nothing}` Language to be configured in Tesseract (optional).
- `psm::Integer`: Page segmentation modes (PSM):
    0.    Orientation and script detection (OSD) only.
    1.    Automatic page segmentation with OSD.
    2.    Automatic page segmentation, but no OSD, or OCR.
    3.    Fully automatic page segmentation, but no OSD. (Default)
    4.    Assume a single column of text of variable sizes.
    5.    Assume a single uniform block of vertically aligned text.
    6.    Assume a single uniform block of text.
    7.    Treat the image as a single text line.
    8.    Treat the image as a single word.
    9.    Treat the image as a single word in a circle.
    10.    Treat the image as a single character.
    11.    Sparse text. Find as much text as possible in no particular order.
    12.    Sparse text with OSD.
    13.    Raw line. Treat the image as a single text line,
        bypassing hacks that are Tesseract-specific.
- `oem::Integer`: OCR Engine modes (OEM):
    0.    Legacy engine only.
    1.    Neural nets LSTM engine only. (Default)
    2.    Legacy + LSTM engines.
    3.    Default, based on what is available.

# Returns
- `Bool`: indicating whether execution was successful or not

# Examples
```julia-repl
julia> using OCReract;
julia> img_path = "/path/to/img.png";
julia> out_path = "/tmp/tesseract_result";
julia> run_tesseract(img_path, out_path, psm=3, oem=1)
```

"""
function run_tesseract(
    input_path::String,
    output_path::String;
    lang::Union{String, Nothing}=nothing,
    psm::Integer=3,
    oem::Integer=1
)
    # TODO: allow to handle user-words, user-patterns
    if !isfile(input_path)
        @error "Input path '$input_path' doesn't exist!"
        return false
    end

    # NOTE: adding .txt at the end of filename since tesseract ALWAYS add this suffix
    output_file = output_path*".txt"

    if isfile(output_file)
        @warn "Output path '$output_file' already exists!"
    end

    cmd = "tesseract $input_path $output_path"

    if lang !== nothing
        cmd = join([cmd, "-l $lang"], " ")
    end

    if !(psm in psm_valid_range)
        psm = 3
        @warn "PSM parameter not in valid range: [$(string(psm_valid_range))]. "*
              "Changing to default value: PSM=$psm"
    end


    if !(oem in oem_valid_range)
        oem = 1
        @warn "OEM parameter not in valid range: [$(string(oem_valid_range))]. "*
              "Changing to default value: OEM=$oem"
    end

    cmd = join([cmd, "--oem $oem --psm $psm"], " ")

    @debug "Running command '$cmd' ..."

    try
        run(`$(split(cmd))`)
    catch e
        @info "Error ocurred while running Tesseract! $e"
        return false
    end

    return true

end

"""
    run_and_get_output(args...) -> String

Function to run Tesseract over an image in memory, and get the results in a string.
Errors / Warnings are reported through logging, so no exceptions are thrown.

# Arguments
- `ìmage`: Image to be processed, in a format compatible with `Images` module.

# Keywords
- `lang::Union{String, Nothing}` Language to be configured in Tesseract (optional)
- `psm::Integer`: Page segmentation modes (PSM):
    0.    Orientation and script detection (OSD) only.
    1.    Automatic page segmentation with OSD.
    2.    Automatic page segmentation, but no OSD, or OCR.
    3.    Fully automatic page segmentation, but no OSD. (Default)
    4.    Assume a single column of text of variable sizes.
    5.    Assume a single uniform block of vertically aligned text.
    6.    Assume a single uniform block of text.
    7.    Treat the image as a single text line.
    8.    Treat the image as a single word.
    9.    Treat the image as a single word in a circle.
    10.    Treat the image as a single character.
    11.    Sparse text. Find as much text as possible in no particular order.
    12.    Sparse text with OSD.
    13.    Raw line. Treat the image as a single text line,
        bypassing hacks that are Tesseract-specific.
- `oem::Integer`: OCR Engine modes (OEM):
    0.    Legacy engine only.
    1.    Neural nets LSTM engine only. (Default)
    2.    Legacy + LSTM engines.
    3.    Default, based on what is available.

# Returns
- `String`: text extracted, empty string in case an error occurs

# Examples
```julia-repl
julia> using Images;
julia> using OCReract;
julia> img_path = "/path/to/img.png";
julia> img = Images.load(img_path);
julia> res_text = run_and_get_output(img, psm=3, oem=1);
julia> println(res_text);
```
"""
function run_and_get_output(
    image;
    lang::Union{String, Nothing}=nothing,
    psm::Integer=3,
    oem::Integer=1
)
    # TODO: handle image type
    input_path = tempname() * ".png"  # PNG image resulting
    output_path = tempname()  # No extension since we need to set the basename

    # Save image into disk to be handled by Tesseract
    FileIO.save(input_path, image)

    # Run Tesseract!
    run_tesseract(input_path, output_path, lang=lang, psm=psm, oem=oem)

    # Read output into a string
    output_filename = output_path*".txt"
    txt = ""

    open(output_filename, "r") do f
        txt = read(f, String)
    end

    # Now remove these temporary files generated
    try
        @debug "Removing temporary files generated..."
        rm(input_path)
        rm(output_filename)
    catch e
        @warn "Error ocurred while removing temporary files! $e"
    end

    return txt
end
