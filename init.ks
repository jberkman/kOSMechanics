put({parameter p, a is list().local f is get("lib/fnapply.ks").until 0{until ship:messages:empty{local m is ship:messages:pop():content. f(get(m[0]),m[1]).}return get(p,"main.ks").}print "Waiting for commands...".wait until not ship:messages:empty.}).