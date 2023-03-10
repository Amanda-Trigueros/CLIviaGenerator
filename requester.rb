module Requester

  def select_main_menu_action
    list_options = ["random", "score", "exit"]
    gets_option(option: list_options, prompt: list_options)
  end

  def ask_question(each_question)
    CliviaGenerator.new
    
    question_array = @questions[:results]
    score = 0
    for each_question in question_array
      puts "Category: #{each_question[:category]} | Difficulty: #{each_question[:difficulty]}"
      puts "Question: #{each_question[:question]}"
      all_answers = [each_question[:correct_answer]] + each_question[:incorrect_answers]
      shuffled_answers = all_answers.shuffle
      shuffled_answers.each_with_index do |answer, index|
      puts "#{index + 1}. #{answer}"
      end 
      user_answer_index = ""
      print "> "
      user_answer_index = gets.chomp.to_i
      @user_answer = shuffled_answers[user_answer_index - 1]

      # ASK_QUESTIONS
      
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
    puts "Well done! Your score is #{score}"
    puts "#{"-" * 50}"
    puts "Do you want to save your score? y/n "
    input = gets.chomp
    if input == "y"
      puts "Type the name to assign to the score"
      print "> "
      name = gets.chomp
      name = "Anonymus" if name == "" 
      data = { score: score, name: name }
      save(data)
    end

    

    print_welcome
  end

  def gets_option( prompt:, option:)
    input = ""
    loop do
      puts option.join(" | ")
      print "> "
      input = gets.chomp
      input ||= ""
      break if option.include?(input) || input.empty?

      puts "Invalid option"
    end
    input
  end
end
