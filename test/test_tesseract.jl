using ImageCore
using FileIO
using OCReract
using SimpleMock
using Test
using DelimitedFiles

pkg_path = abspath(joinpath(dirname(pathof(OCReract)), ".."))

TEST_ITEMS = Dict(
    "simple" => Dict(
        "path" => "$(pkg_path)/test/files/testocr.png",
        "text" => "This is a lot of 12 point text to test the\n"*
                  "ocr code and see if it works on all types\n"*
                  "of file format.\n\n"*
                  "The quick brown dog jumped over the\n"*
                  "lazy fox. The quick brown dog jumped\n"*
                  "over the lazy fox. The quick brown dog\n"*
                  "jumped over the lazy fox. The quick\n"*
                  "brown dog jumped over the lazy fox."
    ),
    "noisy" => Dict(
        "path" => "$(pkg_path)/test/files/noisy.png",
        "text" => "Noisy image\nto test\nOCReract.jl"
    )
)

function test_run_tesseract()
    tmp_path = tempname()
    mkdir(tmp_path)
    path_to_res = tmp_path*"/res.txt"
    res = run_tesseract(TEST_ITEMS["simple"]["path"], path_to_res)
    @test res == true

    result_txt = ""
    open(path_to_res, "r") do f
        result_txt = read(f, String)
    end
    @test strip(result_txt) == strip(TEST_ITEMS["simple"]["text"])

    # Again to test warning about already existing output file
    res = run_tesseract(TEST_ITEMS["simple"]["path"], path_to_res)
    @test res == true
end

function test_run_and_get_output()
    result_txt = run_tesseract(load(TEST_ITEMS["simple"]["path"]))
    @test strip(TEST_ITEMS["simple"]["text"]) == strip(result_txt)
end

function test_run_with_kwargs()
    # Set an option that will make OCR bad for this image
    result_txt = run_tesseract(load(TEST_ITEMS["noisy"]["path"]), tessedit_pageseg_mode=7)
    @test strip(TEST_ITEMS["noisy"]["text"]) != strip(result_txt)
end

function test_tsv()
    tmp_path = tempname()
    mkdir(tmp_path)
    path_to_res = joinpath(tmp_path, "res.tsv")
    @test run_tesseract(TEST_ITEMS["simple"]["path"], path_to_res, "tsv"; psm=11 #= sparse =#, lang="eng")

    table, header = readdlm(path_to_res, '\t'; header=true, quotes=false)
    @test vec(header) == ["level", "page_num", "block_num", "par_num", "line_num",
        "word_num", "left", "top", "width", "height", "conf", "text"]

    idx = findfirst(==("quick"), table[:,end])
    @test table[idx, end] == "quick"
    @test table[idx, #= word_num =# 6] == 2            # the first time "quick" appears, it's the 2nd word on the line
    @test table[idx, #= top =# 5] == table[idx-1, 5]   # aligned with previous word
    idx = findnext(==("quick"), table[:,end], idx+1)
    @test table[idx, #= word_num =# 6] == 4            # the second time "quick" appears, it's the 4th word on the line

    result = run_tesseract(load(TEST_ITEMS["simple"]["path"]), path_to_res, "tsv"; psm=11 #= sparse =#, lang="eng")
    @test result == read(path_to_res, String)
end

function test_path_exists()
    res = run_tesseract("/tmp/not_existing_image.png", "/tmp/res")
    @test res == false
end

function test_bad_arguments()
    # Bad Language
    tmp_path = tempname()
    mkdir(tmp_path)
    path_to_res = tmp_path*"/res.txt"
    res = run_tesseract(TEST_ITEMS["simple"]["path"], path_to_res, lang="not-existing-lang")
    @test res == false

    # Despite bad parameters oem and psm, this will work due to default changes
    res = run_tesseract(TEST_ITEMS["simple"]["path"], path_to_res, oem=100, psm=100)
    @test res == true
end

function test_check_tesseract_installed_ok()
    mock(
        (read, Cmd) => Mock((cmd) -> nothing),
    ) do mock_read
        OCReract.check_tesseract_installed()
        @test called_once(mock_read)
    end
end

function test_check_tesseract_installed_logs_error()
    mock(
        (read, Cmd) => Mock((cmd) -> throw(Base.IOError("Check failed!"))),
    ) do mock_read
        @test_logs (
            :error, "Tesseract is not properly installed. Command tesseract not recognized"
        ) OCReract.check_tesseract_installed()
        @test called_once(mock_read)
    end
end

function test_get_tesseract_version()
    version = OCReract.get_tesseract_version()
    tesseract_string, version_string = split(version, " ")
    @test tesseract_string == "tesseract"
    @test occursin(r"^([1-9]\d*|0)(\.(([1-9]\d*)|0)){2}$", version_string)
end

@testset "RunTesseract" begin
    # Normal run
    test_run_tesseract()
    # Run and get
    test_run_and_get_output()
    test_tsv()    # with TSV outputs
    # Test with non existent image
    test_path_exists()
    # Test with bad arguments
    test_bad_arguments()
    # Test with kwargs
    test_run_with_kwargs()
    # Test check of tesseract installed
    test_check_tesseract_installed_ok()
    test_check_tesseract_installed_logs_error()
    # Test getting tesseract version
    test_get_tesseract_version()
end
