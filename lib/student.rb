require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
      SQL

      DB[:conn].execute(sql)
    end

    def self.drop_table
      DB[:conn].execute("DROP TABLE students")
    end

    def save
      if id
        update
      else
        sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL

        DB[:conn].execute(sql, name, grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
      end
    end

    def update
      sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ? WHERE id = ?
      SQL

      DB[:conn].execute(sql, name, grade, id)
    end

    def self.find_by_name(name)
      sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL

      DB[:conn].execute(sql, name).first
    end
end
