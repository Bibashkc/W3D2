require_relative 'QuestionsDatabase'
require_relative 'user'
require 'sqlite3'
require 'byebug'

class Question
     attr_accessor :id,:title,:body,:author_id

    def most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum)}
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM questions
        WHERE 
        id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end


    def self.find_by_author_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM questions
        WHERE 
        author_id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end

    def most_liked(n)
        QuestionLikes.most_liked_questions(n)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_question_id(question_id)
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end

    def likers
        QuestionLikes.likers_for_question_id(id)
    end

    def num_likes
        QuestionLikes.num_likes_for_question_id(id)
    end
end