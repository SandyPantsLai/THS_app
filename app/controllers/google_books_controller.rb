class GoogleBooksController < ApplicationController



endrequire "httparty"
 2: HTTParty.get("https://www.googleapis.com/books/v1/volumes?q="
 3: "the quick br0won forx "
 4: CGI.escape("the quick br0won forx ")
 5: HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=" + CGI.escape("blood meridian") )
 6: json = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=" + CGI.escape("blood meridian") )
 7: json.class
 8: json.items
 9: json["items"]
10: json["items"].first
11: json["items"].count
12: json["items"].first
13: json["items"].first["volumeInfo"]
14: json["items"].first["volumeInfo"]["title"]
15: json["items"]
16: json["items"].count
17: json["items"].first
18: json["items"].each do |item|
19:   {
20:     title: item["volumeInfo"]["title"]
21:   }
22: end
23: json["items"].map do |item|
24:   {
25:     title: item["volumeInfo"]["title"]
26:   }
27: end
28: history
29: json["items"].first
30: item = json["items"].first
31: item["volumeInfo"]
32: item["volumeInfo"]["title"]