class GoogleBooksController < ApplicationController

	response = HTTpary.get('https://www.googleapis.com/books/v1/volumes?q=')

	GET https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes&key=yourAPIKey

	intitle: inauthor: inpublisher: subject: isbn: Iccn: 

	puts response.body, response.code, response.message, response.headers.inspect

	response.each do |item|
		puts item['title']['author']['publisher']['subjects']['isbn']
	end

	


end
