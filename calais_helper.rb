require 'rubygems'
require 'simple_http'
require "rexml/document"
require 'pp'
require 'api_key'
include REXML
include ApiKey


raise(StandardError,"Set Open Calais login key in ENV: 'OPEN_CALAIS_KEY'") if !CALAIS_KEY

PARAMS = "&paramsXML=" + CGI.escape('<c:params xmlns:c="http://s.opencalais.com/1/pred/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><c:processingDirectives c:contentType="text/html" c:outputFormat="xml/rdf"></c:processingDirectives><c:userDirectives c:allowDistribution="true" c:allowSearch="true" c:externalID="17cabs901" c:submitter="ABC"></c:userDirectives><c:externalMetadata></c:externalMetadata></c:params>')
require 'digest/sha2'


module CalaisHelper



  def get_tags(text)
    data = "licenseID=#{CALAIS_KEY}&content=" + CGI.escape(text)

      http = SimpleHttp.new "http://api.opencalais.com/enlighten/calais.asmx/Enlighten"
      response = CGI.unescapeHTML(http.post(data+PARAMS))


    h = {}
    if response.include?('<Error Method="ProcessText"')
      puts "Error parsing at Calais end"
    else
      index1 = response.index('terms of service.-->')
      index1 = response.index('<!--', index1)
      index2 = response.index('-->', index1)
      txt = response[index1+4..index2-1]
      lines = txt.split("\n")
      lines.each {|line|
        index = line.index(":")
        h[line[0...index]] = line[index+1..-1].split(',').collect {|x| x.strip} if index
      }
    end
    h
  end 

end

