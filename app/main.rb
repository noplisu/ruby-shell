#!/usr/bin/ruby

require 'shellwords'

def type(command)
  return"#{command} is a shell builtin" if builtin?(command)

  exe = find_executable(command)

  return "#{command} is #{exe[0]}/#{exe[1]}" if exe

  "#{command}: not found"
end

def cd(path)
  begin
    return nil if !path

    Dir.chdir(File.expand_path(path))

    nil
  rescue Errno::ENOENT
    "cd: #{path}: No such file or directory\n"
  end
end

def find_executable(command)
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exe = File.join(path, command)
    return [path, command] if File.executable?(exe) && !File.directory?(exe)
  end
  nil
end

def stdout(output)
  $stdout.write(output) if output
end

def builtin(command, args)
  return "#{type(args[0])}\n" if command == "type"
  return "#{args.join(" ")}\n" if command == "echo"
  return "#{Dir.pwd}\n" if command == "pwd"
  return cd(args[0]) if command == "cd"
end

def builtin?(command)
  ["exit", "echo", "type", "pwd", "cd"].include?(command)
end

def cat_command(args)
  all_content = args.map do |file|
    file = file.strip
    if File.exist?(file)
      File.read(file).strip
    else
      $stderr.write("cat: #{file}: No such file or directory\n")
      nil
    end
  end
  "#{all_content.join('')}\n"
end

def handle_command(command, args)
  return builtin(command, args) if builtin?(command)

  begin
    return cat_command(args) if command == 'cat'

    executable = find_executable(command)
    # return `'#{executable[1]}' #{args.join(" ")}` if executable
    success = system(command, *args) if executable
    return nil if success
  rescue Errno::ENOENT
    $stderr.write("#{command} #{args.join(" ")}: No such file or directory")
  end

  "#{command}: command not found\n"
end

def redirect_stdout?(args)
  args[-2] == ">" || args[-2] == "1>"
end

while true do
  $stdout.write("$ ")
  command, *args = Shellwords.split(gets.chomp)

  break if command == "exit"
  next if command == nil

  if redirect_stdout?(args)
    original_stdout = $stdout.dup
    begin
      $stdout.reopen(args[-1], "w")
      stdout(handle_command(command, args[0..-3]))
    ensure
      $stdout.reopen(original_stdout)
    end
  else
    stdout(handle_command(command, args))
  end
end