# Reduce PDF file to screen quality
# Usage: pdf_reduce_size_to_screen_quality source.pdf destination.pdf
function pdf_reduce_size_to_screen_quality {
    local input_file="$1"
    local output_file="$2"
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/screen -dNOPAUSE \
        -dQUIET -dBATCH \
        -sOutputFile="$output_file" "$input_file"
}
