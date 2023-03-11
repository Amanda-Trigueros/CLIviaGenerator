require_relative "clivia_generator"

# capture command line arguments (ARGV)

# filename = ARGV[0] || "score.json"
# data = {}
# if File.exists?(filename)
# data = JSON.parse(File.read(filename))
# end
# File.open(filename, "w") do |file|
# file.write(JSON.generate(data))
# end

trivia = CliviaGenerator.new
trivia.start
