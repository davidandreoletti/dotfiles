has_gpu_nivida() {
  if is_fedora || is_archl; then
    if lspci | grep -i nvidia; then
        return 0
    fi
  fi
}
