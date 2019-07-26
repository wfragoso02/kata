module Printable
  # this method expects the return value from the Manager#family_preference method
  def self.brush_preferences(preferences)
    puts 'BRUSH PREFERENCES'
    preferences.each { |color| puts "#{color[0]}: #{color[1]}" }
    nil
  end

  # this method expects the return value from the Manager#starter_boxes method
  def self.starter_boxes(boxes)
    return 'NO STARTER BOXES GENERATED' unless boxes

    boxes.keys.each do |key|
      puts 'STARTER BOX'
      i = 0
      while i < boxes[key].length
        puts "#{boxes[key][i]} #{boxes[key][i + 1]} " + 'brush'.pluralize(boxes[key][i])
        puts "#{boxes[key][i]} #{boxes[key][i + 1]} replacement " 'head'.pluralize(boxes[key][i])
        i += 2
      end
      puts ' '
    end
    nil
  end

  # this method expects the return value from the Manager#refills method
  def self.refills(boxes)
    return 'PLEASE GENERATE STARTER BOXES FIRST' unless boxes

    boxes.keys.each do |key|
      puts 'REFILL BOX'
      ele = boxes[key]
      i = ele.length - 1
      while i.positive?
        puts "#{ele[i - 1]} #{ele[i]} replacement " 'head'.pluralize(ele[i - 1])
        i -= 2
      end
      puts ' '
    end
    nil
  end

  # this method can take care of printing for the following Manager methods:
  # => #scheduling
  # => #mail_class
  # => #paste_kits
  def self.full_print(all_boxes)
    all_boxes.keys.each do |key|
      ele = all_boxes[key]
      ele.keys.each do |inner_key|
        if inner_key.is_a? Numeric
          if all_boxes[key][inner_key][-1].include?('paste kit')
            box = all_boxes[key][inner_key][0...-2]
            paste_kits = all_boxes[key][inner_key][-2..-1].join(' ')
          else
            box = all_boxes[key][inner_key]
          end
          j = box.length - 1
          puts key.to_s
          while j.positive?
            puts "#{box[j - 1]} #{box[j]} " + 'brush'.pluralize(box[j - 1]) if key == :STARTER_BOX
            puts "#{box[j - 1]} #{box[j]} replacement " 'head'.pluralize(box[j - 1])
            j -= 2
          end
          puts paste_kits if paste_kits
          puts all_boxes[key]["#{inner_key}-schedule"] if all_boxes[key]["#{inner_key}-schedule"]
          puts all_boxes[key]["#{inner_key}-mail_class"] if all_boxes[key]["#{inner_key}-mail_class"]
          puts ' '
        end
      end
    end
    nil
  end
end
