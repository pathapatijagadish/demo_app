class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    1.times do
      @question = @project.questions.build
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        kit = IMGKit.new(render_to_string(:partial => 'form', :layout => false,:locals => {:project => @project}))#it takes html and any options for wkhtmltoimage
        #kit.stylesheets << "#{Rails.root.to_s}/app/assets/stylesheets/application.css" #its apply the give css to the converted image 
        t1= "#{self.class.helpers.asset_digest_path("application.css")}"
        #render :text=>t1 and return false
        #  v.stylesheets <<  "/#{self.class.helpers.asset_digest_path("application‌​.css")}"
        kit.stylesheets << "#{Rails.root}/public/assets/" + t1
        img   = kit.to_img(:png)
        file  = Tempfile.new(["template_#{@project.id}", 'png'], 'tmp',
                             :encoding => 'ascii-8bit')
        file.write(img)
        file.flush
        @project.avatar = file
        @project.save
        file.unlink
        format.html { redirect_to root_url, notice: 'Flyer was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        kit = IMGKit.new(render_to_string(:partial => 'form', :layout => false,:locals => {:project => @project}))#it takes html and any options for wkhtmltoimage
        #kit.stylesheets << "#{Rails.root.to_s}/app/assets/stylesheets/ImgKit.css" #its apply the give css to the converted image 
        t1= "#{self.class.helpers.asset_digest_path("application.css")}"
        #  v.stylesheets <<  "/#{self.class.helpers.asset_digest_path("application‌​.css")}"
        kit.stylesheets << "#{Rails.root}/public/assets/" + t1
        img   = kit.to_img(:png)
        file  = Tempfile.new(["template_#{@project.id}", 'png'], 'tmp',
                             :encoding => 'ascii-8bit')
        file.write(img)
        file.flush
        @project.avatar = file
        @project.save
        file.unlink
        format.html { redirect_to root_url, notice: 'Flyer was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Flyer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      #params.require(:project).permit(:name, :description,:question_attributer)
      params.require(:project).permit(:name,:description,:avatar,questions_attributes: [:id,:project_id,:subject,:content,:_destroy])
    end
end
