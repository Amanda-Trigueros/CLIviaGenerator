require "htmlentities"

module Requester
  attr_accessor :each_question, :user_answer

  def select_main_menu_action
    list_options = ["random", "score", "exit"]
    gets_option(option: list_options, prompt: list_options)
  end

  def ask_question(each_question)
    CliviaGenerator.new(filename)
    question_array = @questions[:results]
    score = 0
    for each_question in question_array
      decode_question = HTMLEntities.new.decode(each_question[:question])
      puts "Category: #{each_question[:category]} | Difficulty: #{each_question[:difficulty]}"
      puts "Question: #{decode_question}"
      all_answers = [each_question[:correct_answer]] + each_question[:incorrect_answers]
      decode_answers = all_answers.map { |answer| HTMLEntities.new.decode(answer) }
      shuffled_answers = decode_answers.shuffle
      shuffled_answers.each_with_index do |answer, index|
        puts "#{index + 1}. #{answer}"
      end
      user_answer_index = ""
      print "> "
      user_answer_index = gets.chomp.to_i
      @user_answer = shuffled_answers[user_answer_index - 1]

      if user_answer == each_question[:correct_answer]
        puts "Correct!"
        score += 10
      else
        puts "#{user_answer}...Incorrect!"
        puts "The correct answer was: #{each_question[:correct_answer]}"
      end
    end
    will_save?(score)
  end

  def will_save?(score)
    options = ["y", "n"]
    print_score(score)
    puts "Do you want to save your score?  "
    input = ""
    loop do
      puts options.join("/")
      print "> "
      input = gets.chomp.downcase
      break if options.include?(input) || input.empty?

      puts "Invalid option"
    end
    case input
    when "y"
      puts "Type the name to assign to the score"
      print "> "
      name = gets.chomp
      name = "Anonymus" if name == ""
      data = { score:, name: }
      save(data)
    when "n"
    end
    print_welcome
  end

  def gets_option(prompt:, option:)
    input = ""
    loop do
      puts option.join(" | ")
      print "> "
      input = gets.chomp.downcase
      input ||= ""
      break if option.include?(input) || input.empty?

      puts "Invalid option"
    end
    input
  end
end
