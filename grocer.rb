def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item|
    item.each do |item_name, item_info|
      if !consolidated[item_name]
        consolidated[item_name] = item_info
        consolidated[item_name][:count] = cart.count(item)
      end
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  updated = {}

  cart.each do |item_name, item_info|
    coupons.each do |coupon|
      if item_name == coupon[:item] && item_info[:count] >= coupon[:num]
        cart[item_name][:count] -= coupon[:num]

        if updated.has_key?("#{item_name} W/COUPON")
          updated["#{item_name} W/COUPON"][:count] += 1
        else
          updated.merge!({"#{item_name} W/COUPON" => {:price => coupon[:cost], :clearance => item_info[:clearance], :count => 1}})
        end
      end
    end
  end
  updated.merge!(cart)
end

def apply_clearance(cart)
  cart.each do |item_name, item_info|
    if item_info[:clearance] == true
      item_info[:price] = (item_info[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  updated_cart = apply_coupons(cons_cart, coupons)
  final_cart = apply_clearance(updated_cart)

  total = 0

  final_cart.each do |item_name, item_info|
    total += (item_info[:price] * item_info[:count])
  end

  if total > 100
    total = (total * 0.9).round(2)
  end

  total
end
