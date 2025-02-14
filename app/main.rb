$stdout.write("$ ")

# Wait for user input
command, *args = gets.chomp.split(" ")

$stdout.write("#{command}: command not found")