require 'rails_helper'

RSpec.describe VendingMachine, type: :model do
  describe "create machine" do
    it "creates an empty machine" do
      vend_machine = VendingMachine.new

      assert_empty vend_machine.products
      assert_empty vend_machine.change_collected.change
    end


    it "creates a loaded machine when provided products and change" do
      products = [Product.new('cola', 1.50)]
      change = [Change.new('£1')]

      vend_machine = VendingMachine.new products: products, change: change

      assert_equal 1, vend_machine.products.length
      assert_equal 'cola', vend_machine.products.first.name

      assert_equal 1, vend_machine.change_collected.amount
      assert_equal 1, vend_machine.change_collected.length
    end
  end


  describe "load machine" do
    let (:change) { [Change.new('50p')] }
    let (:products) { [Product.new('cola', 1.50)] }
    let (:vend_machine) do
      VendingMachine.new products: products, change: change
    end


    it "adds products" do
      new_cola = Product.new 'cola', 1.50
      new_products = [new_cola]

      assert_equal 1, vend_machine.products.length
      vend_machine.load_products new_products
      assert_equal 2, vend_machine.products.length
    end


    it "adds change" do
      new_change = Change.new '10p'

      assert_equal 0.50, vend_machine.change_collected.amount
      vend_machine.load_change new_change
      assert_equal 0.60, vend_machine.change_collected.amount
    end
  end


  describe "vend a product" do
    let (:change) { [Change.new('50p')] }
    let (:products) { [Product.new('cola', 1.50)] }
    let (:vend_machine) do
      VendingMachine.new products: products, change: change
    end


    it "raises NoProductError when the product is not available" do
      assert_raises VendingMachine::NoProductError do
        vend_machine.vend 'no_product'
      end
    end


    it "raises NotEnoughFunds when not enough change is inserted" do
      assert_equal 0.50, vend_machine.change_collected.amount
      assert vend_machine.insert_change(Change.new('£1'))
      assert_equal 1.00, vend_machine.change_inserted.amount

      assert_raises VendingMachine::NotEnoughFundsError do
        vend_machine.vend 'cola'
      end

      assert_equal 1, vend_machine.products.length
      assert_equal 0.50, vend_machine.change_collected.amount
    end


    it "vends product and refunds remaining change" do
      assert vend_machine.insert_change(Change.new('£1'))
      assert vend_machine.insert_change(Change.new('50p'))
      assert vend_machine.insert_change(Change.new('20p'))
      assert_equal 1.70, vend_machine.change_inserted.amount

      cola_before = vend_machine.products.find_all { |_product| _product.name == 'cola' }
      assert vend_machine.vend 'cola'
      cola_after = vend_machine.products.find_all { |_product| _product.name == 'cola' }
      assert_equal cola_after.length+1, cola_before.length

      assert_equal 0.20, vend_machine.change_inserted.amount
      assert_equal 0.20, vend_machine.change_inserted.change.first.value
      assert vend_machine.refund
    end
  end


  describe "insert change" do
    let (:products) { [Product.new('cola', 1.50)] }
    let (:vend_machine) do
      VendingMachine.new products: products
    end

    it "adds change when inserted"  do
      assert_equal 0, vend_machine.change_inserted.amount
      assert vend_machine.insert_change(Change.new('50p'))
      assert vend_machine.insert_change(Change.new('10p'))
      assert_equal 0.60, vend_machine.change_inserted.amount
    end
  end


  describe "refund" do
    let (:change) { [Change.new('50p')] }
    let (:products) { [Product.new('cola', 1.50)] }
    let (:vend_machine) do
      VendingMachine.new products: products, change: change
    end

    it "refunds no change when none inserted" do
      assert_equal 0, vend_machine.change_inserted.amount
      assert_equal 0.50, vend_machine.change_collected.amount

      assert_raises AASM::InvalidTransition do
        vend_machine.refund
      end

      assert_equal 0, vend_machine.change_inserted.amount
      assert_equal 0.50, vend_machine.change_collected.amount
    end


    it "refunds change when any inserted" do
      vend_machine.insert_change Change.new('10p')
      vend_machine.insert_change Change.new('50p')
      assert_equal 0.6, vend_machine.change_inserted.amount
      assert_equal 0.5, vend_machine.change_collected.amount

      assert vend_machine.refund
      assert_equal 0.0, vend_machine.change_inserted.amount
      assert_equal 0.5, vend_machine.change_collected.amount
    end
  end
end
