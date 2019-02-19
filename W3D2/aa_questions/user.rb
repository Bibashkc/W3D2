require_relative 'QuestionsDatabase'

require 'sqlite3'
require 'byebug'


class User
    attr_accessor :id,:fname,:lname

    def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum)}
    end

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM users
        WHERE 
        id = ?
        SQL
        return nil unless user.length > 0
        User.new(user.first)
    end
    def self.find_by_name(fname,lname)
        user = QuestionsDatabase.instance.execute(<<-SQL,fname,lname)
        SELECT *
        FROM users
        WHERE 
        fname =? AND lname = ?
        SQL
        return nil unless user.length > 0
        User.new(user.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions   #pass in user instance, get back question instances
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(id)
    end

    def liked_questions
        QuestionLikes.liked_questions_for_user_id(id)
    end

    def average_karma
        data = QuestionsDatabase.instance.execute(<<-SQL)
        SELECT SUM(num_likes(question_id)) / CAST(COUNT(DISTINCT(question_id) AS FLOAT)
        FROM questions
        LEFT OUTER JOIN question_likes ON questions.id = question_likes.qustions_id
        GROUP BY question_id
        SQL
         
        data.first.values.first
    end
end