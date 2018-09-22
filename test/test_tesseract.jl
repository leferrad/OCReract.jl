import Images
using OCReract
using Test

pkg_path = abspath(joinpath(dirname(pathof(OCReract)), ".."))
path_to_test_img = "$(pkg_path)/test/files/testocr.png"

function test_run_tesseract()
    # TODO: read this expected text from a text file in test/files
    expected_text = "This is a lot of 12 point text to test the\nocr code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox."
    
    run_tesseract(path_to_test_img, "/tmp/res")
        
    result_txt = ""

    open("/tmp/res.txt", "r") do f
        result_txt = read(f, String)
    end

    @test strip(expected_text) == strip(result_txt)

end

function test_run_and_get_output()
    # TODO: read this expected text from a text file in test/files
    expected_text = "This is a lot of 12 point text to test the\nocr code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox."
    
    result_txt = run_and_get_output(Images.load(path_to_test_img))

    Test.@test strip(expected_text) == strip(result_txt)

end

@testset "RunTesseract" begin
    test_run_tesseract()
    test_run_and_get_output()
end
