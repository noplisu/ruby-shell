while true do
  $stdout.write("$ ")

  # Wait for user input
  command, *args = gets.chomp.split(" ")

  break if command == "exit"
  if command == "echo"
    $stdout.write(args.join(" ") + "\n")
  else
    $stdout.write("#{command}: command not found\n")
  end
end