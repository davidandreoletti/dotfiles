#
# Image Manipulation
#

# Usage: concat_images_vertically in1.jpg in2.jpg in3.jpg out.jpg
alias image_concat_vertically="convert -append "

# Usage: concat_images_horizontally in1.jpg in2.jpg in3.jpg out.jpg
alias image_concat_horizontally="convert +append "

# Vectorize a raster image 
# Usage: image_raster_to_vector "/path/to/input.png" "/path/to/output.svg"
alias image_raster_to_vector="convert "$input_image" -threshold 50% -monochrome "$temp_pbm""
