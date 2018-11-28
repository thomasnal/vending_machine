class VendingMachine
  include AASM

  class NoProductError < StandardError; end
  class NotEnoughFundsError < StandardError; end

  attr_reader :change_collected, :change_inserted, :products


  aasm do
    state :empty, :initial => true
    state :waiting, after_enter: Proc.new {
      no_product? && transition_to_empty
    }
    state :paid, after_enter: Proc.new {
      no_change_inserted? && transition_to_waiting
    }


    after_all_transitions :log_status_change


    event :load_products do
      transitions :from => :empty, :to => :waiting, :after => :do_load_products
      transitions :from => :waiting, :to => :waiting, :after => :do_load_products
    end


    event :load_change do
      transitions :from => :empty, :to => :empty, :after => :do_load_change
      transitions :from => :waiting, :to => :waiting, :after => :do_load_change
    end


    event :insert_change do
      transitions :from => :waiting, :to => :paid, :after => :do_insert_change
      transitions :from => :paid, :to => :paid, :after => :do_insert_change
    end


    event :refund do
      transitions :from => :paid, :to => :waiting, :after => :do_refund
    end


    event :transition_to_empty do
      transitions :from => :waiting, :to => :empty, :if => :no_product?
    end


    event :transition_to_waiting do
      transitions :from => :paid, :to => :waiting, :if => :no_change_inserted?
    end


    event :vend do
      error do |e, product_name|
        raise NoProductError if e.failures.include?(:product_available?)
        raise NotEnoughFundsError if e.failures.include?(:can_pay?)

        if aasm.current_state != :paid
          raise NoProductError unless product_available? product_name
          raise NotEnoughFundsError if can_pay? product_name
        end
      end

      transitions :from => :paid, :to => :paid,
        :if => [:product_available?, :can_pay?],
        :after => :do_vend
    end
  end


  def initialize **args
    @products = []
    load_products args.fetch(:products, [])
    @change_collected = ChangeHopper.new(args.fetch(:change, []))
    @change_inserted = ChangeHopper.new
  end


  def change_collected
    @change_collected
  end


  private


  def can_pay? product_name
    product = products.find { |_product| _product.name == product_name }
    change_inserted.amount >= product.price
  end


  def do_insert_change change
    change_inserted.add Array(change)
  end


  def do_load_change new_change
    @change_collected.add Array(new_change)
  end


  def do_load_products new_products
    @products += new_products
  end


  def do_refund
    @change_inserted = ChangeHopper.new
  end


  def do_vend product_name
    product = products.find { |_product| _product.name == product_name }

    refund_amount = @change_inserted.amount - product.price
    @change_collected.add @change_inserted.change
    @change_inserted = @change_collected.issue refund_amount
    products.delete product
  end


  def last_product?
    products.length == 1
  end


  def no_change_inserted?
    change_inserted.amount == 0
  end


  def no_product?
    products.empty?
  end


  def not_last_product?
    products.length > 1
  end


  def make_empty_if_no_product
    products.length == 0
  end


  def product_available? product_name
    products.find { |prod| prod.name == product_name }
  end


  def log_status_change
    msg = "changing from #{aasm.from_state}"
    msg += " to #{aasm.to_state} (event: #{aasm.current_event})"

    puts msg
  end
end
