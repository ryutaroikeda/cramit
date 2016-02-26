#!/usr/bin/env ruby
# File: cramit.rb

USAGE = <<ENDUSAGE
Usage:
  cramit [-h] [-f file]

  -h              View this message.
  -f file         Take test using file.
ENDUSAGE

def rand_perm(n)
  srand # seed the pseudorandom number generator
  a = [*1..n]
  r = []
  n.times do
    i = rand(n)
    r << a[i]
    a.delete_at(i)
    n -= 1
  end
  return r
end

def perm_table(table)
  l = table.length - 1
  p = rand_perm(l)
  t = [table[0]]
  (0...l).each do |i|
    t << table[p[i]]
  end
  return t
end

def put_question(query, answer)
  puts query
  input = STDIN.gets.chomp.downcase
  return input == answer
end

def put_test(table)
  number_of_questions = table.length - 1
  number_correct = 0
  (1...table.length).each do |i|
    is_correct = put_question(table[i][0], table[i][1])
    if is_correct
      number_correct += 1
    else
      puts "wrong, the correct answer is " + table[i][1]
    end
  end
  puts "You answered " + number_correct.to_s + " correctly out of " + \
    number_of_questions.to_s
end

def print_table(table)
  table.each do |r|
    r.each do |c|
      print "#{c},"
    end
    print "\n"
  end
end

if __FILE__ == $0
  ARGS = { :file => nil }
  UNFLAGGED_ARGS = []
  next_arg = UNFLAGGED_ARGS.first
  ARGV.each do |arg|
    case arg
    when '-h','--help'            then ARGS[:help] = true
    when '-f'                     then next_arg = :file
    else
      if next_arg
        ARGS[next_arg] = arg
        UNFLAGGED_ARGS.delete next_arg
      end
      next_arg = UNFLAGGED_ARGS.first
    end
  end
  if ARGS[:help] or not UNFLAGGED_ARGS.empty?
    puts USAGE
  end
  table = []
  if ARGS[:file]
    f = File.new ARGS[:file], "r"
    f.each_line do |line|
      table << line.split(",")
      table.last.each_index { |i| table.last[i] = table.last[i].strip }
    end
    f.close
  end
  table = perm_table(table)
  put_test(table)
end
