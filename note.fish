set usage "note [new|list|help]"

function note
  set notedir ~/.local/share/note/
  switch $argv[1]
    case help
      print_help
    case list ""
      echo "nothing"
    case "*"
      echo "bad command"
      echo $usage
      return 1
  end
end


function print_help
  echo "note - note taking and note giving"
  echo
  echo $usage
end

