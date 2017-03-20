require 'net/http'

class Search
  include ActiveModel::Model
  attr_accessor :value
  attr_reader :price, :url

  def search
    a = []
    a << get_saturn
    a << get_media_markt
    a << get_neo24
    get_cheapest = a.sort_by { |i| i[:price] }.first
    @price = get_cheapest[:price]
    @url = get_cheapest[:url]

    { url: url, price: price }
  end

  def get_saturn
    host ='https://saturn.pl'
    search_path = "/search?sort=price_asc&limit=1&query%5Bmenu_item%5D=&query%5Bquerystring%5D=#{value}"
    price_selector = '.m-priceBox_price.price'
    url_selector = '.js-product-name'

    cheapest_product(host, search_path, price_selector, url_selector)
  end

  def get_media_markt
    begin
      host = 'https://mediamarkt.pl'
      search_path = "/search?sort=price_asc&limit=1&query%5Bmenu_item%5D=&query%5Bquerystring%5D=#{value}"
      price_selector = '.m-priceBox_price.price'
      url_selector = '.js-product-name'

      cheapest_product(host, search_path, price_selector, url_selector)
    rescue
      @url = nil
      @price = nil
    end
  end

  def get_neo24
    begin
      host = 'http://www.neo24.pl'
      search_path = "?dispatch=es_search_php.index&params[query]=#{value}&params[sort]=price_asc"
      price_selector = '.product-price'
      url_selector = '.product-header a'

      cheapest_product(host, search_path, price_selector, url_selector)
    rescue
      @url = nil
      @price = nil
    end
  end

  private

  def cheapest_product(host, search_path, price_selector, url_selector)
    uri = URI("#{host}#{search_path}")
    page = Nokogiri::HTML(Net::HTTP.get(uri))
    {
      price: product_price(page, price_selector),
      url: product_url(host, page, url_selector)
    }
  end

  def product_price(page, selector)
    return if (p = page.css(selector).first&.text).blank?
    p.gsub(/\s/, '')
  end

  def product_url(host, page, selector)
    return if (path = page.css(selector).
               first&.attributes.try(:[], 'href')&.value).blank?
    path&.start_with?("/") ? (host + path) : path
  end
end
