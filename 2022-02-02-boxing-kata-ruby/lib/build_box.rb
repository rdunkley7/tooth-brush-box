class BuildBox

  attr_accessor :colors, :blue_count, :green_count, :pink_count, :contract_start_date, :starter_boxes

  def initialize(hashed_data)
    @colors = hashed_data.map {|x| x.values[2]}
    @blue_count = 0
    @green_count = 0
    @pink_count = 0
    date = hashed_data.map {|x| x.values[4]}.first
    @contract_start_date = Date.parse(date.to_s).strftime("%Y-%m-%d")  if date
    @starter_boxes = false
  end

  def count_brush_colors
    @colors.each do |color|
      @blue_count += 1 if color === 'blue'
      @green_count += 1 if color === 'green'
      @pink_count += 1 if color === 'pink'
    end
    puts 'BRUSH PREFERENCES'
    puts 'blue: ' + @blue_count.to_s
    puts 'green: ' + @green_count.to_s
    puts 'pink: ' + @pink_count.to_s
  end

  def build_starter_box
    return puts 'NO STARTER BOXES GENERATED' if @colors.count < 1

    @starter_boxes = true
    colors_array = load_colors_array
    colors_hash = load_colors_hash(colors_array)

    # Check if any color has more than 1 so they can be grouped
    colors_hash.each do |color, count|
      group_color(colors_array, colors_hash, color.to_s) if count > 1
    end

    # Slice out the leftover single brush color
    single_starter_box(colors_array)
  end

  def group_color(colors_array, colors_hash, brush_color)
    until colors_hash[:"#{brush_color}"] < 2
      puts 'STARTER BOX'
      puts '2 ' + brush_color + ' brushes'
      puts '2 ' + brush_color + ' replacement heads'
      puts '2 paste kits'
      puts 'Mail class: ' + calculateMailClass(2, 'starter')
      puts 'Schedule: ' + @contract_start_date
      colors_hash[:"#{brush_color}"] -= 2
      2.times { colors_array.delete_at(colors_array.index(brush_color)) }
    end
  end

  def single_starter_box(colors_array)
    until colors_array.count === 0
      box = colors_array.slice!(0, 2).to_a
      puts 'STARTER BOX'
      box.each do |brush|
        puts '1 ' + brush + ' brushes'
        puts '1 ' + brush + ' replacement heads'
      end
      puts box.count.to_s + ' paste kit(s)'
      puts 'Mail class: ' + calculateMailClass(box.count, 'starter')
      puts 'Schedule: ' + @contract_start_date
    end
  end

  def build_refill_box
    return puts 'PLEASE GENERATE STARTER BOXES FIRST' unless @starter_boxes == true
    colors_array = load_colors_array
    colors_hash = load_colors_hash(colors_array)

    # check if we more than 1 of the same color group it -
    # if we only have 1 of a color - used for leftover box
    colors_hash.each do |color, count|
      refill_group_color(colors_array, colors_hash, color.to_s) if count > 1
    end

    # single color brushes leftover
    until colors_array.count === 0
      refill_single_color(colors_array)
    end
  end

  def refill_group_color(colors_array, colors_hash, brush_color)
    # since we have more than 1 blue, but less than 4 blues
    # if we have 4 or more blue, box them together.
    until colors_hash[:"#{brush_color}"] < 4
      puts 'REFILL BOX'
      puts '4 ' + brush_color + ' replacement heads'
      puts '4 paste kits'
      puts 'Mail class: ' + calculateMailClass(4, 'refill')
      puts 'Schedule: ' + schedule_refills.join(', ')
      colors_hash[:"#{brush_color}"] -= 4
      4.times { colors_array.delete_at(colors_array.index(brush_color))}
    end

    # Now we have more than 1 of a color & less than 4 (ie 2 or 3)
    box_hash = {blue: 0, green: 0, pink: 0}
    box_hash[:"#{brush_color}"] += colors_hash[:"#{brush_color}"]
    colors_hash[:"#{brush_color}"] -= colors_hash[:"#{brush_color}"]

    # keep track of how many total are in the box
    # & remove from our colors_array to know what's leftover
    box = colors_array.select { |color| color ===  brush_color }
    colors_array.delete(brush_color)

    until box.count === 4
      next_brush = colors_array.shift
      box.push(next_brush)
      box_hash[:"#{next_brush}"] += 1
      colors_hash[:"#{next_brush}"] -= 1
    end

    puts 'REFILL BOX'
    box_hash.each do |color, count |
      puts "#{count} #{color} replacement heads" unless count < 1
    end
    puts box.count.to_s + ' paste kit(s)'
    puts 'Mail class: ' + calculateMailClass(box.count, 'refill')
    puts 'Schedule: ' + schedule_refills.join(', ')
  end

  def refill_single_color(colors_array)
    box = colors_array.slice!(0, 4).to_a
    puts 'REFILL BOX'
    box.each do |brush|
      puts '1 ' + brush + ' replacement head'
    end
    puts box.count.to_s + ' paste kit(s)'
    puts 'Mail class: ' + calculateMailClass(box.count, 'refill')
    puts 'Schedule: ' + schedule_refills.join(', ')
  end

  def schedule_refills
    # until the next_date is more than 1 yr away, keep adding 90
    next_date = Date.parse(@contract_start_date)
    refill_dates = []
    while Date.parse(@contract_start_date) + 365 > next_date + 90 do
      next_date += 90
      refill_dates << next_date
    end
    refill_dates
  end

  def calculateMailClass(box_count, box_type)
    brush_weight = 9.0
    paste_kit_weight = 7.6
    replacement_weight = 1.0
    box_weight = 0

    if box_type === 'refill'
      # all heads & kits
      heads = box_count * replacement_weight
      kits = box_count * paste_kit_weight
      box_weight = heads + kits
    end

    if box_type === 'starter'
      # brushes + kits + heads
      brushes = box_count * brush_weight
      heads = box_count * replacement_weight
      kits = box_count * paste_kit_weight
      box_weight = brushes + kits + heads
    end

    return box_weight >= 16 ? 'Priority' : 'First'
  end

  def load_colors_array
    colors_array = []
    @colors.each {|x| colors_array << x }
    colors_array.sort! { |a, b| a <=> b }
    colors_array
  end

  def load_colors_hash(colors_array)
    colors_hash = {blue: 0, green: 0, pink: 0}
    colors_array.each do |color|
      colors_hash[:"#{color}"] += 1
    end
    colors_hash
  end
end
