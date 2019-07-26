require 'byebug'
require 'rubygems'
require 'csv'
require 'json'
require 'american_date'
require 'active_support/inflector'
require_relative 'helper'
require_relative 'replacement'
# frozen_string_literal: true

# this class will hold all the methods that a manager will need
# to do his day to day duties based off the documentation on the
# kata
# module Manager
class Manager
  attr_reader :file
  # When initialized with the csv file, the rest of this
  # class' methods will have access to the json version
  # of the file for manipulation
  def initialize(file = ' ')
    raise ArgumentError, 'Please check the file path or existence of the file in this directory' unless File.exist?(file)

    lines = CSV.open(file).readlines
    keys = lines.shift
    @file = {}
    lines.each do |values|
      hash = Hash[keys.zip(values.map { |val| val })]
      @file[hash['id'].to_i] = hash
    end
  end

  def family_preference
    colors = Hash.new(0)
    @file.values.each do |key|
      color = key['brush_color']
      colors[color] += 1
    end
    colors.sort_by { |_color, num| num }.reverse
  end

  def starter_boxes
    return nil if @file == {}

    preferences = family_preference
    all_boxes = Hash.new { |h, k| h[k] = [] }
    i = 1
    partial_stack = []
    preferences.each_with_index do |preference, idx|
      color = preference[0]
      num = preference[1]
      partial_stack.push(1, color) if num.odd?
      if (partial_stack.length % 4).zero? && partial_stack.length.positive? || (idx == preferences.length - 1)
        all_boxes[i].push(*partial_stack)
        partial_stack = []
        i += 1
      end
      boxes_push = num / 2
      boxes_push.times { |_num| all_boxes[i].push(2, color) && i += 1 }
    end
    all_boxes
  end

  def refills
    return nil if @file == {}

    preferences = family_preference
    all_boxes = Hash.new { |h, k| h[k] = [] }
    replacement_heads = ReplacementHead.seperate_replacement_heads(preferences)
    temp = ReplacementHead.four_replacements_helper(replacement_heads[:four_replacements], all_boxes)
    temp = ReplacementHead.two_replacement_heads_helper(replacement_heads[:two_replacements], temp[:all_boxes], temp[:i])
    solo_boxes = temp[:solo_boxes]
    temp = ReplacementHead.three_replacements_helper(replacement_heads[:three_replacements], replacement_heads[:one_replacements], temp[:all_boxes], temp[:i])
    temp = ReplacementHead.one_replacement_heads_helper(temp[:one_replacements], temp[:all_boxes], temp[:i], solo_boxes)
    ReplacementHead.solo_boxes_helper(temp[:solo_boxes], temp[:all_boxes], temp[:i])
  end

  def scheduling
    date = @file[@file.keys.first]['contract_effective_date']
    shipping_date = Date.strptime(date, '%Y-%m-%d')
    started_boxes = starter_boxes
    box_refill = refills
    all_boxes = { STARTER_BOX: started_boxes, REFILL_BOX: box_refill }
    started_boxes.keys.each { |key| all_boxes[:STARTER_BOX]["#{key}-schedule"] = "Schedule: #{shipping_date}" }
    dates = Helper.years_worth_of_scheduling(shipping_date)
    box_refill.keys.each { |key| all_boxes[:REFILL_BOX]["#{key}-schedule"] = "Schedule: #{dates.join(', ')} " }
    all_boxes
  end

  def mail_class
    schedule = scheduling
    schedule.keys.each do |key|
      schedule[key].keys.each do |inner_key|
        if inner_key.is_a? Numeric
          box = schedule[key][inner_key]
          box_weight = Helper.box_weight(key, box)[:box_weight]
          schedule[key]["#{inner_key}-mail_class"] = Helper.mail_class_helper(box_weight)
        end
      end
    end
    schedule
  end

  def paste_kits
    mail = mail_class
    mail.keys.each do |key|
      mail[key].keys.each do |inner_key|
        if inner_key.is_a? Numeric
          box = mail[key][inner_key]
          box_weight = Helper.box_weight(key, box, 0)[:box_weight]
          paste_kit = Helper.box_weight(key, box, 0)[:paste_kits]
          mail[key][inner_key].push(paste_kit, 'paste ' + 'kit'.pluralize(paste_kit))
          mail[key]["#{inner_key}-mail_class"] = Helper.mail_class_helper(box_weight)
        end
      end
    end
    mail
  end
end
