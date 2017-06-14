class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    newstudent = Student.new
    newstudent.id = row[0]
    newstudent.name = row[1]
    newstudent.grade = row[2]
    newstudent
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    results = DB[:conn].execute(sql)
    new_results = []
    results.each do |row|
      new_results << self.new_from_db(row)
    end
    new_results
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    results = DB[:conn].execute(sql,name).flatten
    self.new_from_db(results)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 2
    SQL
    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1
    SQL
    result = DB[:conn].execute(sql)
    self.new_from_db(result[0])
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql,grade)
  end


  # def affect_db arg
  #   DB[:conn].execute(arg)
  # end
end
