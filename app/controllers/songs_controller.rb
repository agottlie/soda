class SongsController < ApplicationController
	include HTTParty
	before_action :require_user
  	before_action :require_current_user, only: [:show]
	before_action :set_song, only: [:show, :edit, :update, :destroy]
	
	def index
		@songs = Song.where(user_id: @current_user[:id]).order(:id)
		@artist = Artist.name
	end

	def show
	end

	def new
		@song = Song.new
		@artist = Artist.all
	end

	def create
		puts params[:add][:name]
		found = false
		artists = Artist.all
		artists.each do |artist|
			if artist[:name] == params[:add][:artist]
				@artist = artist
				found = true
			end
		end
		if !found
			@artist = Artist.new(name: "#{params[:add][:artist]}")
		end
		@song = Song.new(name: "#{params[:add][:name]}", votes: 0, user: @current_user, artist: @artist, spotify_id: "#{params[:add][:spotify_id]}")

		if @song.valid?
			@song.save
			redirect_to "/users/#{@current_user[:id]}"
		else 
			flash[:song] = @song.errors.messages
			redirect_back fallback_location: new_song_path
		end
	end

	def edit

	end

	def update
		@user = @current_user
		puts "HELLO"
		if @song.update(votes: "#{params[:update][:votes]}")
			redirect_to "/songs" 
		else 
			flash[:song] = @song.errors.messages
			redirect_back fallback_location: edit_song_path
		end
	end

	def destroy 
		@user = @current_user
		if @song.destroy 
			redirect_to "/songs"
		else
			flash[:error] = "Could not delete song."
			redirect_back fallback_location: edit_song_path 
		end
	end

	def query
		if params[:query][:artist] == "" && params[:query][:song] == ""
			@tracks = []
		else
			if params[:query][:artist] != "" && params[:query][:song] != ""
				artist = "artist:" + params[:query][:artist]
				song = "%20track:" + params[:query][:song]
			elsif params[:query][:artist] != ""
				artist = "artist:" + params[:query][:artist]
				song = ""
			else
				song = "track:" + params[:query][:song]
				artist = ""
			end

			spotify_token = HTTParty.post(
				"https://accounts.spotify.com/api/token",
				headers: {
					Authorization: "Basic " + ENV['SPOTIFY_API_TOKEN'],
				},
				body: {
					grant_type: "client_credentials"
				}
			)["access_token"]

			puts "SPOTIFY TOKEN"
			puts spotify_token
			url = "https://api.spotify.com/v1/search?q=" + artist + song + "&type=track"



			response = HTTParty.get(
				url,
				headers: {
					Authorization: "Bearer " + spotify_token
				}

			)

			@tracks = response["tracks"]["items"]
		end
		
		render :results
	end

	private
	
	def song_params
		params.require(:song).permit(:name, :genre, :votes, :spotify_id)
	end
	def set_song 
		@song = Song.find(params[:id])
	end

end
