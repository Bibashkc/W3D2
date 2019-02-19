require_relative 'QuestionsDatabase'
require 'byebug'


class QuestionLikes

    def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLikes.new(datum)}
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.likers_for_question_id(question_id)
        Question.find_by_id(question_id).author
    end

    def self.num_likes_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT COUNT(question_id)
        FROM users
        JOIN question_likes ON question_likes.user_id = users.id
        GROUP BY ?
        SQL
        data.first.values.first
    end

    def self.liked_questions_for_user_id(user_id)
        #User.find_by_id(user_id).
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT question_id
        FROM question_likes
        WHERE question_likes.user_id = ?
        SQL
        question = data.first.values.first
        Question.find_by_id(question)
    end

    def self.most_liked_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT *
        FROM
        questions
        JOIN question_likes ON question_likes.question_id = questions.id
        GROUP BY question_id
        ORDER BY COUNT(question_id) DESC
        LIMIT
            ?

        SQL
        data.map{|question|Question.new(question)}
    end

    
end