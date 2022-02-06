set notedir ~/.local/share/note/
set dateformat_file "%Y%m%dT%H%M%SZ%Z"
set dateformat_display "%Y-%m-%d %H:%M:%S %Z"
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
    case version "--version"
      note-version
    case "*"
      do_bad_command
  end
end

function note-new
  set date_prefix (date "+$dateformat_file")
  if test (count $argv) -lt 1
    set title ""
  else
    set title $argv[1]
  end
  $EDITOR $notedir/$date_prefix-(random_id)-$title.txt
end

function note-list
  set col_sep "  "
  set -e __note_shortlist
  set _index 1
  for n in (ls $notedir)
    set note_info (string split - $n)

    set note_hash $note_info[2]

    echo -n \($_index\)
    echo -n $col_sep
    echo -n $note_hash
    echo -n $col_sep
    echo -n (date -jf $dateformat_file $note_info[1] +$dateformat_display)
    echo -n $col_sep
    echo (head -n 1 $notedir/$n)

    set -ga __note_shortlist $note_hash
    set _index (math $_index + 1)
  end
end

function note-edit
  set target $argv[1]
  if is_shortlist_number $target
    set target $__note_shortlist[$target]
  end

  for n in (ls $notedir)
    set note_info (string split - $n)
    if test $target = $note_info[2]
      $EDITOR $notedir/$n
      return
    end
  end
  echo "Note with id" $argv[1] "not found"
  return 1
end

function note-info
  set hesj $argv[1]

  for n in (ls $notedir)
    set note_info (string split - $n)
    if test $hesj = $note_info[2]
      echo "   id:" $note_info[2]
      echo " file:" $notedir/$n
      echo " time:" (date -jf $dateformat_file $note_info[1])
      echo " head:" (head -n 1 $notedir/$n)
      return
    end
  end
  echo "Note with id" $hesj "not found"
  return 1
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

function random_id
  string sub -s 3 (math --base=hex (random (math 0x10000000) (math 0xffffffff)))
end

function is_shortlist_number
  return (test $argv[1] -le (count $__note_shortlist) 2>/dev/null)
end
