{
  local l is List(1,2,3).
  for i in l:copy{
    print i.
    l:add(i).
  }
  print l.
}