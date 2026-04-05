require "test_helper"

class AddressTest < ActiveSupport::TestCase
  def valid_attrs
    {
      user: users(:customer),
      full_name: "Test User",
      phone: "9876543210",
      address_line1: "123 Test St",
      city: "Bengaluru",
      state: "Karnataka",
      pincode: "560001",
      country: "India",
      address_type: :home
    }
  end

  test "valid address" do
    assert Address.new(valid_attrs).valid?
  end

  test "invalid without full_name" do
    addr = Address.new(valid_attrs.merge(full_name: nil))
    assert_not addr.valid?
    assert_includes addr.errors[:full_name], "can't be blank"
  end

  test "invalid without phone" do
    addr = Address.new(valid_attrs.merge(phone: nil))
    assert_not addr.valid?
  end

  test "invalid with malformed pincode" do
    addr = Address.new(valid_attrs.merge(pincode: "12345"))
    assert_not addr.valid?
    assert addr.errors[:pincode].any?
  end

  test "invalid with malformed phone" do
    addr = Address.new(valid_attrs.merge(phone: "1234567890"))
    assert_not addr.valid?
    assert addr.errors[:phone].any?
  end

  test "valid 10-digit phone starting with 6-9" do
    addr = Address.new(valid_attrs.merge(phone: "6789012345"))
    assert addr.valid?
  end

  test "address_type enum works" do
    assert addresses(:customer_home).home?
    assert addresses(:customer_office).work?
  end

  test "belongs to user" do
    assert_equal users(:customer), addresses(:customer_home).user
  end
end
