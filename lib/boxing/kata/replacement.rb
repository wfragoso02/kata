module ReplacementHead
  def self.seperate_replacement_heads(preferences)
    four_replacements = []
    three_replacements = []
    two_replacements = []
    one_replacements = []

    preferences.each do |preference|
      color = preference[0]
      num = preference[1]
      new_num = num % 4
      boxes_push = num / 4
      boxes_push.times { |_num| four_replacements.push([4, color]) }
      one_replacements.push([new_num, color]) if new_num.equal?(1)
      two_replacements.push([new_num, color]) if new_num.equal?(2)
      three_replacements.push([new_num, color]) if new_num.equal?(3)
    end
    { four_replacements: four_replacements, three_replacements: three_replacements,
      two_replacements: two_replacements, one_replacements: one_replacements }
  end

  def self.four_replacements_helper(four_replacements, all_boxes, index = 1)
    i = index
    four_replacements.each do |ele|
      all_boxes[i].push(*ele)
      i += 1
    end
    { i: i, all_boxes: all_boxes }
  end
  
  def self.three_replacements_helper(three_replacements, one_replacements, all_boxes, index)
    i = index
    until three_replacements.empty? || one_replacements.empty?
      all_boxes[i].push(*three_replacements[-1])
      all_boxes[i].push(*one_replacements[-1])
      three_replacements.pop
      one_replacements.pop
      i += 1
    end
    three_replacements.each { |box| all_boxes[i].push(*box) && i += 1 }
    { all_boxes: all_boxes, i: i, one_replacements: one_replacements }
  end
  
  def self.two_replacement_heads_helper(two_replacements, all_boxes, index)
    i = index
    solo_boxes = []
  
    if two_replacements.length.odd?
      solo_boxes.push(two_replacements[-1])
      two_replacements.pop
    end
  
    two_replacements.each_with_index do |box, idx|
      ele = box.flatten
      all_boxes[i].push(*ele)
      i += 1 if idx.odd?
    end
  
    { solo_boxes: solo_boxes, i: i, all_boxes: all_boxes }
  end
  
  def self.one_replacement_heads_helper(one_replacements, all_boxes, i, solo_boxes)
    one_replacements_remains = one_replacements.length % 4
    one_replacements_remains.times do |_|
      solo_boxes.push(one_replacements[-1])
      one_replacements.pop
    end
  
    one_replacements.each_with_index do |box, idx|
      all_boxes[i].push(*box)
      i += 1 if idx == one_replacements.length - 1 || (idx + 1 % 4).zero? && idx.positive?
    end
  
    { solo_boxes: solo_boxes, i: i, all_boxes: all_boxes }
  end
  
  def self.solo_boxes_helper(solo_boxes, all_boxes, i)
    solo_boxes.each_with_index do |box, idx|
      all_boxes[i].push(*box)
      if solo_boxes[0][0] == 2
        if idx >= 2 || idx == solo_boxes.length - 1
          i += 1
        end
      elsif (idx % 3).zero? && idx.positive? || idx == solo_boxes.length - 1
        i += 1
      end
    end
    all_boxes
  end
  
end