function path:parent --wraps "dirname -0" --description "Get the path to the parent directory of a path"
  command dirname -0 $argv
end

function path:absolute --wraps "readlink -f" --description "Get the absolute version of a path"
  command readlink -f $argv
end
