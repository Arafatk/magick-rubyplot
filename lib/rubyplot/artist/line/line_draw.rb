# This class helps draw line graphs for both "y axis data" and for "x-y axis data".
class Rubyplot::Line < Rubyplot::Artist
  # Call with target pixel width of graph (800, 400, 300), and/or 'false' to omit lines (points only).
  #  g = Rubyplot::Line.new(400) # 400px wide with lines.
  #
  #  g = Rubyplot::Line.new(400, false) # 400px wide, no lines
  #
  #  g = Rubyplot::Line.new(false) # Defaults to 800px wide, no lines
  def initialize(*args)
    raise ArgumentError, 'Wrong number of arguments' if args.length > 2
    if args.empty? || (!(Numeric === args.first) && !(String === args.first))
      super()
    else
      super args.shift # TODO: Figure out a better alternative here.
    end

    @reference_lines = {}
    @reference_line_default_color = 'red'
    @reference_line_default_width = 5

    @hide_dots = @hide_lines = false
    @show_vertical_markers = false
    @dot_style = 'circle' # Options present for Circle and Square dot style.

    @maximum_x_value = nil
    @minimum_x_value = nil
  end

  # Get the value if somebody has defined it.
  def baseline_value
    @reference_lines[:baseline][:value] if @reference_lines.key?(:baseline)
  end

  # Set a value for a baseline reference line.
  def baseline_value=(new_value)
    @reference_lines[:baseline] ||= {}
    @reference_lines[:baseline][:value] = new_value
  end

  def draw_reference_line(reference_line, left, right, top, bottom)
    @d = @d.push
    @d.stroke_color(@reference_line_default_color)
    @d.fill_opacity 0.0
    @d.stroke_dasharray(10, 20)
    @d.stroke_width(reference_line[:width] || @reference_line_default_width)
    @d.line(left, top, right, bottom)
    @d = @d.pop
  end

  def draw
    super
    return unless @has_data

    # Check to see if more than one datapoint was given. NaN can result otherwise.
    @x_increment = @column_count > 1 ? (@graph_width / (@column_count - 1).to_f) : @graph_width

    if @show_vertical_markers # false in the base case
      (0..@column_count).each do |column|
        x = @graph_left + @graph_width - column.to_f * @x_increment

        @d = @d.fill(@marker_color)

        @d = @d.line(x, @graph_bottom, x, @graph_top)
        # If the user specified a marker shadow color, draw a shadow just below it
        unless @marker_shadow_color.nil?
          @d = @d.fill(@marker_shadow_color)
          @d = @d.line(x + 1, @graph_bottom, x + 1, @graph_top)
        end
      end
    end

    @norm_data.each do |data_row|
      # Initially the previous x,y points are nil and then
      # they are set with values.
      prev_x = prev_y = nil

      @one_point = contains_one_point_only?(data_row)

      data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
        x_data = data_row[DATA_VALUES_X_INDEX]
        if x_data.nil?
          new_x = @graph_left + (@x_increment * index)
          draw_label(new_x, index)
        else
          new_x = get_x_coord(x_data[index], @graph_width, @graph_left)
          @labels.each do |label_pos, _|
            draw_label(@graph_left + ((label_pos - @minimum_x_value) * @graph_width) / (@maximum_x_value - @minimum_x_value), label_pos)
          end
        end
        unless data_point # we can't draw a line for a null data point, we can still label the axis though
          prev_x = prev_y = nil
          next
        end
        new_y = @graph_top + (@graph_height - data_point * @graph_height)
        # Reset each time to avoid thin-line errors.
        #  @d = @d.stroke data_row[DATA_COLOR_INDEX]
        # @d = @d.fill data_row[DATA_COLOR_INDEX]
        @d = @d.stroke_opacity 1.0
        @d = @d.stroke_width line_width ||
                             clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 4), 5.0)

        circle_radius = dot_radius ||
                        clip_value_if_greater_than(@columns / (@norm_data.first[DATA_VALUES_INDEX].size * 2.5), 5.0)

        if !@hide_lines && !prev_x.nil? && !prev_y.nil?
          @d = @d.line(prev_x, prev_y, new_x, new_y)
        elsif @one_point
          # Show a circle if there's just one_point
          @d = DotRenderers.renderer(@dot_style).render(@d, new_x, new_y, circle_radius)
        end

        unless @hide_dots
          @d = DotRenderers.renderer(@dot_style).render(@d, new_x, new_y, circle_radius)
        end

        prev_x = new_x
        prev_y = new_y
      end
    end

    @d.draw(@base_image)
  end

  # Returns the X co-ordinate of a given data point.
  def get_x_coord(x_data_point, width, offset)
    x_data_point * width + offset
  end
end