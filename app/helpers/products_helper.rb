module ProductsHelper

  def rating_icon(categories)
    categories.each do |category|
      if category == 'horse'
        return "horse-icon.png"
      elsif category == 'dog'
        return "dog-icon.png"
      elsif category == 'cat'
        return "cat-icon.png"
      elsif category == 'unicorn'
        return "unicorn-icon.jpeg"
      elsif category == 'hedgehog'
        return "hedge-icon.png"
      elsif category == 'chicken'
        return "chicken-icon.jpeg"
      elsif category == 'panda'
        return "panda-icon.png"
      elsif category =='narwhal'
        return "narwhal-icon.png"
      elsif category == 'fish'
        return "fish-icon.png"
      elsif category == 'ferret'
        return "ferret-icon.jpeg"
      elsif category == 'hamster'
        return "hamster-icon.png"
      elsif category == 'chinchilla'
        return "chinchilla-icon.png"
      elsif category == 'turtle'
        return "turtle-icon.png"
      elsif category =='pony'
        return "pony-icon.jpeg"
      else
        icon = "star-icon.png"
      end
    end
    return 'star-icon.png'
  end
end
