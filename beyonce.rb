require 'sinatra'
require 'sinatra/reloader'

enable :sessions
enable :method_override

# # videos = ["FHp2KgyQUFk", "LXXQLa-5n5w", "QczgvUDskk0"]

# get '/' do
# 	#pass result back to index.erb
# 	result = "//www.youtube.com/embed/" + videos.sample
# 	erb :index, :locals => {:result => result}
# end

get '/sets' do
	session["sets"] ||= {}
	erb :sets, :locals => {:result => session["sets"]}
end

get '/sets/new' do
	erb :new
end

post '/sets' do
	session["sets"] ||= {}
	vidArray = params[:links].split(/[\r\n]+/)
	vidArray2 = vidArray.map do |tag|
		tag.strip
	end
	session["sets"].store(params[:name], {"name" => params[:name], "vidnums" => vidArray2, "description" => params[:descrip]})
	erb :sets, :locals => {:result => session["sets"]}
end

# this page lists all the key-value pairs in the session hash.
get '/session' do
	session.inspect
end

get '/sets/:name' do
	erb :custom, :locals => {:result => session["sets"][params[:name]]}
end

get '/sets/:name/play' do
	url = "http://www.youtube.com/embed/?playlist=" + (session["sets"][params[:name]]["vidnums"].join(","))
	erb :play, :locals => {:result => url}
end

get '/sets/:name/edit' do
	erb :edit, :locals => {:result => session["sets"][params[:name]]}
end

put '/sets' do
	session["sets"] ||= {}
	vidArray = params[:links].split(/[\r\n]+/)
	vidArray2 = vidArray.map do |tag|
		tag.strip
	end
	session["sets"].store(params[:name], {"name" => params[:name], "vidnums" => vidArray2, "description" => params[:descrip]})
	redirect to ('/sets')
end

get '/' do
	erb :index
end

delete '/sets' do
	session["sets"] ||= {}
	session["sets"].delete(params[:name])
	redirect to ('/sets')
end

