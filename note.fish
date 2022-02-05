set notedir ~/.local/share/note/
set dateformat "%Y%m%dT%H%M%SZ%Z"
set note_version "0.0.0"

function note
  switch $argv[1]
    case new
      note-new $argv[2..-1]
    case list ""
      note-list
    case edit
      note-edit $argv[2..-1]
    case info
      note-info $argv[2..-1]
    case help
      note-help
    case version
      note-version
    case "*"
      do_bad_command
  end
end

function note-new
  set date_prefix (date "+$dateformat")
  if test (count $argv) -lt 1
    set title ""
  else
    set title $argv[1]
  end
  $EDITOR $notedir/$date_prefix-(random_id)-$title.txt
end

function note-list
  for n in (ls $notedir)
    set note_info (string split - $n)
    echo -n (date -jf $dateformat $note_info[1])
    echo -n \t
    echo -n $note_info[2]
    echo -n \t
    echo (head -n 1 $notedir/$n)
  end
end

function note-edit
  set hesj $argv[1]

  for n in (ls $notedir)
    set note_info (string split - $n)
    if test $hesj = $note_info[2]
      $EDITOR $notedir/$n
      return
    end
  end
  echo "Note with id" $hesj "not found"
  return 1
end

function note-info
  set hesj $argv[1]

  for n in (ls $notedir)
    set note_info (string split - $n)
    if test $hesj = $note_info[2]
      echo "   id:" $note_info[2]
      echo " file:" $notedir/$n
      echo " time:" (date -jf $dateformat $note_info[1])
      echo " head:" (head -n 1 $notedir/$n)
      return
    end
  end
  echo "Note with id" $hesj "not found"
  return 1
end

function random_id
  string sub -s 3 (math --base=hex (random (math 0x10000000) (math 0xffffffff)))
end



function note-help
  echo "note.fish - note taking and note giving"
  echo "version" $note_version
  echo
  usage
end

function note-version
  echo "note.fish version" $note_version
end

function do_bad_command
  echo "bad command"
  usage
  return 1
end

function usage
  echo "note [new|list|edit|info|help|version]"
end
