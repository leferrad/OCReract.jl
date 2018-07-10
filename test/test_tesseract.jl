include("../src/OCReract.jl")

import Images

using OCReract
using Base.Test

module TestOCReract

path_to_test_img = "$(pwd())/test/files/testocr.png"

function test_run_tesseract()
    expected_text = "This is a lot of 12 point text to test the\nocr code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox."
    
    run_tesseract(path_to_test_img, "/tmp/res")
        
    result_txt = ""

    open("/tmp/res.txt", "r") do f
        result_txt = readstring(f)
    end

    Base.Test.@test strip(expected_text) == strip(result_txt)

end


function test_run_and_get_output()
    expected_text = "This is a lot of 12 point text to test the\nocr code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox."
    
    result_txt = run_and_get_output(Images.load(path_to_test_img))

    Base.Test.@test strip(expected_text) == strip(result_txt)

end

Base.Test.@testset "RunTesseract" begin
    # TODO: avoid this inside the testset (so far, not working without these imports here)
    import Images
    using OCReract

    test_run_tesseract()
    test_run_and_get_output()
end

end