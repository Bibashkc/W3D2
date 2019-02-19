require 'sqlite3'
require 'byebug'
require_relative 'user.rb'
require_relative 'questions.rb'
require_relative 'questionsdatabase.rb'

class Reply
         attr_accessor :id,:body,:author_id,:question_id,:parent_id

    def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum)}
    end

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM replies
        WHERE 
        id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def self.find_by_user_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM replies
        WHERE 
        author_id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def self.find_by_question_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM replies
        WHERE 
        question_id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def self.find_by_parent_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL,id)
        SELECT *
        FROM replies
        WHERE 
        parent_id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @author_id = options['author_id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
    end


    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        raise 'top-level reply' if @parent_id.nil?
        Reply.find_by_id(self.parent_id)
    end

    def child_replies #id needs to match parent id 
        Reply.find_by_parent_id(self.id)
    end

end