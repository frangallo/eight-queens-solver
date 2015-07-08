class Board

  def initialize n
    @grid = Array.new(n) { Array.new(n) { "-" } }
    @size = n
  end

  def display
    @grid.each { |row| puts row.join(" ") }
    puts ""
  end

  def [] pos
    row, col = pos
    @grid[row][col]
  end

  def []= pos, mark
    row, col = pos
    @grid[row][col] = mark
  end

  def solved?
    q_in_rows = @grid.all? { |row| contains_queen?(row) }
    q_in_cols = @grid.transpose.all? { |col| contains_queen?(col) }
    q_in_rows && q_in_cols
  end

  def contains_queen? line
    line.include? "Q"
  end

  def valid_move?(pos)
    row, col = pos
    !(@grid[row].include?("Q") || @grid.transpose[col].include?("Q") ||
            diagonals(row,col).include?("Q"))
  end

  def diagonals(row,col)
    diagonals = []
    (0...@size).each do |i|
      if row + i < @size && col + i < @size
        diagonals << @grid[row + i][col + i]
      end
      if row - i >= 0 && col + i < @size
        diagonals << @grid[row - i][col + i]
      end
      if row - i >= 0 && col - i >= 0
        diagonals << @grid[row - i][col - i]
      end
      if row + i < @size && col - i >= 0
        diagonals << @grid[row + i][col - i]
      end
    end
    diagonals
  end
end

class Solver
  def initialize size = 8
    @board = Board.new(size)
    @size = size
  end

  def find_solution(board = @board)
    board.display

    if board.solved?
      puts "Win"
      return true
    end

    (0...@size).each do |row|
      (0...@size).each do |col|
        if board.valid_move?([row, col])
          board[[row, col]] = "Q"

          return true if find_solution(board)

          board[[row, col]] = "-"
        end
      end
    end

    return false
  end

  def find_random_solution
    @board[[rand(@size), rand(@size)]] = "Q"
    find_solution
  end
end
