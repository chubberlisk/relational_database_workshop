require 'rspec/expectations'
require_relative './exceptions.rb'

system("clear")

include RSpec::Matchers

$setup = []
$koans = []

def xkoan _; end
def koan(name, &block)
  $koans << block
end

def dont_edit_this_bit(&block)
  $setup << block
end

def __change_me__
  fail('change me.')
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

printer = BacktracePrinter.new
printer.add_filter(RemoveKoanHarness.new)
printer.add_filter(RemoveRSpecStackTrace.new)

begin
  require_relative './start-here/00-the-path'
  require_relative './start-here/01-connections'

  number_of_koans = $koans.length.to_f
  koans_passed = 0
  $setup.each(&:call)

  $koans.each do |koan|
    koan.call
    koans_passed += 1
  end
rescue RuntimeError => e
  puts e.message
  printer.execute(e.backtrace)
rescue RSpec::Expectations::ExpectationNotMetError => e
  puts e.message
  printer.execute(e.backtrace)
rescue StandardError => e
  puts e.message
  printer.execute(e.backtrace)
end


puts "\n\n"

percentage_complete = (koans_passed / number_of_koans)
blocks_to_display = (10 * percentage_complete).to_i

print "Progress [" 
print colorize(('#' * blocks_to_display), 32)
print (' ' * (10 - blocks_to_display))
print "] (#{percentage_complete * 100} %)\n\n"

puts(
  colorize(
    "|-----[DATABASE DETAILS]-----|", 
    32
  )
)
puts "|-----------|----------------|"
puts "| USERNAME  | workshop       |"
puts "|-----------|----------------|"
puts "| PASSWORD  | secretpassword |"
puts "|-----------|----------------|"
puts "| HOSTNAME  | postgres       |"
puts "|-----------|----------------|"
puts "| PORT      | 5432           |"
puts "|-----------|----------------|"
puts "| DATABASE  | workshop_one   |"
puts "|-----------|----------------|"

sleep
