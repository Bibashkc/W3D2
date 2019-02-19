require 'sqlite3'
require 'byebug'
require_relative 'user.rb'
require_relative 'questions.rb'
require_relative 'questionsdatabase.rb'


class QuestionFollow
    attr_accessor :id,:author_id,:question_id

    def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum)}
    end

    def self.most_followed_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT *
        FROM
        questions
        JOIN question_follows ON question_follows.question_id = questions.id
        GROUP BY question_id
        ORDER BY COUNT(question_id) DESC
        LIMIT
            ?

        SQL
        data.map{|question|Question.new(question)}
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT *
        FROM
        users
        JOIN question_follows ON question_follows.question_id = users.id
        WHERE
        question_id = ?
        SQL
        data.map {|user| User.new(user) }
    end

    def self.followed_questions_for_user_id(author_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT *
        FROM
        questions
        JOIN question_follows ON question_follows.author_id = questions.author_id
        WHERE
        question_follows.author_id = ?
        SQL
        data.map {|user| Question.new(user) }
    end

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
    end

    def insert
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.author_id, self.question_id)
      INSERT INTO
        question_follows (author_id, question_id)
      VALUES
        (?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

end
