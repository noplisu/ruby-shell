def type(command)
  return"#{command} is a shell builtin" if ["exit", "echo", "type"].include?(command)

  paths = ENV['PATH'].split(':')
  paths.each do |path|
    begin
      next unless Dir.entries(path).detect do |child|
        child == command
      end
      return "#{command} is #{File.join(path, command)}"
    rescue Errno::ENOENT
      next
    end
  end

  "#{command}: not found"
end

while true do
  $stdout.write("$ ")

  command, *args = gets.chomp.split(" ")

  break if command == "exit"
  if command == "type"
    $stdout.write(type(args[0]) + "\n")
  elsif command == "echo"
    $stdout.write(args.join(" ") + "\n")
  else
    $stdout.write("#{command}: command not found\n")
  end
end