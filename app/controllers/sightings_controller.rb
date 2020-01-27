class SightingsController < ApplicationController
    def index
        @sightings = Sighting.all
        if params[:filter] == "true"
            @sightings = @sightings.filter_by_date(params[:start_date], params[:end_date]).filter_by_region(params[:region_id])
        end
    end
    
    def show
        @sighting = Sighting.find(params[:id])
    end
    
    def new
        @animal = Animal.find(params[:animal_id])
        @sighting = @animal.sightings.new
    end
    
    def create
        if params[:commit] == 'Filter Reports'
            if params[:sighting][:start_date].blank? \
                || params[:sighting][:end_date].blank? \
                || params[:sighting][:region_id].blank?
                    redirect_to sightings_path(filter_error: true)
            else
                redirect_to sightings_path(
                    filter: true, 
                    start_date: params[:sighting][:start_date],
                    end_date: params[:sighting][:end_date],
                    region_id: params[:sighting][:region_id])
            end
        elsif params[:commit] == 'View All Reports'
            redirect_to sightings_path(view_all: true)
        else
            @animal = Animal.find(params[:sighting][:animal_id])
            @sighting = @animal.sightings.create(sighting_params)
            if @sighting.save
                redirect_to animal_path(@animal)
            else
                render 'new'
            end
        end
    end

    def edit
        @animal = Animal.find(params[:animal_id])
        @sighting = @animal.sightings.find(params[:id])
    end

    def update
        @animal = Animal.find(params[:sighting][:animal_id])
        @sighting = @animal.sightings.find(params[:id])
        if @sighting.update(sighting_params)
            redirect_to animal_path(@animal)
        else
            render 'edit'
        end
    end

    def destroy
        @animal = Animal.find(params[:animal_id])
        @sighting = @animal.sightings.find(params[:id])
        @sighting.destroy
        redirect_to animal_path(@animal)
    end

    private
    def sighting_params
        params.require(:sighting).permit(:animal_id, :date,:latitude,:longitude,:region_id)
    end

end
