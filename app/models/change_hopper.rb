class ChangeHopper
  attr_reader :change


  def initialize change = []
    @change = change
  end


  def add change
    raise ArgumentError unless change.all? { |c| c.kind_of? Change }
    @change += change
  end


  def amount
    change.map(&:value).reduce(0, :+)
  end


  def issue amount
    # Holds a collected change that is issued at the end
    issue_change = ChangeHopper.new
    issue_amount = 0

    change.sort! { |a, b| a.value <=> b.value }.reverse_each do |_change|
      break if issue_amount >= amount

      # if the coin is less than the amount to issue back
      if _change <= (amount - issue_amount)
        issue_change.add [_change]
        issue_amount += _change.value
      end
    end

    @change -= issue_change.change

    issue_change
  end


  def length
    change.length
  end
end
