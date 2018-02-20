# input
# r c l h : number of rows, columns, min number of each T or M, H max number of
# total cells, all between 1 and 1_000
# MMTTMM
# goal is to maximize total number of cels in slices (slice is square subset)
#
# output
# S : total number of slices
# x1 y1 x2 y2 : coordinate of first and last cell in slice (0 0) (2 1)
PRODUCTION = true
if PRODUCTION
  def ppp(_arg = nil); end

  def pp(_arg = nil); end
else
  require 'pp'
  require './ppp'
  require 'byebug'
end

def solution(a:, l:, h:)
  { n: 1, r: [] }
end

if PRODUCTION
  r, c, l, h = gets.split(' ').map &:to_i
  a = []
  r.times do
    # strip is needed since on hackerrank, new line is at the end of gets
    r = gets.strip.split('').map { |c| c == 'M' ? 0 : 1 }
    a << r
  end
  n, r = solution(a: a, l: l, h: h).values_at :n, :r
  puts n
  r.each do |row|
    puts row.join(' ')
  end
end # if PRODUCTION
