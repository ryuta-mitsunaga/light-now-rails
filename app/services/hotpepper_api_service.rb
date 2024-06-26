require 'addressable/uri'
require 'rexml/document'
require 'logger'

  class HotpepperApiService
  def initialize
    @key = ENV['HOTPEPPER_API_KEY']
    @url = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1/'
    @middle_area = 'Y050' # 池袋限定
  end
  
  # ホットペッパーのAPIを叩く
  def get_store_info(keyword, page, forLine = false, store_id = nil, from_name = nil)
    count = store_id.split(',').count if store_id
    
    uri = Addressable::URI.parse(@url)
    uri.query_values = {
      key: @key,
      keyword: keyword,
      middle_area: @middle_area,
      count: count,
      start: page * 10,
      id: store_id
    }
    res = Net::HTTP.get_response(uri)
    Rails.logger.debug(uri)
  
    doc = REXML::Document.new(res.body)
    
    # URLを別途取得
    urls = REXML::XPath.match(doc, "/results/shop/urls/pc")
    results_available = REXML::XPath.match(doc, "/results/results_available")[0].text
    genres = [REXML::XPath.match(doc, "/results/shop/genre"), REXML::XPath.match(doc, "/results/shop/sub_genre")]
    
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
      genre_elements = genres[0][i] && genres[1][i] ? [genres[0][i].elements["name"], genres[0][i].elements["catch"], genres[1][i].elements["name"]] : []
      
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
        title = "⭐️#{from_name}さんが気になっています⭐️"
        
        {
          "thumbnailImageUrl": logo,
          "imageBackgroundColor": "#FFFFFF",
          "title": title,
          "text": name[0..59],
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
