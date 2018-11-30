class Startup

  def initialize
    command = "export SECRET_KEY=QUIETPLEASE"
    current_directory_contents = `ls`
    current_directory_contents = `#{command}`
    puts current_directory_contents
    puts "hi"
  end

  startup = Startup.new

  def self.list
    current_directory_contents = `ls`
    current_directory_contents = `#{command}`
    puts current_directory_contents
    puts "hi"
  end
end