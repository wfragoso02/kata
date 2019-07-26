module Helper

  def self.box_weight(key, box, paste_kit = nil)
    num = 0
    box.each do |ele|
      if ele.is_a? Numeric
        key == :REFILL_BOX ? num += ele : num += ele * 10;
        paste_kit += ele if paste_kit
      end
    end
    num += paste_kit * 7.6 if paste_kit
    { box_weight: num, paste_kits: paste_kit }
  end

  def self.mail_class_helper(box_weight)
    if box_weight >= 16
      'Mail class: priority'
    else
      'Mail class: first'
    end
  end

  def self.years_worth_of_scheduling(first_date)
    dates = [first_date]
    3.times { |_| dates.push((first_date += 90)) }
    dates
  end
end