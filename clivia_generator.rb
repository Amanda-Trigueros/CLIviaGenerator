require "httparty"
require "json"
require_relative "presenter"
require_relative "requester"
require "terminal-table"

class CliviaGenerator
  attr_accessor :each_question, :user_answer

  # include HTTParty
  include Presenter
  include Requester

  BASE_URL = "https://opentdb.com/api.php?amount=10"

  def initialize
    @questions = []
    @user_score_array = parse_scores
    @user_answer = ""
  end

  def start
    print_welcome

    action = ""
    until action == "exit"
      action = select_main_menu_action

      case action
      when "random" then puts random_trivia
      when "score" then puts print_scores
      when "exit" then puts  puts ["#####################################",
                                   "# Thanks for using CLIvia Generator #",
                                   "#####################################"].join("\n")
      end
      # rescue HTTParty::ResponseError => e
      #  parsed_error = JSON.parse(e.message, symbolize_names: true)
      #  puts parsed_error
      # end
    end
  end

  def random_trivia
    # load the questions from the api load_questions
    # questions are loaded, then let's ask them ask_question
    load_questions
    ask_questions
  end

  def ask_questions
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
    ask_question(each_question)
  end

  def save(data)
    @user_score_array << data
    File.write("score.json", JSON.pretty_generate(@user_score_array))
  end

  def parse_scores
    JSON.parse(File.read("score.json"), symbolize_names: true)
  end

  def load_questions
    response = HTTParty.get(BASE_URL)
    @questions = JSON.parse(response.body, symbolize_names: true)
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = ["Name", "Score"]
    ordered_json = @user_score_array.sort_by { |x| -x[:score] }
    table.rows = ordered_json.map do |data|
      [data[:name], data[:score]]
    end
    table
  end
end
