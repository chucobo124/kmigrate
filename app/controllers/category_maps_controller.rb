class CategoryMapsController < ApplicationController
  require 'csv'
  require 'net/http'
  before_action :set_category_map, only: %i[show edit update destroy]
  CARO_COLLECTION = 'https://api.carousell.com/api/2.1/collections/?country_code=TW'.freeze

  # GET /category_maps
  # GET /category_maps.json
  def index
    @category_maps = CategoryMap.all
  end

  # GET /category_maps/1
  # GET /category_maps/1.json
  def show; end

  # GET /category_maps/new
  def new
    @category_map = CategoryMap.new
  end

  # GET /category_maps/1/edit
  def edit; end

  # POST /category_maps
  # POST /category_maps.json
  def create
    @category_map = CategoryMap.new(category_map_params)

    respond_to do |format|
      if @category_map.save
        format.html { redirect_to @category_map, notice: 'Category map was successfully created.' }
        format.json { render :show, status: :created, location: @category_map }
      else
        format.html { render :new }
        format.json { render json: @category_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_maps/1
  # PATCH/PUT /category_maps/1.json
  def update
    respond_to do |format|
      if @category_map.update(category_map_params)
        format.html { redirect_to @category_map, notice: 'Category map was successfully updated.' }
        format.json { render :show, status: :ok, location: @category_map }
      else
        format.html { render :edit }
        format.json { render json: @category_map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_maps/1
  # DELETE /category_maps/1.json
  def destroy
    @category_map.destroy
    respond_to do |format|
      format.html { redirect_to category_maps_url, notice: 'Category map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload_with_csv
    csv = CSV.parse(csv_file.open.read)
    categories = {}
    api_collections = get_collections
    CategoryMap.all.delete_all
    csv.drop(2).each do |row|
      carousell_category = row[4]
      carousell_sub_category = row[5]

      categories[:kktwon_category] = row[0]
      categories[:kktwon_sub_category] = row[1]
      categories[:carousell_category] = carousell_category
      categories[:carousell_sub_category] = carousell_sub_category

      if api_collections[carousell_category].present?
        categories[:carousell_category_id] = api_collections[carousell_category]
      elsif api_collections[carousell_sub_category].present?
        categories[:carousell_category_id] = api_collections[carousell_sub_category]
      end

      CategoryMap.create(categories)
    end.compact
    redirect_to category_maps_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category_map
    @category_map = CategoryMap.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_map_params
    params.require(:category_map).permit(:kktwon_category, :kktwon_sub_category, :carousell_category, :carousell_sub_category, :carousell_category_id)
  end

  def csv_file
    params.require(:csv_file)
  end

  def get_collections
    retry_count = 0
    uri = URI.parse(CARO_COLLECTION)
    resp = Net::HTTP.get_response(uri)
    while (resp.code == '301' || resp.code == '302') && (retry_count < CONNECTION_RETRY)
      if resp.header['location'].present?
        resp = Net::HTTP.get_response(URI.parse(resp.header['location']))
      end
      next unless resp.body.present?
      collection_lists = JSON.parse(resp.body, symbolize_names: true)
    end

    return unless resp.body.present?
    collection_lists = JSON.parse(resp.body, symbolize_names: true)

    collection = {}
    if collection_lists.present?
      collection_lists.each do |collection_list|
        name = collection_list[:name]
        collection[name] = collection_list[:id]
      end
    end
    collection
  end
end
