set notedir ~/.local/share/note/
set dateformat "%Y%m%dT%H%M%SZ%Z"
set note_version "0.0.0"

function note
  switch $argv[1]
    case new
      do_new $argv
    case list ""
      do_list
    case help
      do_help
    case version
      do_version
    case "*"
      do_bad_command
  end
end

function do_list
  for n in (ls $notedir)
    set note_info (string split - $n)
    echo -n (date -jf $dateformat $note_info[1])
    echo -n \t
    echo -n $note_info[2]
    echo -n \t
    echo (head -n 1 $notedir/$n)
  end
end

function hesj
  string sub -s 3 (math --base=hex (random (math 0x10000000) (math 0xffffffff)))
end


function do_new
  set date_prefix (date "+$dateformat")
  if test (count $argv) -lt 2
    set title ""
  else
    set title $argv[2]
  end
  $EDITOR $notedir/$date_prefix-(hesj)-$title.txt
end

function do_help
  echo "note.fish - note taking and note giving"
  echo "version" $note_version
  echo
  usage
end

function do_version
  echo "note.fish" $note_version
end

function do_bad_command
  echo "bad command"
  usage
  return 1
end

function usage
  echo "note [new|list|help]"
end
