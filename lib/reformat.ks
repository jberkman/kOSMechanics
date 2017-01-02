put({
  for f in core:volume:files:keys{print f. deletePath("1:/"+f).}
  local n is core:bootFileName.
  copyPath("0:"+n,"1:"+n).
  reboot.
}).