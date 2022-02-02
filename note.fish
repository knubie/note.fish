set usage "note [new|list|help]"
set notedir ~/.local/share/note/

function note
  switch $argv[1]
    case new
      do_new
    case list ""
      do_list
    case help
      print_help
    case "*"
      echo "bad command"
      echo $usage
      return 1
  end
end

function do_list
  ls $notedir
end

function do_new
  set date_prefix (date "+%Y-%m-%d-%H-%M-%S")
  $EDITOR $notedir/$date_prefix.txt
end

function print_help
  echo "note - note taking and note giving"
  echo
  echo $usage
end

