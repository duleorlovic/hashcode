# input
# r c l h : number of rows, columns, min number of each T or M, H max number of
# total cells, all between 1 and 1_000
# MMTTMM
# goal is to maximize total number of cels in slices (slice is square subset)
#
# output
# S : total number of slices
# x1 y1 x2 y2 : coordinate of first and last cell in slice (0 0) (2 1)
#
# points: example 15, small 27, medium 1433, big 7131
require 'pp'
require './ppp'
require 'byebug'

def solution(aa:, l:, h:)
  # create prefix sum and expand slice as much as you can
  # slice has max h, x*y <=h
  # slice has sum >= l (T) and sum <= x*y - l (M = total - sum >= l)
  # .   .   . .     .
  # . (a,b) . .  (a,b+y)
  # .   .   . .     .
  # .   .   . .     .
  # .(a+x,b). .  (a+x,b+y)
  # .   .   . .     .
  #
  marked = Array.new(aa.length) { Array.new(aa[0].length) }
  results = []

  aa.each_with_index do |row, i|
    row.each_with_index do |el, j|
      next if marked[i][j]
      next if el == 0

      # find non marked 1
      # increase slice to match minimum l, than increase to match max (keep min)
      slice = [[i, j], [i, j]]
      # try all squares x*y <= h and use which sum is ~ l, total is h
      max_slice = nil
      max_slice_area = 0
      max_slice_sum = 1_000_000
      h.downto(1) do |x|
        (h/x).downto(1) do |y|
          0.upto(x-1) do |drift_x|
            0.upto(y-1) do |drift_y|
              slice = drifted_point(i, j, x, y, drift_x, drift_y)
              next unless is_inside?(aa, slice)
              next unless at_least_at_most?(aa, l, slice)
              next unless is_not_already_marked?(marked, slice)
              current_sum = slice_sum(aa, slice)
              current_area = slice_area(slice)
              if max_slice.nil?
                max_slice = slice
                max_slice_area = current_area
                max_slice_sum = current_sum
              end
              # puts "SUM=#{current_sum} x=#{x},y=#{y},drift_x=#{drift_x},drift_y=#{drift_y}"
              # ppp slice
              if current_sum < max_slice_sum
                max_slice = slice
                max_slice_area = current_area
                max_slice_sum = current_sum
              elsif current_sum == max_slice_area && current_area > max_slice_area
                max_slice = slice
                max_slice_area = current_area
                max_slice_sum = current_sum
              else

              end
            end
          end
        end
      end

      if max_slice
        mark(marked, max_slice)
        results << max_slice
      end
    end # row.each_with_index do |el, j|
  end # aa.each_with_index do |row, i|

  results
end

def drifted_point(i, j, x, y, drift_x, drift_y)
  [
    [i - drift_x, j - drift_y],
    [i - drift_x + x - 1, j - drift_y + y - 1]
  ]
end

def is_inside?(aa, slice)
  max_x = aa.length - 1
  max_y = aa[0].length - 1
  a, b = slice[0]
  c, d = slice[1]
  return false if a < 0
  return false if b < 0
  return false if c < 0
  return false if d < 0
  return false if a > max_x
  return false if c > max_x
  return false if b > max_y
  return false if d > max_y
  true
end

def is_not_already_marked?(marked, slice)
  a, b = slice[0]
  c, d = slice[1]
  marked[a..c].each do |row|
    row[b..d].each do |el|
      return false if el
    end
  end
  true
end

def mark(marked, slice)
  a, b = slice[0]
  c, d = slice[1]
  (a..c).each do |x|
    (b..d).each do |y|
      marked[x][y] = true
    end
  end
  marked
end

def submatrix(aa, slice)
  a, b = slice[0]
  c, d = slice[1]
  res = []
  (a..c).each do |x|
    row = []
    (b..d).each do |y|
      row << aa[x][y]
    end
    res << row
  end
  res
end

def slice_area(slice)
  a, b = slice[0]
  c, d = slice[1]
  (c - a + 1) * (d - b + 1)
end

def slice_sum(aa, slice)
  # sum of this slice:
  # s(a,b,c,d) = ps(c,d) - (ps(a-1,d) + ps(c,b-1) - ps(a-1,b-1))
  ps = prefix_sum(aa)
  a, b = slice[0]
  c, d = slice[1]
  sum = if a == 0
          if b == 0
            ps[c][d]
          else
            ps[c][d] - (0 + ps[c][b-1] - 0)
          end
        else
          if b == 0
            ps[c][d] - (ps[a-1][d] + 0 - 0)
          else
            ps[c][d] - (0 + ps[c][b-1] - ps[a-1][b-1])
          end
        end
  sum
end

def at_least_at_most?(aa, l, slice)
  a, b = slice[0]
  c, d = slice[1]
  sum = slice_sum(aa, slice)
  # s >= l && s <= x*y - l
  sum >= l && sum <= (c - a + 1) * (d - b + 1) - l
end

def prefix_sum(aa)
  return @prefix_sum if @prefix_sum
  # prefix_sum[i,j] = prefix_sum[0,0]+...+prefix_sum[0,j]+prefix_sum[1,0]+...+prefix_sum[1,j]+....prefix_sum[i,j]
  @prefix_sum = []
  aa.each_with_index do |row, i|
    row_sum_array = []
    sum = 0
    row.each_with_index do |el, j|
      sum += el
      if i == 0
        row_sum_array << sum
      else
        row_sum_array << sum + @prefix_sum[i - 1][j]
      end
    end
    @prefix_sum << row_sum_array
  end
  @prefix_sum
end

def marked_sum(marked)
  return @marked_sum if @marked_sum
  @marked_sum = []
  marked.each_with_index do |row, i|
    row_sum_array = []
    sum = 0
    row.each_with_index do |el, j|
      sum += el
      if i == 0
        row_sum_array << sum
      else
        row_sum_array << sum + @marked_sum[i - 1][j]
      end
    end
    @marked_sum << row_sum_array
  end
  @marked_sum
end

if ARGV.length == 1
  file_name = ARGV.last
  r, _c, l, h = gets.split(' ').map(&:to_i)
  aa = []
  r.times do
    # strip is needed since on hackerrank, new line is at the end of gets
    aa << gets.strip.split('').map { |c| c == 'M' ? 1 : 0 }
    # { val: 1, marked: false, important: false } : { val: 0, marked: false, important: false}  }
  end
  results = solution(aa: aa, l: l, h: h)
  File.open "#{file_name}_output", 'w' do |file|
    puts results.length
    file.puts results.length
    results.each do |row|
      puts row.join(' ')
      file.puts row.join(' ')
    end
  end
end
