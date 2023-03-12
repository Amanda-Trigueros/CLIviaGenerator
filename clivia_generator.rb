require "httparty"
require "json"
require_relative "presenter"
require_relative "requester"
require "terminal-table"
require "pry"

class CliviaGenerator
  attr_reader :filename
  include Presenter
  include Requester

  BASE_URL = "https://opentdb.com/api.php?amount=10"

  def initialize(filename)
    @filename = filename
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
      when "random" then random_trivia
      when "score" then puts print_scores
      when "exit" then   puts ["#####################################",
                              "# Thanks for using CLIvia Generator #",
                              "#####################################"].join("\n")
      end
    end
  end

  def random_trivia
    load_questions
    ask_questions
  end

  def ask_questions
    ask_question(each_question)
  end

  def save(data)
    @user_score_array << data
    File.write(@filename, JSON.pretty_generate(@user_score_array))
  end

  def parse_scores
    begin
     JSON.parse(File.read(@filename), symbolize_names: true)
    rescue JSON::ParserError
     Array.new
    end 
  end

  def load_questions
    response = HTTParty.get(BASE_URL)
    @questions = JSON.parse(response.body, symbolize_names: true)
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
