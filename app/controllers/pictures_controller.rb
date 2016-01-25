class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:home]
  # GET /pictures
  # GET /pictures.json
  def home
    if user_signed_in?
       index
       render :index
    else
      render :home
    end
  end
  
  def index
    @pictures = current_user.pictures.where(mark:0)
    @trash_pictures=current_user.pictures.where(mark:1)
  # @pictures = Picture.all
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show

  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    @picture.mark=0
    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove
    @picture = Picture.find(params[:id])
    if @picture.update(:mark => 1)
      redirect_to :back
    end
  end

  def download
    @picture = Picture.find(params[:id])
    send_file(@picture.image.path,:dispositon=>'attachment')
  end

  def undo_remove
    @picture = Picture.find(params[:id])
    if @picture.update(:mark=>0)
      redirect_to :back
    end
  end

  def app_filter
    @picture = Picture.find(params[:id])
    @filters=Filter.all
    # render :file => 'app/views/pictures/app_filter.html.erb'
  end

  def do_filter
    @filters=Filter.all
    @picture=Picture.find(params[:picture_id])
    filter=Filter.find(params[:filter_id])
    img=Magick::Image.read("public" + @picture.image.to_s).first
    method=filter.filter_m[0,filter.filter_m.length]
    thumb=img.send(method)
    
#     write
     thumb.write("public/images/#{current_user.id}#{@picture.id}.jpg")
     @ModifiedImages="#{current_user.id}#{@picture.id}.jpg"    
  end
  
  def saveFilteredImage
    @url=params[:url]
   # @filteredImage=Picture.new
    @picture=Picture.find(params[:id])
    render :file => 'app/views/pictures/saveFilteredImage.html.erb'
  end
  
  def save_image
    @filteredImage=Picture.new
    @originalPicture=Picture.find(params[:picture_id])
    @picture_url=@originalPicture.image.url.to_s
    for i in 1..@picture_url.length+1
      if @picture_url[-i]=="/"
        url = @picture_url[0,(@picture_url.length-i+1)]
        break
      end
    end
    modifiedImage_url=params[:picture_url]
    image=Magick::Image.read("public/images/#{modifiedImage_url}").first
    image_url="public#{url}#{modifiedImage_url}"
    image.write("public#{url}#{modifiedImage_url}")
    @image_url=File.open(File.join(Rails.root , image_url))
    @filteredImage.name = params[:name]
    @filteredImage.tag=params[:tag]
    @filteredImage.image=@image_url
    @filteredImage.mark=0
    @filteredImage.user_id=current_user.id
    @filteredImage.save
    @picture=@filteredImage
    render :file => 'app/views/pictures/show.html.erb'
  end

  def share
    @users=User.all.select{|user| user!=current_user}
    @picture = Picture.find(params[:id])
    render :file => 'app/views/pictures/share.html.erb'
  end

  def shareImage
    if PicturesUsers.addsharedpicture(params[:picture_id],params[:user_id])
      flash[:notice]="The image has been shared successfully!^.^"
    else
      flash[:notice]="Fail to share!"    
    end   
    redirect_to :back                                                                                                          
  end
  
def search
  @pictures=Picture.where(:tag=>params[:input])
  
end
  def showSharedImage
    @shared_images=[]
    PicturesUsers.where(:user_id => current_user.id).each do |p|
      @shared_images << Picture.find(p.picture_id)
    end
 
  end

  def trash
    @trash_pictures=current_user.pictures.where(mark:1)
  end

  def clear_trash
    @trash_pictures=current_user.pictures.where(mark:1)
    @trash_pictures.each do |picture|
      picture.destroy
    end
    redirect_to trash_picture_path
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_picture
    @picture = Picture.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def picture_params
    params.require(:picture).permit(:picture_path, :name, :user_id, :image,:mark,:tag,:filter_id)
  end
end
