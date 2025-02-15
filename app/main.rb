#!/usr/bin/ruby

def type(command)
  return"#{command} is a shell builtin" if ["exit", "echo", "type", "pwd", "cd"].include?(command)

  exe = find_executable(command)

  return "#{command} is #{exe[0]}/#{exe[1]}" if exe

  "#{command}: not found"
end

def cd(path)
  begin
    Dir.chdir(path)
    nil
  rescue Errno::ENOENT
    "cd: #{path}: No such file or directory"
  end
end

def find_executable(command)
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exe = File.join(path, command)
    return [path, command] if File.executable?(exe) && !File.directory?(exe)
  end
  nil
end

while true do
  $stdout.write("$ ")

  command, *args = gets.chomp.split(" ")

  break if command == "exit"
  next if command == nil

  if command == "type"
    $stdout.write(type(args[0]) + "\n")
    next
  end
  
  if command == "echo"
    $stdout.write(args.join(" ") + "\n")
    next
  end

  if command == "pwd"
    $stdout.write(Dir.pwd + "\n")
    next
  end

  if command == "cd"
    output = cd(args[0])
    $stdout.write(output + "\n") if output
    next
  end

  executable = find_executable(command)
  if executable
    system(executable[1], *args)
    next
  end

  $stdout.write("#{command}: command not found\n")
end