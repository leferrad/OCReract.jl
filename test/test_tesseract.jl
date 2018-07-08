include("../src/OCReract.jl")

using OCReract
using Base.Test

module TestOCReract

path_to_test_img = "$(pwd())/test/files/testocr.png"

expected_text = "This is a lot of 12 point text to test the\nocr code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox.\n\f"

function test()
    expected_text = "This is a lot of 12 point text to test the\nocr code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox.\n\f"
    
    run_tesseract(path_to_test_img, "/tmp/res")
        
    result_txt = ""

    open("/tmp/res.txt", "r") do f
        result_txt = readstring(f)
    end

    Base.Test.@test expected_text == result_txt

end

Base.Test.@testset "RunTesseract" begin
    # TODO: avoid this inside the testset (so far, not working without this importment)
    using OCReract

    test()
end

end