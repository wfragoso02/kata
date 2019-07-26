require "spec_helper"

RSpec.describe Boxing::Kata do
  it "has a version number" do
    expect(Boxing::Kata::VERSION).not_to be nil
  end

  subject(:manager) { Manager.new('spec/fixtures/family_preferences.csv') }
  subject(:manager2) { Manager.new('lib/boxing/kata/patients.csv') }
  

  describe Manager do
    describe '#initialize' do
      it 'raises and error if instantiated with a non-existing file' do
        expect { Manager.new }.to raise_error(ArgumentError)
      end

      it 'returns a hash with the id number pointing to the row' do
        expect(manager.file).to be_a(Hash)
        expect(manager.file.values[0]).to be_a(Hash)
        expect(manager.file.keys[0]).to be_a(Integer)
      end
    end

    describe '#family_preference' do
      it 'returns a nested Array with the color and their respective amount sorted ASC' do
        expect(manager.family_preference[0][0]).to be_a(String)
        expect(manager.family_preference[0][1]).to be_a(Integer)
      end

      it 'returns a sorted(ASC) array' do
        expect(manager.family_preference[0][1]).to eq(2)
      end
    end

    describe '#starter_boxes' do
      it 'returns nil if no family preferences have been entered' do
        expect(Manager.new('spec/fixtures/empty_file.csv').starter_boxes).to be_nil
      end

      it 'each box should have at maximum 2 brushes and replacements heads' do
        expect(manager.starter_boxes[1][0]).to be <= 2
        expect(manager.starter_boxes[2][0]).to be <= 2
        expect(manager.starter_boxes[3][0]).to be <= 2
      end

      it 'returns a hash with the box number as a key and the box content as the value' do
        expect(manager.starter_boxes).to be_a(Hash)
        expect(manager.starter_boxes[1]).to be_a(Array)
        expect(manager.starter_boxes[1][0]).to be_a(Integer)
        expect(manager.starter_boxes[1][1]).to be_a(String)
        expect(manager.starter_boxes[1][1]).to eq('green')
        expect(manager.starter_boxes[1][0]).to eq(2)
      end
    end

    describe '#refills' do
      it 'returns nil if no family preferences have been entered' do
        expect(Manager.new('spec/fixtures/empty_file.csv').refills).to be_nil
      end

      it 'each box should have at maximum 4 replacements heads' do
        expect(manager.starter_boxes[1][0]).to be <= 4
        expect(manager.starter_boxes[2][0]).to be <= 4
        expect(manager.starter_boxes[3][0]).to be <= 4
      end

      it 'returns a hash with the box number as a key and the box content as the value' do
        expect(manager.refills).to be_a(Hash)
        expect(manager.refills[1]).to be_a(Array)
        expect(manager.refills[1][0]).to be_a(Integer)
        expect(manager.refills[1][1]).to be_a(String)
        expect(manager.refills[1][1]).to eq('green')
        expect(manager.refills[1][0]).to eq(2)
      end

    end

    describe '#scheduling' do
      it 'returns a hash with starter box and refill box as keys pointing to their respective values' do
        expect(manager.scheduling).to have_key(:STARTER_BOX)
        expect(manager.scheduling).to have_key(:REFILL_BOX)
      end

      it 'each box should have a schedule attached to it' do
        expect(manager.scheduling[:STARTER_BOX]["#{manager.file.keys.first}-schedule"]).to be_truthy
      end

      it 'the refills boxes have 4 scheduled shipment dates while the starter box have one' do
        expect(manager.scheduling[:STARTER_BOX]["#{manager.file.keys.first}-schedule"].split(", ").size).to eq(1)
        expect(manager.scheduling[:REFILL_BOX]["#{manager.file.keys.first}-schedule"].split(", ").length).to eq(4)
      end

      let(:dates) { manager.scheduling[:REFILL_BOX]["#{manager.file.keys.first}-schedule"].split(", ")}
      let(:first_date) { Date.strptime(dates[0].split(' ')[-1], '%Y-%m-%d') }
      let(:second_date) { Date.strptime(dates[1], '%Y-%m-%d') }
      let(:third_date) { Date.strptime(dates[2], '%Y-%m-%d') }
      let(:fourth_date) { Date.strptime(dates[3].split(' ')[0], '%Y-%m-%d') }
      it 'refill dates are 90 days apart' do
        expect(first_date + 90).to eq(second_date)
        expect(second_date + 90).to eq(third_date)
        expect(first_date + 270).to eq(fourth_date)
      end
    end

    describe '#mail_class' do
      it 'should return an object containing a key of mail class' do
        expect(manager.mail_class[:STARTER_BOX].keys.last).to include('mail_class')
        expect(manager.mail_class[:REFILL_BOX].keys.last).to include('mail_class')
      end

      it 'the mail key should havea value of first if the box weight is <= 16 0z, priority otherwise' do
        expect(manager.mail_class[:STARTER_BOX]["1-mail_class"]).to include('priority')
        expect(manager.mail_class[:REFILL_BOX]["1-mail_class"]).to include('first')
      end

    end

    describe '#paste_kits' do
      it 'add paste kits for each brush or replacement head' do
        expect(manager.paste_kits[:STARTER_BOX][1].last).to include('paste kit')
      end

      it 'readjusts the mail class to the appropriate mail class when each paste kit weigh 7.6 oz' do
        expect(manager.paste_kits[:STARTER_BOX]["1-mail_class"]).to include('priority')
        expect(manager.paste_kits[:REFILL_BOX]["1-mail_class"]).to include('priority')
      end


      it 'handles plurality' do
        expect(manager.paste_kits[:STARTER_BOX][3].last).to eq('paste kit')
        expect(manager.paste_kits[:STARTER_BOX][1].last).to eq('paste kits')
      end

    end

  end

  describe 'Replacement Module' do
    describe '#seperate_replacement_heads' do
      let(:example1) { ReplacementHead.seperate_replacement_heads(manager.family_preference) }
      it 'seperates the preference into their respective replacement heads number' do
        expect(example1).to have_key(:four_replacements)
        expect(example1).to have_key(:three_replacements)
        expect(example1).to have_key(:two_replacements)
        expect(example1).to have_key(:one_replacements)
      end

      it 'every replacement head is saved with its color' do
        expect(example1[:two_replacements][0][1]).to include('green')
        expect(example1[:two_replacements][1][1]).to include('blue')
      end
    end

    describe '#four_replacements_helper' do
      let(:example1) { ReplacementHead.four_replacements_helper([[4, "blue"], [4, "red"], [4, "yellow"]], Hash.new { |h, k| h[k] = [] }) }
      let(:ans) { {1=>[4, "blue"], 2=>[4, "red"], 3=>[4, "yellow"]} }
      it 'returns all the boxes and the next box number' do
        expect(example1).to have_key(:all_boxes)
        expect(example1).to have_key(:i)
        expect(example1[:i]).to eq(4)
        expect(example1[:all_boxes]).to eq(ans)
      end
    end

    describe '#three_replacements_helper' do
      let(:example1) { ReplacementHead.three_replacements_helper([[3, "blue"], [3, "red"]], [[1, "yellow"], [1, 'purple'], [1, "orange"]], Hash.new { |h, k| h[k] = [] }, 1) }
      let(:ans1) { {:all_boxes=>{1=>[3, "red", 1, "orange"], 2=>[3, "blue", 1, "purple"]}, :i=>3, :one_replacements=>[[1, "yellow"]]} }
      let(:example2) { ReplacementHead.three_replacements_helper([[3, "blue"], [3, "red"]], [], Hash.new { |h, k| h[k] = [] }, 1) }

      it 'fills boxes with the 3-1 combination first' do
        expect(example1[:all_boxes][1]).to eq([3, "red", 1, "orange"])
      end

      it 'fills boxes with 3 replacement heads' do
        expect(example2[:all_boxes][1]).to eq([3, "blue"])
        expect(example2[:all_boxes][2]).to eq([3, "red"])
      end

      it 'returns all the boxes and the following box number and the remainding one-replacement heads' do
        expect(example1).to have_key(:all_boxes)
        expect(example1).to have_key(:i)
        expect(example1).to have_key(:one_replacements)
        expect(example1[:one_replacements]).to eq([[1, "yellow"]])
      end
    end

    describe '#two_replacement_heads_helper' do
      let(:example) { ReplacementHead.two_replacement_heads_helper([[2, "blue"], [2, "green"], [2, "yellow"]], Hash.new { |h, k| h[k] = [] }, 1 ) }
      let(:ans) { {:solo_boxes=>[[2, "yellow"]], :i=>2, :all_boxes=>{1=>[2, "blue", 2, "green"]}} }
      it 'fills boxes with the 2-2 combination' do
        expect(example[:all_boxes][1]).to eq([2, "blue", 2, "green"])
      end

      it 'returns any unfilled boxes' do
        expect(example[:solo_boxes]).to eq([[2, "yellow"]])
      end

      it 'returns all the boxes, the following box number and the remainding unfilled' do
        expect(example).to have_key(:all_boxes)
        expect(example).to have_key(:i)
        expect(example).to have_key(:solo_boxes)
        expect(example[:i]).to eq(2)
      end
    end

    describe '#one_replacement_heads_helper' do
      let(:example1) { ReplacementHead.one_replacement_heads_helper([[1, "yellow"], [1, "green"], [1, "blue"], [1, "purple"], [1, "orange"]],Hash.new { |h, k| h[k] = [] }, 1 , [[2, "yellow"]]  ) }
      let(:ans) { {:solo_boxes=>[[2, "yellow"], [1, "orange"]], :i=>2, :all_boxes=>{1=>[1, "yellow", 1, "green", 1, "blue", 1, "purple"]}} }
      it 'fills boxes with the 1-1-1-1 combination' do
        expect(example1).to eq(ans)
        expect(example1[:all_boxes][1]).to eq([1, "yellow", 1, "green", 1, "blue", 1, "purple"])
      end

      it 'returns any unfilled boxes' do
        expect(example1[:solo_boxes]).to eq([[2, "yellow"], [1, "orange"]])
      end

      it 'returns all the boxes, the following box number and the remainding unfilled' do
        expect(example1).to have_key(:all_boxes)
        expect(example1).to have_key(:i)
        expect(example1).to have_key(:solo_boxes)
        expect(example1[:i]).to eq(2)
      end
    end

    describe '#solo_boxes_helper' do
      let(:example1) { ReplacementHead.solo_boxes_helper([[2, "blue"],[1, "yellow"], [1, "green"], [1, "orange"]], Hash.new { |h, k| h[k] = [] } , 1) }
      let(:ans1) { {1=>[2, "blue", 1, "yellow", 1, "green"], 2=>[1, "orange"]} }
      let(:example2) { ReplacementHead.solo_boxes_helper([[1, "yellow"], [1, "green"], [1, "orange"]], Hash.new { |h, k| h[k] = [] } , 1) }
      let(:ans2) { {1=>[1, "yellow", 1, "green", 1, "orange"]} }
      it 'fills boxes with the 2-1-1 combination' do
        expect(example1[1]).to eq([2, "blue", 1, "yellow", 1, "green"])
      end

      it 'fills the  rest of the boxes' do
        expect(example1[2]).to eq([1, "orange"])
        expect(example2[1]).to eq([1, "yellow", 1, "green", 1, "orange"])
      end

      it 'returns all the boxes' do
        expect(example1).to eq(ans1)
        expect(example2).to eq(ans2)
      end
    end
  end


  describe 'Helper Module' do
    describe '#box_weight' do
      let(:box1) { manager.scheduling[:STARTER_BOX][1] }
      let(:box2) { manager.scheduling[:REFILL_BOX][1] }
      let(:key1) { :STARTER_BOX }
      let(:key2) { :REFILL_BOX }

      let(:example1) { Helper.box_weight(key1, box1) }
      let(:example2) { Helper.box_weight(key2, box2) }
      let(:example3) { Helper.box_weight(key1, box1, 0) }
      let(:example4) { Helper.box_weight(key2, box2, 0) }
      it 'return a hash with a key of box_weight and paste_kits' do
        expect(example1).to have_key(:box_weight)
        expect(example1).to have_key(:paste_kits)
      end

      it 'find the weight of a refill box with only replacement heads and no paste kits' do
        expect(example2[:box_weight]).to eq(4)
      end

      it 'find the weight of a starter box with brushes(9oz) and replacement heads(1oz) and no paste kits' do
        expect(example1[:box_weight]).to eq(20)
      end

      it 'find the weight of a respective box with paste kits(7.6oz)' do
        expect(example3[:box_weight]).to eq(35.2)
        expect(example4[:box_weight]).to eq(34.4)
      end

      it 'returns the amount of paste kits that should go in each box' do
        expect(example4[:paste_kits]).to be_truthy
        expect(example2[:paste_kits]).to be_falsey
      end
    end

    describe '#mail_class_helper' do
      let(:heavy_box) { 20 }
      let(:light_box) { 3 }
      it 'returns the apporiate mail type based on the input box weight: BW >= 16 => priority; otherwise => first' do
        expect(Helper.mail_class_helper(heavy_box)).to include('priority')
        expect(Helper.mail_class_helper(light_box)).to include('first')
      end
    end

    describe '#years_worth_of_scheduling' do
      let(:date_string) { manager.file[manager.file.keys.first]['contract_effective_date'] }
      let(:first_date) { Date.strptime(date_string, '%Y-%m-%d') }
      let(:second_date) { Helper.years_worth_of_scheduling(first_date)[1] }

      it 'return 4 dates, starting with the first date' do
        expect(Helper.years_worth_of_scheduling(first_date).first).to eq(first_date)
        expect(Helper.years_worth_of_scheduling(first_date).count).to eq(4)
      end

      it 'returns the dates 90 days apart' do
        expect(second_date - first_date).to eq(90)
      end
    end
  end
end

