def type(args)
  if ["exit", "echo", "type"].include?(args[0])
    "#{args[0]} is a shell builtin"
  else
    "#{args[0]}: not found"
  end
end

while true do
  $stdout.write("$ ")

  command, *args = gets.chomp.split(" ")

  break if command == "exit"
  if command == "type"
    $stdout.write(type(args) + "\n")
  elsif command == "echo"
    $stdout.write(args.join(" ") + "\n")
  else
    $stdout.write("#{command}: command not found\n")
  end
end