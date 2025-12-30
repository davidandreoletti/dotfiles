f_image_convert_raster_to_vector() {
    local input_file="$1"
    local output_file="$2"
    local pbm_file="/tmp/$RANDOM.pbm"

    # Convert to monochrome PBM using ImageMagick
    magick convert "$input_file" -threshold 50% -monochrome "$pbm_file"
    # Convert PBM to SVG using Potrace
    potrace -s -o "$output_file" "$pbm_file"
    # Clean up the intermediate PBM file
    rm "$pbm_file"
}
