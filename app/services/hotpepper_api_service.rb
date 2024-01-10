require 'addressable/uri'
require 'rexml/document'
require 'logger'

class HotpepperApiService
  def initialize
    @key = ENV['HOTPEPPER_API_KEY']
    @url = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    @middle_area = 'Y050' # 池袋限定
    @count = 10
  end
  
  # ホットペッパーのAPIを叩く
  def get_store_info(keyword, page, forLine = false, store_id = nil)
    uri = Addressable::URI.parse(@url)
    uri.query_values = {
      key: @key,
      keyword: keyword,
      middle_area: @middle_area,
      count: @count,
      start: page * 10,
      id: store_id
    }
    res = Net::HTTP.get_response(uri)
    Rails.logger.debug()
  
    doc = REXML::Document.new(res.body)
    
    # URLを別途取得
    urls = REXML::XPath.match(doc, "/results/shop/urls/pc")
    results_available = REXML::XPath.match(doc, "/results/results_available")[0].text
    
    # [
    #   name,
    #   logo,
    #   address,
    #   description,
    #   url,
    #   id,
    #   genre
    # ]
    columns = REXML::XPath.match(doc, "/results/shop").map.with_index do |shop, i|
      name_element =  shop.elements["name"]
      logo_element = shop.elements["logo_image"]
      address_element = shop.elements["address"]
      description_element = shop.elements["catch"]
      id_element = shop.elements["id"]
      
      Rails.logger.debug("gener_elements: #{genre_elements}")
      
      name = name_element ? name_element.text : nil
      logo = logo_element ? logo_element.text : nil
      address = address_element ? address_element.text : nil
      description = description_element ? description_element.text : nil
      id = id_element ? id_element.text : nil
      url = urls[i].text
      genre = genre_elements.map { |genre_element| genre_element ? genre_element.text : nil }.join(' / ')
      
      description_text = <<TEXT
#{address}

#{description}
TEXT
      if forLine then
        {
          "thumbnailImageUrl": logo,
          "imageBackgroundColor": "#FFFFFF",
          "title": name[0..39],
          "text": description_text.length > 60 ? description_text[0..59] : description_text,
          "defaultAction": {
            "type": "uri",
            "label": "View detail",
            "uri": "http://example.com/page/123"
          },
          "actions": [
            {
              "type": "uri",
              "label": "詳しくみる",
              "uri": url
            }
          ]
        } 
      else 
        {
          name: name,
          logo: logo,
          address: address,
          description: description,
          url: url,
          id: id,
          genre: genre
        }
      end
    end
    
  {
    columns: columns,
    results_available: results_available
  }
  
  end
end
