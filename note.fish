set usage "note [new|list|help]"
set notedir ~/.local/share/note/

function note
  switch $argv[1]
    case new
      do_new
    case list ""
      do_list
    case help
      do_help
    case "*"
      do_bad_command
  end
end

function do_list
  for n in (ls $notedir)
    echo -n (string sub -e -4 $n)
    echo -n \t
    echo (head -n 1 $notedir/$n)
  end
end

function do_new
  set date_prefix (date "+%Y-%m-%d-%H-%M-%S")
  $EDITOR $notedir/$date_prefix.txt
end

function do_help
  echo "note - note taking and note giving"
  echo
  echo $usage
end

function do_bad_command
  echo "bad command"
  echo $usage
  return 1
end
