require 'uri'
require 'net/http'
require 'json'

def nasa_data_request(adress, api_key = 'DEMO_KEY')
    url = URI(adress+api_key)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    nasa_data_request = Net::HTTP::Get.new(url)
    nasa_data_request["cache-control"] = 'no-cache'
    nasa_data_request["Postman-Token"] = '1dfd61a9-ce7b-4481-9339-9882428ed9ae'
    
    response = http.request(nasa_data_request)
    JSON.parse response.read_body
end

def build_web_page(data_nasa_clean, n = 3)
    html_images = ""
    final_array = []
    n.times do |i|
        final_array.push(data_nasa_clean['photos'][i]['img_src'])
    end
    final_array.each do |e|
        html_images += "\t\t<li><img src=\"#{e}\"></li>\n"
    end
    doctype = 
    "<!DOCTYPE html>\n"+
    "<html lang='en'>\n"+
    "<head>\n"+
    "\t<meta charset='UTF-8'>\n"+
    "\t<meta name='viewport' content='width=device-width, initial-scale=1.0'>\n"+
    "\t<meta http-equiv='X-UA-Compatible' content='ie=edge'>\n"+
    "\t<title>Prueba Intro a Ruby</title>\n"+
    "</head>\n\n"+
    "<body>\n"+
    "\t<ul>\n\n"+
    "#{html_images}\n"+
    "\t</ul>\n"+
    "</body>\n"+
    "</html>\n"
    File.write('output.html', doctype)
end

def photos_count(data_nasa_clean)
    photos_camera = {}
    photos_camera['Camera'] = data_nasa_clean['photos'][0]['camera']['full_name']
    photos_camera['Photos'] = data_nasa_clean['photos'][0]['rover']['total_photos']
    puts "Successful"
    return photos_camera
end

data_nasa_clean = nasa_data_request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=', 'rtPRBo7pzcPM0ABPbzPRxNMDHEUU0KBiWCSMht2d')
photos_count(data_nasa_clean)
build_web_page(data_nasa_clean, 10)
