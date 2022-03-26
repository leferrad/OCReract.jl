var documenterSearchIndex = {"docs":
[{"location":"#OCReract.jl","page":"Home","title":"OCReract.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"OCReract is a simple Julia wrapper of the well-known OCR engine called Tesseract OCR. It is intended to be a very simple package used for two goals:","category":"page"},{"location":"","page":"Home","title":"Home","text":"In disk: Run tesseract command from a Julia session to load an image in disk and write the results in a text file.\nIn memory: Process an image loaded in memory and get OCR results as a string in a Julia session.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"It can be installed using the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run:","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add OCReract","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In this simple example, we will process the following image through the two options mentioned:","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: Test Image)","category":"page"},{"location":"#In-disk","page":"Home","title":"In disk","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Let's execute run_tesseract to process the image from repository's test folder, and then cat the resulting text file.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using OCReract\njulia> img_path = \"test/files/noisy.png\";\njulia> res_path = \"/tmp/res.txt\";\njulia> run_tesseract(img_path, res_path);\njulia> read(`cat $res_path`, String)\n\"Noisy image\\nto test\\nOCReract.jl\\n\\f\"","category":"page"},{"location":"#In-memory","page":"Home","title":"In memory","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"OCReract uses JuliaImages module to process images in memory. So, the image should be loaded with Images module to then execute run_tesseract to retrieve the result as a String.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Images\njulia> using OCReract\njulia> img_path = \"https://raw.githubusercontent.com/leferrad/OCReract.jl/master/test/files/noisy.png\";\njulia> img = Images.load(img_path);\njulia> res_text = run_tesseract(img);\njulia> println(strip(res_text))\nNoisy image\nto test\nOCReract.jl\n","category":"page"},{"location":"#API-Reference","page":"Home","title":"API Reference","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [OCReract]\nPrivate = false\nOrder = [:type, :function]","category":"page"},{"location":"#OCReract.run_tesseract-Tuple{Any}","page":"Home","title":"OCReract.run_tesseract","text":"run_tesseract(args...; kwargs...) -> String\n\nFunction to run Tesseract over an image in memory, and get the results in a String. Errors / Warnings are reported through Logging, so no exceptions are thrown.\n\nArguments\n\nimage: Image to be processed, in a format compatible with Images module.\n\nKeywords\n\nlang::Union{String, Nothing} Language to be configured in Tesseract (optional)\npsm::Integer: Page segmentation modes (PSM):\npsm=0:   Orientation and script detection (OSD) only.\npsm=1:   Automatic page segmentation with OSD.\npsm=2:   Automatic page segmentation, but no OSD, or OCR.\npsm=3:   Fully automatic page segmentation, but no OSD. (Default)\npsm=4:   Assume a single column of text of variable sizes.\npsm=5:   Assume a single uniform block of vertically aligned text.\npsm=6:   Assume a single uniform block of text.\npsm=7:   Treat the image as a single text line.\npsm=8:   Treat the image as a single word.\npsm=9:   Treat the image as a single word in a circle.\npsm=10:  Treat the image as a single character.\npsm=11:  Sparse text. Find as much text as possible in no particular order.\npsm=12:  Sparse text with OSD.\npsm=13:  Raw line. Treat the image as a single text line,   bypassing hacks that are Tesseract-specific.\noem::Integer: OCR Engine modes (OEM):\noem=0:   Legacy engine only.\noem=1:   Neural nets LSTM engine only. (Default)\noem=2:   Legacy + LSTM engines.\noem=3:   Default, based on what is available.\nkwargs: Other key-value pairs to be sent to Tesseract command as \"-c\" config variables.   You can check the options with tesseract --print-parameters.\n\nReturns\n\nString: text extracted, or empty string in case an error occurs\n\nExamples\n\njulia> using Images;\njulia> using OCReract;\njulia> img_path = \"/path/to/img.png\";\njulia> img = Images.load(img_path);\njulia> res_text = run_tesseract(img, psm=3, oem=1);\njulia> println(strip(res_text));\n\n\n\n\n\n","category":"method"},{"location":"#OCReract.run_tesseract-Tuple{String, String}","page":"Home","title":"OCReract.run_tesseract","text":"run_tesseract(args...; kwargs...) -> Bool\n\nWrapper function to run Tesseract over a image stored in disk,     and write the results in a given path. Errors / Warnings are reported through Logging, so no exceptions are thrown.\n\nArguments\n\ninput_path::String: Path to the image to be processed\noutput_path::String: Path to the text result to be written\n\nKeywords\n\nlang::Union{String, Nothing} Language to be configured in Tesseract (optional).\npsm::Integer: Page segmentation modes (PSM):\npsm=0:   Orientation and script detection (OSD) only.\npsm=1:   Automatic page segmentation with OSD.\npsm=2:   Automatic page segmentation, but no OSD, or OCR.\npsm=3:   Fully automatic page segmentation, but no OSD. (Default)\npsm=4:   Assume a single column of text of variable sizes.\npsm=5:   Assume a single uniform block of vertically aligned text.\npsm=6:   Assume a single uniform block of text.\npsm=7:   Treat the image as a single text line.\npsm=8:   Treat the image as a single word.\npsm=9:   Treat the image as a single word in a circle.\npsm=10:  Treat the image as a single character.\npsm=11:  Sparse text. Find as much text as possible in no particular order.\npsm=12:  Sparse text with OSD.\npsm=13:  Raw line. Treat the image as a single text line,   bypassing hacks that are Tesseract-specific.\noem::Integer: OCR Engine modes (OEM):\noem=0:   Legacy engine only.\noem=1:   Neural nets LSTM engine only. (Default)\noem=2:   Legacy + LSTM engines.\noem=3:   Default, based on what is available.\nkwargs: Other key-value pairs to be sent to Tesseract command as \"-c\" config variables.    You can check the options with tesseract --print-parameters.\n\nReturns\n\nBool: indicating whether execution was successful or not\n\nExamples\n\njulia> using OCReract;\njulia> img_path = \"/path/to/img.png\";\njulia> out_path = \"/tmp/tesseract_result.txt\";\njulia> run_tesseract(img_path, out_path, psm=3, oem=1)\n\n\n\n\n\n","category":"method"}]
}
