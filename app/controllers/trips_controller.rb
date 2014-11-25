class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def data
    user_trips = Trip.where user: current_user
    trip_locations = user_trips.pluck(:location)
    trip_transportations = user_trips.pluck(:transportation)

    # lunch_dates = user_lunches.pluck(:lunch_date)
    raise
    render json: {trips: trip_locations}
  end

  # GET /trips
  # GET /trips.json
  def index
    @trips = current_user.trips
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @locations = @trip.locations
    @transportations = @trip.transportations
  end


  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)
    @trip.owner = current_user

    respond_to do |format|
      if @trip.save
        current_user.trip_users.create(user_id: current_user, trip_id: @trip.id)
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip, transportation: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip, transportation: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @trip = Trip.find(params[:id])
    @trip.liked_by current_user
    respond_to do |format|
      format.html {redirect_to :back }
      format.json { render json: { count: @trip.liked_count } }
    end
  end

  def downvote
    @trip = Trip.find(params[:id])
    @trip.disliked_by current_user
    respond_to do |format|
      format.html {redirect_to :back }
      format.json { render json: { count: @trip.liked_count } }
    end
  end

  def upvote_location
    @location = Location.find(params[:id])
    @location.liked_by current_user
    respond_to do |format|
      format.html {redirect_to :back }
      format.json { render json: { count: @location.liked_count } }
    end
  end

  def downvote_location
    @location = Location.find(params[:id])
    @location.disliked_by current_user
    respond_to do |format|
      format.html {redirect_to :back }
      format.json { render json: { count: @location.liked_count } }
    end
  end

  def upvote_transportation
    @transportation = Transportation.find(params[:id])
    @transportation.liked_by current_user
    respond_to do |format|
      format.html {redirect_to :back }
      format.json { render json: { count: @transportation.liked_count } }
    end
  end

  def downvote_transportation
    @transportation = Transportation.find(params[:id])
    @transportation.disliked_by current_user
    respond_to do |format|
      format.html {redirect_to :back }
      format.json { render json: { count: @transportation.liked_count } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
      @current_user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:name, :start_date, :end_date,
        :locations_attributes => [:name, :id, :_destroy])
    end
end
